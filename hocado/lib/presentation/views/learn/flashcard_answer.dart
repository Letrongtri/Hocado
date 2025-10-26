import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/user_answer.dart';

class FlashcardAnswer extends StatefulWidget {
  final void Function(bool remembered)? onAnswered;
  final void Function(bool showAnswer)? onShowAnswer;
  final UserAnswer? answer;

  const FlashcardAnswer({
    super.key,
    this.onAnswered,
    this.onShowAnswer,
    this.answer,
  });

  @override
  State<FlashcardAnswer> createState() => _FlashcardAnswerState();
}

class _FlashcardAnswerState extends State<FlashcardAnswer> {
  late bool isShowAnswer;
  bool? remembered;

  @override
  void initState() {
    super.initState();
    isShowAnswer = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isShowAnswer) {
      return _buildShowAnswerButton(theme);
    } else {
      return _buildAnswerButton();
    }
  }

  ConstrainedBox _buildAnswerButton() {
    // final userChoice = remembered ?? widget.answer?.isCorrect;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: Sizes.btnHeight * 2 + Sizes.md,
      ),
      child: Column(
        children: [
          // FlashcardOptions(
          //   text: 'Đã nhớ',
          //   isCorrect: userChoice == null ? null : (userChoice == true),
          //   isChosen: userChoice,
          //   onPressed: userChoice == null
          //       ? () {
          //           setState(() => remembered = true);
          //           widget.onAnswered?.call(true);
          //         }
          //       : null,
          // ),
          FlashcardOptions(
            text: 'Đã nhớ',
            isChosen: remembered == true,
            isPositive: true,
            onPressed: remembered == null
                ? () {
                    setState(() => remembered = true);
                    widget.onAnswered?.call(true);
                  }
                : null,
          ),
          SizedBox(height: Sizes.md),
          // FlashcardOptions(
          //   text: 'Đã quên',
          //   isCorrect: userChoice == null ? null : (userChoice == false),
          //   isChosen: userChoice,
          //   onPressed: userChoice == null
          //       ? () {
          //           setState(() => remembered = false);
          //           widget.onAnswered?.call(false);
          //         }
          //       : null,
          // ),
          FlashcardOptions(
            text: 'Đã quên',
            isChosen: remembered == false,
            isPositive: false,
            onPressed: remembered == null
                ? () {
                    setState(() => remembered = false);
                    widget.onAnswered?.call(false);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  ConstrainedBox _buildShowAnswerButton(ThemeData theme) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: Sizes.btnHeight,
      ),
      child: SizedBox(
        width: double.infinity,
        height: Sizes.btnHeight,
        child: ElevatedButton(
          onPressed: () {
            // if (widget.onShowAnswer != null) widget.onShowAnswer!(true);
            widget.onShowAnswer?.call(true);

            setState(() {
              isShowAnswer = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            padding: EdgeInsets.all(Sizes.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
              side: BorderSide(
                color: theme.colorScheme.onPrimary.withAlpha(100),
                width: 1.2,
              ),
            ),
            elevation: 0, // Bỏ bóng
            minimumSize: const Size(double.infinity, 60),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hiển thị câu trả lời',
              style: theme.textTheme.headlineSmall?.copyWith(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class FlashcardOptions extends StatelessWidget {
  final String text;
  final bool isPositive; // true = đã nhớ, false = đã quên
  final bool isChosen;
  final void Function()? onPressed;

  const FlashcardOptions({
    super.key,
    required this.text,
    this.onPressed,
    required this.isPositive,
    required this.isChosen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor = theme.colorScheme.secondary;
    Color foregroundColor = theme.colorScheme.onPrimary;

    if (isChosen) {
      if (isPositive) {
        backgroundColor = AppColors.correctColorBg;
        foregroundColor = AppColors.correctColorFg;
      } else {
        backgroundColor = AppColors.incorrectColorBg;
        foregroundColor = AppColors.incorrectColorFg;
      }
    }

    return SizedBox(
      width: double.infinity,
      height: Sizes.btnHeight,
      child: ElevatedButton(
        onPressed: isChosen ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.all(Sizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
            side: BorderSide(
              color: foregroundColor,
              width: 3,
            ),
          ),
          elevation: 0, // Bỏ bóng
          minimumSize: const Size(double.infinity, 60),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: theme.textTheme.headlineSmall?.copyWith(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
