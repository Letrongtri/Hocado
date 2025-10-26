// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/question.dart';
import 'package:hocado/data/models/study_session.dart';
import 'package:hocado/data/models/user_answer.dart';
import 'package:hocado/data/models/user_flashcard_progress.dart';

class LearnState {
  final StudySession session;
  final List<Question> questions;
  final int currentIndex;
  final int correctCount;
  final int incorrectCount;
  final bool isFinished;
  final List<UserFlashcardProgress>? flashcardProgresses;
  final List<UserAnswer> userAnswers;

  LearnState({
    required this.session,
    required this.questions,
    required this.currentIndex,
    required this.correctCount,
    required this.incorrectCount,
    required this.isFinished,
    this.flashcardProgresses,
    this.userAnswers = const [],
  });

  Question? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  LearnState copyWith({
    StudySession? session,
    List<Question>? questions,
    int? currentIndex,
    int? correctCount,
    int? incorrectCount,
    bool? isFinished,
    List<UserFlashcardProgress>? flashcardProgresses,
    List<UserAnswer>? userAnswers,
  }) {
    return LearnState(
      session: session ?? this.session,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      isFinished: isFinished ?? this.isFinished,
      flashcardProgresses: flashcardProgresses ?? this.flashcardProgresses,
      userAnswers: userAnswers ?? this.userAnswers,
    );
  }

  @override
  String toString() {
    return 'LearnState(session: $session, questions: $questions, currentIndex: $currentIndex, correctCount: $correctCount, incorrectCount: $incorrectCount, isFinished: $isFinished, flashcardProgresses: $flashcardProgresses, userAnswers: $userAnswers)';
  }
}
