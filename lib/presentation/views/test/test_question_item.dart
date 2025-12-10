import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/views/test/test_written_answer.dart';

class TestQuestionItem extends StatelessWidget {
  final int index;
  final Question question;
  final dynamic userResponse;
  final UserAnswer? result;
  final bool isSubmitted;
  final Function(dynamic) onAnswerChanged; // Callback khi user chọn đáp án

  const TestQuestionItem({
    super.key,
    required this.index,
    required this.question,
    required this.userResponse,
    this.result,
    required this.isSubmitted,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Xác định màu viền và nền của Card tổng
    Color cardColor = theme.cardColor;
    Color borderColor = Colors.transparent;

    if (isSubmitted && result != null) {
      if (result!.isCorrect) {
        borderColor = AppColors.correctColorFg;
        cardColor = AppColors.correctColorBg;
      } else {
        borderColor = AppColors.incorrectColorFg;
        cardColor = AppColors.incorrectColorBg;
      }
    }

    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
        side: BorderSide(color: borderColor, width: isSubmitted ? 1 : 0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Câu $index:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: Sizes.xs),

            // câu hỏi
            Text(
              question.prompt,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: Sizes.md),

            // Phần trả lời (Trắc nghiệm / Đúng sai)
            if (question.type == QuestionTypes.multipleChoice.name ||
                question.type == QuestionTypes.trueFalse.name)
              ...question.choices!.map((option) {
                return _buildRadioOption(context, option);
              }),

            // Phần trả lời (Tự luận)
            if (question.type == QuestionTypes.written.name)
              TestWrittenAnswer(
                initialValue: userResponse as String? ?? '',
                isSubmitted: isSubmitted,
                correctAnswer: question.answer,
                onChanged: onAnswerChanged,
              ),

            // 5. Hiển thị đáp án đúng nếu user làm sai (cho câu tự luận)
            if (isSubmitted &&
                result != null &&
                !result!.isCorrect &&
                question.type == QuestionTypes.written.name)
              Padding(
                padding: const EdgeInsets.only(top: Sizes.sm),
                child: Text(
                  "Đáp án đúng: ${question.answer}",
                  style: TextStyle(
                    color: AppColors.incorrectColorFg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(BuildContext context, String option) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSubmitted ? null : () => onAnswerChanged(option),
          borderRadius: BorderRadius.circular(Sizes.borderRadiusSm),
          child: Container(
            decoration: BoxDecoration(),
            child: Row(
              children: [
                Icon(
                  (userResponse == option)
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: theme.colorScheme.onSurface.withAlpha(180),
                  size: Sizes.iconMd,
                ),
                const SizedBox(width: Sizes.md),

                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: (isSubmitted && option == question.answer)
                          ? AppColors.correctColorFg
                          : theme.colorScheme.onSurface,
                      fontWeight: (isSubmitted && option == question.answer)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
