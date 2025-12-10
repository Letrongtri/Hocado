// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserAnswer {
  final String fid;
  final String qid;
  final String questionType;
  final dynamic userResponse;
  final dynamic correctAnswer;
  final bool isCorrect;
  final bool firstTry;
  final double accuracy;
  final int timeSpent;
  final DateTime answeredAt;

  UserAnswer({
    required this.fid,
    required this.qid,
    required this.questionType,
    required this.userResponse,
    required this.correctAnswer,
    required this.isCorrect,
    this.firstTry = true,
    this.accuracy = 0,
    this.timeSpent = 0,
    DateTime? answeredAt,
  }) : answeredAt = answeredAt ?? DateTime.now();

  UserAnswer copyWith({
    String? fid,
    String? qid,
    String? questionType,
    dynamic userResponse,
    dynamic correctAnswer,
    bool? isCorrect,
    bool? firstTry,
    double? accuracy,
    int? timeSpent,
    DateTime? answeredAt,
  }) {
    return UserAnswer(
      fid: fid ?? this.fid,
      qid: qid ?? this.qid,
      questionType: questionType ?? this.questionType,
      userResponse: userResponse ?? this.userResponse,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      firstTry: firstTry ?? this.firstTry,
      accuracy: accuracy ?? this.accuracy,
      timeSpent: timeSpent ?? this.timeSpent,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  String toString() {
    return 'UserAnswer(fid: $fid, qid: $qid, questionType: $questionType, userResponse: $userResponse, correctAnswer: $correctAnswer, isCorrect: $isCorrect, firstTry: $firstTry, accuracy: $accuracy, timeSpent: $timeSpent, answeredAt: $answeredAt)';
  }
}
