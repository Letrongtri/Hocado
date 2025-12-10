import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
import 'package:hocado/utils/string_utils.dart';

class TestViewModel extends AsyncNotifier<TestState> {
  final String did;
  final LearningSettings settings;

  TestViewModel(this.did, this.settings);

  FlashcardRepository get _flashRepo => ref.read(flashcardRepositoryProvider);
  StudySessionRepository get _sessionRepo =>
      ref.read(studySessionRepositoryProvider);
  UserFlashcardProgressRepo get _flashcardProgressRepo =>
      ref.read(userFlashcardProgressRepoProvider);
  fb_auth.User? get _currentUser => ref.watch(currentUserProvider);
  LearningActivityRepository get _activityRepo =>
      ref.read(learningActivityRepositoryProvider);
  UserDeckProgressRepository get _deckProgressRepo =>
      ref.read(userDeckProgressRepositoryProvider);

  @override
  FutureOr<TestState> build() async {
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

    // 7. sinh question cho mỗi card
    final questions = generateQuestion(pool);

    // 8. tạo session
    final session = StudySession.empty().copyWith(
      uid: user.uid,
      did: did,
      totalCards: questions.length,
      mode: StudyMode.test.name,
    );

    return TestState(
      session: session,
      questions: questions,
      totalCount: questions.length,
      isSubmitted: false,
    );
  }

  List<Question> generateQuestion(
    List<Flashcard> pool,
  ) {
    final questions = <Question>[];

    final availableTypes = List<String>.from(settings.questionTypes);

    availableTypes.remove(QuestionTypes.flashcard.name);

    if (availableTypes.isEmpty) {
      availableTypes.add(QuestionTypes.multipleChoice.name);
    }

    for (final card in pool) {
      final qType = (List<String>.from(availableTypes)..shuffle()).first;

      final distractors = List<Flashcard>.from(pool)
        ..removeWhere((c) => c.fid == card.fid);

      final q = Question.fromFlashcard(
        questionType: qType,
        questionFormat: settings.questionFormat,
        flashcard: card,
        distractorPool:
            distractors, // Truyền danh sách đã lọc, không truyền 'pool' gốc
      );
      questions.add(q);
    }
    return questions;
  }

  void updateAnswer(String questionId, dynamic value) {
    if (state.value == null || state.value!.isSubmitted) return;

    final currentResponses = Map<String, dynamic>.from(
      state.value!.userResponses,
    );
    currentResponses[questionId] = value;

    state = AsyncData(state.value!.copyWith(userResponses: currentResponses));
  }

  Future<void> submitTest() async {
    final s = state.value;
    if (s == null || s.isSubmitted) return;

    final List<UserAnswer> finalResults = [];
    final timestamp = DateTime.now();
    final totalSeconds = timestamp.difference(s.session.start).inSeconds;

    for (final question in s.questions) {
      // Lấy câu trả lời user đã chọn từ Map, nếu chưa chọn thì là null
      final userResponse = s.userResponses[question.qid];

      // Chấm điểm (Hàm createAnswer logic như cũ)
      final evaluatedAnswer = createAnswer(
        question: question,
        userResponse: userResponse, // Có thể là null
      );

      finalResults.add(evaluatedAnswer);
    }

    // Tính toán thống kê
    final correctCount = finalResults.where((a) => a.isCorrect).length;
    final incorrectCount = finalResults.length - correctCount;

    // Cập nhật State để UI hiển thị kết quả
    final newState = s.copyWith(
      correctCount: correctCount,
      isSubmitted: true,
      userResults: finalResults,
    );
    state = AsyncData(newState);

    // Lưu DB (Logic giống bài trước)
    await _finishSession(
      correctCount,
      incorrectCount,
      totalSeconds,
    );
  }

  // Hàm chấm điểm (Sửa nhẹ để handle trường hợp user bỏ trống)
  UserAnswer createAnswer({
    required Question question,
    required dynamic userResponse,
  }) {
    final correctAnswer = question.answer;

    // Nếu user không trả lời -> Sai luôn
    if (userResponse == null ||
        (userResponse is String && userResponse.isEmpty)) {
      return UserAnswer(
        fid: question.fid,
        qid: question.qid,
        questionType: question.type,
        userResponse: null,
        correctAnswer: correctAnswer,
        isCorrect: false,
        accuracy: 0,
        timeSpent: 0,
      );
    }

    // Logic chấm điểm cũ
    bool isCorrect = false;
    double accuracy = 0;

    if (question.type == QuestionTypes.written.name) {
      accuracy = StringUtils.stringSimilarity(userResponse, correctAnswer);
      isCorrect = accuracy >= 0.75;
    } else {
      isCorrect = userResponse == correctAnswer;
    }

    return UserAnswer(
      fid: question.fid,
      qid: question.qid,
      questionType: question.type,
      userResponse: userResponse,
      correctAnswer: correctAnswer,
      isCorrect: isCorrect,
      accuracy: accuracy,
      timeSpent: 0, // Test tổng thể nên khó tracking time từng câu, có thể để 0
    );
  }

  Future<void> _finishSession(
    int correctCount,
    int incorrectCount,
    int totalSeconds,
  ) async {
    final s = state.value;
    if (s == null) return;

    final uid = _currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    final end = DateTime.now();

    final updated = s.session.copyWith(
      end: end,
      correctCards: correctCount,
      incorrectCards: incorrectCount,
      totalTime: totalSeconds,
    );

    state = AsyncData(state.value!.copyWith(session: updated));

    // Lưu study sesion
    await _sessionRepo.updateStudySession(updated);

    // Cập nhật deck progress
    final udid = '${uid}_$did';

    final userDeckProgress = UserDeckProgress(
      udid: udid,
      uid: uid,
      did: did,
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
      cardsCorrect: correctCount,
      cardsIncorrect: incorrectCount,
      newCardsLearned: 0,
    );
    await _activityRepo.createAndUpdate(learningActivity);
  }
}
