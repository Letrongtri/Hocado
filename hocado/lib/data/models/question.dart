import 'package:hocado/data/models/learning_settings.dart';
import 'package:uuid/uuid.dart';

class Question {
  final String qid;
  final String fid;
  final String prompt;
  final String answer;
  final String? hint;
  final String type;
  final List<String>? choices;

  Question({
    required this.qid,
    required this.fid,
    required this.prompt,
    required this.answer,
    this.hint,
    required this.type,
    this.choices,
  });

  factory Question.fromFlashcard({
    required String questionType,
    required String questionFormat, // 'termToDefinition' or 'definitionToTerm'
    required dynamic flashcard, // expect has .term and .definition
    required List<dynamic> distractorPool,
  }) {
    final qid = const Uuid().v4();
    final front = questionFormat == QuestionFormat.answerWithDefinition.name
        ? flashcard.front
        : flashcard.back;
    final back = questionFormat == QuestionFormat.answerWithDefinition.name
        ? flashcard.back
        : flashcard.front;

    final hint = flashcard.note;

    if (questionType == QuestionTypes.multipleChoice.name) {
      final others = distractorPool
          .where((c) => c.fid != flashcard.fid)
          .toList();
      others.shuffle();
      final distractors = others
          .take(3)
          .map(
            (c) => questionFormat == QuestionFormat.answerWithDefinition.name
                ? c.back
                : c.front,
          )
          .toList();
      final choices = [back, ...distractors]..shuffle();

      return Question(
        qid: qid,
        fid: flashcard.fid,
        prompt: front,
        answer: back,
        type: QuestionTypes.multipleChoice.name,
        choices: List<String>.from(choices),
      );
    } else if (questionType == QuestionTypes.trueFalse.name) {
      final makeTrue = (DateTime.now().microsecond % 2 == 0);
      String statement;
      if (makeTrue) {
        statement = "$front — $back";
      } else {
        final wrong = (distractorPool..shuffle()).firstWhere(
          (c) => c.fid != flashcard.fid,
          orElse: () => flashcard,
        );

        final wrongBack =
            questionFormat == QuestionFormat.answerWithDefinition.name
            ? wrong.back
            : wrong.front;
        statement = "$front — $wrongBack";
      }
      return Question(
        qid: qid,
        fid: flashcard.fid,
        prompt: statement,
        answer: makeTrue ? 'True' : 'False',
        type: QuestionTypes.trueFalse.name,
        choices: const ['True', 'False'],
      );
    } else if (questionType == QuestionTypes.written.name) {
      return Question(
        qid: qid,
        fid: flashcard.fid,
        prompt: front,
        answer: back,
        type: QuestionTypes.written.name,
      );
    } else {
      // default flashcard type
      return Question(
        qid: qid,
        fid: flashcard.fid,
        prompt: front,
        answer: back,
        hint: hint,
        type: QuestionTypes.flashcard.name,
      );
    }
  }
}
