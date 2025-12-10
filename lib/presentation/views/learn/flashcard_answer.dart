import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';

class FlashcardAnswer extends StatefulWidget {
  final void Function(bool remembered)? onAnswered;
  final void Function(bool showAnswer)? onShowAnswer;
  final String? questionId;
  final UserAnswer? answer;

  const FlashcardAnswer({
    super.key,
    this.onAnswered,
    this.onShowAnswer,
    this.questionId,
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
    _initializeState();
  }

  void _initializeState() {
    // Nếu có đáp án sẵn (lịch sử) thì hiện luôn, chưa có thì ẩn
    remembered = widget.answer?.isCorrect;
    isShowAnswer = remembered != null;
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

  Widget _buildAnswerButton() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: Sizes.btnHeight * 2 + Sizes.md,
      ),
      child: Column(
        children: [
          FlashcardOptions(
            text: 'Đã nhớ',
            isChosen: remembered == true,
            isPositive: true,
            onPressed: () => _handleAnswer(true),
          ),
          SizedBox(height: Sizes.md),
          FlashcardOptions(
            text: 'Đã quên',
            isChosen: remembered == false,
            isPositive: false,
            onPressed: () => _handleAnswer(false),
          ),
        ],
      ),
    );
  }

  void _handleAnswer(bool value) {
    setState(() => remembered = value);
    widget.onAnswered?.call(value);
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
              side: BorderSide(
                color: theme.colorScheme.onPrimary.withAlpha(100),
                width: 1.2,
              ),
            ),
            elevation: 0, // Bỏ bóng
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
  final VoidCallback? onPressed; // Dùng VoidCallback cho gọn

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

    // Mặc định
    Color bgColor = theme.colorScheme.secondary;
    Color fgColor = theme.colorScheme.onPrimary;
    Color borderColor = theme.colorScheme.onPrimary;

    // Logic chọn màu
    if (isChosen) {
      if (isPositive) {
        bgColor = AppColors.correctColorBg; // Màu xanh nền
        fgColor = AppColors.correctColorFg; // Màu xanh chữ
        borderColor = AppColors.correctColorFg;
      } else {
        bgColor = AppColors.incorrectColorBg; // Màu đỏ nền
        fgColor = AppColors.incorrectColorFg; // Màu đỏ chữ
        borderColor = AppColors.incorrectColorFg;
      }
    }

    return SizedBox(
      width: double.infinity,
      height: Sizes.btnHeight,
      child: ElevatedButton(
        // Khi đã chọn thì disable button (null), ngược lại thì nhận hàm onPressed
        onPressed: isChosen ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          // QUAN TRỌNG: Phải set màu cho trạng thái disabled
          disabledBackgroundColor: isChosen ? bgColor : null,
          disabledForegroundColor: isChosen ? fgColor : null,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
            side: BorderSide(
              color: borderColor,
              width: isChosen ? 3 : 1.2, // Đậm hơn khi chọn
            ),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 18,
            color: isChosen ? fgColor : null, // Đảm bảo text đổi màu
          ),
        ),
      ),
    );
  }
}
