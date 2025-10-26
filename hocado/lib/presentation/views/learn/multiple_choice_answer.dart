import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/question.dart';
import 'package:hocado/data/models/user_answer.dart';

class MultipleChoiceAnswer extends ConsumerWidget {
  const MultipleChoiceAnswer({
    super.key,
    required this.question,
    this.answer,
    this.onAnswered,
  });

  final Question question;
  final UserAnswer? answer;
  final void Function(String response)? onAnswered;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: question.choices?.length ?? 0,
        itemBuilder: (context, index) {
          final choice = question.choices![index];

          bool isChosen = answer?.userResponse == choice;
          bool isCorrectAnswer = answer?.correctAnswer == choice;

          Color backgroundColor;
          Color borderColor;

          if (answer != null && isChosen) {
            if (isCorrectAnswer) {
              backgroundColor = AppColors.correctColorBg;
              borderColor = AppColors.correctColorFg;
            } else {
              backgroundColor = AppColors.incorrectColorBg;
              borderColor = AppColors.incorrectColorFg;
            }
          } else {
            backgroundColor = theme.colorScheme.secondary;
            borderColor = theme.colorScheme.onPrimary.withAlpha(100);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: Sizes.md),
            child: ElevatedButton(
              onPressed: answer == null
                  ? () {
                      if (onAnswered != null) onAnswered!(choice);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: EdgeInsets.all(Sizes.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  side: BorderSide(color: borderColor, width: 3),
                ),
                elevation: 0, // Bỏ bóng
                minimumSize: const Size(double.infinity, 60),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  choice,
                  style: theme.textTheme.headlineSmall?.copyWith(fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
