// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/models.dart';

class TestState {
  final StudySession session;
  final List<Question> questions;
  final int? correctCount;
  final int? totalCount;
  final bool isSubmitted;
  final List<UserAnswer>? userResults; // Lưu kết quả chấm điểm
  final Map<String, dynamic>
  userResponses; // Map<QuestionID, AnswerValue> Lưu câu trả lời tạm thời của user (khi chưa submit)

  TestState({
    required this.session,
    required this.questions,
    required this.isSubmitted,
    this.correctCount,
    this.totalCount,
    this.userResults,
    this.userResponses = const {},
  });

  TestState copyWith({
    StudySession? session,
    List<Question>? questions,
    int? correctCount,
    int? totalCount,
    bool? isSubmitted,
    List<UserAnswer>? userResults,
    Map<String, dynamic>? userResponses,
  }) {
    return TestState(
      session: session ?? this.session,
      questions: questions ?? this.questions,
      correctCount: correctCount ?? this.correctCount,
      totalCount: totalCount ?? this.totalCount,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      userResults: userResults ?? this.userResults,
      userResponses: userResponses ?? this.userResponses,
    );
  }

  @override
  String toString() {
    return 'TestState(session: $session, questions: $questions, correctCount: $correctCount, totalCount: $totalCount, isSubmitted: $isSubmitted, userAnswers: $userResults, userResponses: $userResponses)';
  }
}
