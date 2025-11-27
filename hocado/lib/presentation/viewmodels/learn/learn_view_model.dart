import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
import 'package:hocado/utils/string_utils.dart';

class LearnViewModel extends AsyncNotifier<LearnState> {
  final String did;
  final LearningSettings settings;

  LearnViewModel(this.did, this.settings);

  FlashcardRepository get _flashRepo => ref.read(flashcardRepositoryProvider);
  StudySessionRepository get _sessionRepo =>
      ref.read(studySessionRepositoryProvider);
  UserFlashcardProgressRepo get _flashcardProgressRepo =>
      ref.read(userFlashcardProgressRepoProvider);
  fb_auth.User? get _currentUser => ref.read(currentUserProvider);
  LearningActivityRepository get _activityRepo =>
      ref.read(learningActivityRepositoryProvider);
  UserDeckProgressRepository get _deckProgressRepo =>
      ref.read(userDeckProgressRepositoryProvider);

  @override
  FutureOr<LearnState> build() async {
    final user = _currentUser;
    if (user == null) throw Exception('User not logged in');

    // 1. Lấy tất cả flashcard của deck
    final allCards = await _flashRepo.getFlashcardsByDeckId(did);

    // 2. Lấy tất cả flashcard đã có progress
    final progressList = await _flashcardProgressRepo.getProgressForDeck(
      user.uid,
      did,
    );

    // 3. Lấy danh sách ID của các thẻ được gắn sao
    final starredCardIds = progressList
        .where((p) => p.isStarred)
        .map((p) => p.fid)
        .toSet(); // dùng Set để tìm nhanh hơn

    // 4. Nếu settings yêu cầu chỉ học thẻ có sao → lọc theo ID
    var pool = settings.studyStarredOnly
        ? allCards.where((card) => starredCardIds.contains(card.fid)).toList()
        : List<Flashcard>.from(allCards);

    // if (pool.isEmpty) throw Exception('Not flashcard to learn');

    // 5. Trộn thẻ nếu có
    if (settings.shuffle) pool.shuffle();

    // 6. Lấy số flashcard học trong mỗi session
    final selected = selectFlashcard(progressList, pool);

    // 7. sinh question cho mỗi card
    final questions = generateQuestion(selected, pool);

    // 8. tạo session
    final session = StudySession.empty().copyWith(
      uid: user.uid,
      did: did,
      totalCards: questions.length,
      mode: StudyMode.learn.name,
    );

    return LearnState(
      session: session,
      questions: questions,
      currentIndex: 0,
      correctCount: 0,
      incorrectCount: 0,
      isFinished: false,
      flashcardProgresses: progressList,
    );
  }

  List<Question> generateQuestion(
    List<Flashcard> selected,
    List<Flashcard> pool,
  ) {
    final questions = <Question>[];

    for (final card in selected) {
      final qType = (List<String>.from(
        settings.questionTypes,
      )..shuffle()).first;

      final q = Question.fromFlashcard(
        questionType: qType,
        questionFormat: settings.questionFormat,
        flashcard: card,
        distractorPool: pool,
      );
      questions.add(q);
    }
    return questions;
  }

  List<Flashcard> selectFlashcard(
    List<UserFlashcardProgress> progressList,
    List<Flashcard> pool,
  ) {
    // Map progress theo fid
    final progressMap = {
      for (final p in progressList) p.fid: p,
    };

    // 1. Ưu tiên flashcard chưa có progress
    final newCards = pool
        .where((card) => !progressMap.containsKey(card.fid))
        .toList();

    // 2. Nếu chưa đủ, thêm các card có reviewCount thấp nhất
    List<Flashcard> selected = [];
    if (newCards.isNotEmpty) {
      selected.addAll(newCards.take(settings.defaultRounds));
    }

    while (selected.length < settings.defaultRounds) {
      final remaining = pool
        ..sort((a, b) {
          final pa = progressMap[a.fid];
          final pb = progressMap[b.fid];
          return (pa?.reviewCount ?? 0).compareTo(pb?.reviewCount ?? 0);
        });

      selected.addAll(remaining);
    }

    selected = selected.take(settings.defaultRounds).toList();

    // 3. Shuffle nếu có cài đặt
    if (settings.shuffle) selected.shuffle();
    return selected;
  }

  UserAnswer createAnswer({
    required Question question,
    required dynamic userResponse,
    int timeSpent = 0,
  }) {
    final correctAnswer = question.answer;
    bool isCorrect = false;
    double accuracy = 0;

    if (question.type == QuestionTypes.written.name) {
      accuracy = StringUtils.stringSimilarity(userResponse, correctAnswer);
      isCorrect = accuracy >= 0.75;
    } else {
      isCorrect = userResponse == correctAnswer;
    }

    final userAnswer = UserAnswer(
      fid: question.fid,
      qid: question.qid,
      questionType: question.type,
      userResponse: userResponse,
      correctAnswer: correctAnswer,
      isCorrect: isCorrect,
      accuracy: accuracy,
      timeSpent: timeSpent,
    );

    return userAnswer;
  }

  // user trả lời
  Future<void> nextQuestion(UserAnswer userAnswer) async {
    var s = state.value;

    if (s == null || s.isFinished || s.currentQuestion == null) return;

    // Tính quality
    final quality = calculateQuality(userAnswer);
    final q = s.currentQuestion!;

    _updateProgress(q.fid, quality);

    // cập nhật lại state
    s = state.value!;

    final correct = quality >= 3;
    final nextIndex = s.currentIndex + 1;
    final finished = nextIndex >= s.questions.length;

    //  Cập nhật state để chuyển câu
    final currentUserAnswers = List<UserAnswer>.from(s.userAnswers);
    currentUserAnswers.add(userAnswer);

    final updated = s.copyWith(
      currentIndex: nextIndex,
      correctCount: s.correctCount + (correct ? 1 : 0),
      incorrectCount: s.incorrectCount + (correct ? 0 : 1),
      isFinished: finished,
      userAnswers: currentUserAnswers,
    );
    state = AsyncData(updated);

    if (finished) {
      await _finishSession();
    }
  }

  void _updateProgress(String fid, int quality) {
    final user = _currentUser;
    if (user == null) return;

    // Lấy progress hiện tại (nếu có)
    final currentProgresses = state.value?.flashcardProgresses ?? [];
    final index = currentProgresses.indexWhere((p) => p.fid == fid);
    final existing = index > -1 ? currentProgresses[index] : null;

    final now = DateTime.now();
    if (existing == null) {
      // 🆕 Tạo mới nếu chưa có
      final newProgress = UserFlashcardProgress(
        uid: user.uid,
        fid: fid,
        did: did,
        lastReviewed: now,
        nextReview: now.add(const Duration(days: 1)),
        reviewCount: 1,
        correctCount: quality >= 3 ? 1 : 0,
        easeFactor: 2.5, // default starting EF
        interval: 1,
      );

      final newState = state.value!.copyWith(
        flashcardProgresses: [...currentProgresses, newProgress],
      );
      state = AsyncData(newState);
      return;
    }

    // Tính SM-2
    final correct = quality >= 3;
    var ef = existing.easeFactor;
    var interval = existing.interval;
    var reviewCount = existing.reviewCount + 1;

    if (quality < 3) {
      interval = 1;
    } else {
      if (existing.reviewCount == 0) {
        interval = 1;
      } else if (existing.reviewCount == 1) {
        interval = 6;
      } else {
        interval = (interval * ef).round();
      }
      ef = ef + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
      if (ef < 1.3) ef = 1.3;
    }

    final updated = existing.copyWith(
      lastReviewed: now,
      nextReview: now.add(Duration(days: interval)),
      reviewCount: reviewCount,
      correctCount: existing.correctCount + (correct ? 1 : 0),
      easeFactor: ef,
      interval: interval,
    );

    final updatedList = List<UserFlashcardProgress>.from(currentProgresses);
    updatedList[index] = updated;

    final newState = state.value!.copyWith(
      flashcardProgresses: updatedList,
    );
    state = AsyncData(newState);
  }

  Future<void> _finishSession() async {
    final s = state.value;
    if (s == null) return;

    final uid = _currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    final end = DateTime.now();
    final totalSeconds = end.difference(s.session.start).inSeconds;

    final updated = s.session.copyWith(
      end: end,
      correctCards: s.correctCount,
      incorrectCards: s.incorrectCount,
      totalTime: totalSeconds,
    );

    state = AsyncData(state.value!.copyWith(session: updated));

    // Lưu study sesion
    await _sessionRepo.updateStudySession(updated);

    // Ghi batch tất cả progress lên Firestore
    if (s.flashcardProgresses?.isNotEmpty ?? false) {
      await _flashcardProgressRepo.updateProgresses(
        uid,
        s.flashcardProgresses!,
      );
    }

    // Cập nhật deck progress
    final udid = '${uid}_$did';
    final learningCardsCount = s.questions.length;
    final newCardsCount = s.flashcardProgresses!
        .where((p) => p.reviewCount == 1)
        .length; // thẻ học lần đầu

    final userDeckProgress = UserDeckProgress(
      udid: udid,
      uid: uid,
      did: did,
      newCardsCount: newCardsCount,
      learningCardsCount: learningCardsCount,
      lastStudied: end,
    );
    await _deckProgressRepo.createAndUpdate(userDeckProgress);

    // Cập nhật learning activity
    final laid = '${uid}_${end.toIso8601String()}';
    final deckName =
        ref.read(detailDeckViewModelProvider(did)).value?.deck.name ?? '';

    final learningActivity = LearningActivity(
      laid: laid,
      uid: uid,
      timestamp: end,
      type: LearningActivityType.studySession.name,
      did: did,
      deckName: deckName,
      durationMinutes: (totalSeconds / 60).round(),
      cardsReviewed: s.questions.length,
      cardsCorrect: s.correctCount,
      cardsIncorrect: s.incorrectCount,
      newCardsLearned: newCardsCount,
    );
    await _activityRepo.createAndUpdate(learningActivity);
  }

  int calculateQuality(UserAnswer answer) {
    switch (answer.questionType) {
      case 'flashcard':
        // flashcard (hiện câu hỏi – tự suy nghĩ)
        // => quality có thể dựa vào thời gian và tự đánh giá người dùng (ở UI)
        return answer.isCorrect ? 4 : 2;

      case 'multipleChoice':
        // trắc nghiệm: đúng = 5, sai = 2
        return answer.isCorrect ? 5 : 2;

      case 'trueFalse':
        // đúng = 5, sai = 1
        return answer.isCorrect ? 5 : 1;

      case 'written':
        // câu tự luận (gõ text)
        if (answer.accuracy >= 0.9) return 5;
        if (answer.accuracy >= 0.75) return 4;
        if (answer.accuracy >= 0.5) return 3;
        if (answer.accuracy >= 0.25) return 2;
        return 1;

      default:
        return 3;
    }
  }
}
