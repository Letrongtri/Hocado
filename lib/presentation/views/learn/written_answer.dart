import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';

class WrittenAnswer extends StatelessWidget {
  final void Function(String response)? onAnswered;
  final UserAnswer? answer;
  const WrittenAnswer({super.key, this.onAnswered, this.answer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final writtenController = TextEditingController();

    Color backgroundColor;
    Color foregroundColor;

    if (answer != null) {
      writtenController.text = answer!.userResponse;

      if (answer!.isCorrect == true) {
        backgroundColor = AppColors.correctColorBg;
        foregroundColor = AppColors.correctColorFg;
      } else {
        backgroundColor = AppColors.incorrectColorBg;
        foregroundColor = AppColors.incorrectColorFg;
      }
    } else {
      backgroundColor = theme.colorScheme.secondary.withAlpha(40);
      foregroundColor = theme.colorScheme.onPrimary.withAlpha(100);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      child: TextFormField(
        controller: writtenController,
        maxLines: null,
        decoration: InputDecoration(
          filled: true,
          fillColor: backgroundColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
            borderSide: BorderSide(color: foregroundColor, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
            borderSide: BorderSide(color: foregroundColor, width: 3),
          ),
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontSize: 16,
          ),

          suffixIcon: IconButton(
            icon: Icon(Icons.send_rounded),
            onPressed: answer == null
                ? () {
                    if (onAnswered != null) onAnswered!(writtenController.text);
                  }
                : null,
          ),
          hintText: "Nhập câu trả lời của bạn",
        ),
      ),
    );
  }
}
