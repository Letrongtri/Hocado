import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';

class TestWrittenAnswer extends StatefulWidget {
  final String initialValue;
  final bool isSubmitted;
  final String correctAnswer;
  final Function(String) onChanged;

  const TestWrittenAnswer({
    super.key,
    required this.initialValue,
    required this.isSubmitted,
    required this.correctAnswer,
    required this.onChanged,
  });

  @override
  State<TestWrittenAnswer> createState() => _TestWrittenAnswerState();
}

class _TestWrittenAnswerState extends State<TestWrittenAnswer> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: _controller,
      maxLines: null,
      enabled: !widget.isSubmitted, // Khóa khi đã nộp
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.isSubmitted ? Colors.grey.shade100 : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        ),
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontSize: 16,
        ),
        hintText: "Nhập câu trả lời của bạn",
      ),
    );
  }
}
