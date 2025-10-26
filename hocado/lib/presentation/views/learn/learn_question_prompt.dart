import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/learning_settings.dart';
import 'package:hocado/data/models/question.dart';

class LearnQuestionPrompt extends StatelessWidget {
  const LearnQuestionPrompt({
    super.key,
    required this.question,
    required this.questionFormat,
    this.isShowAnswer = false,
  });

  final Question question;
  final String questionFormat;
  final bool isShowAnswer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (questionFormat == QuestionFormat.answerWithDefinition.name)
              Text(
                'Thuật ngữ:',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            if (questionFormat == QuestionFormat.answerWithTerm.name)
              Text(
                'Định nghĩa',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            SizedBox(height: Sizes.sm),
            Text(
              question.prompt,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: Sizes.md),

            if (isShowAnswer)
              if (questionFormat == QuestionFormat.answerWithDefinition.name)
                Text(
                  'Định nghĩa:',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
            if (isShowAnswer)
              if (questionFormat == QuestionFormat.answerWithTerm.name)
                Text(
                  'Thuật ngữ',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),

            if (isShowAnswer) SizedBox(height: Sizes.sm),
            if (isShowAnswer)
              Text(
                question.answer,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
