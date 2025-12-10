import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class SubmitTestButton extends StatelessWidget {
  const SubmitTestButton({super.key, required this.notifier});
  final TestViewModel notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: Sizes.btnLgHeight,
      padding: const EdgeInsets.all(Sizes.md),
      color: theme.colorScheme.secondary,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Sizes.btnLgRadius,
            ),
          ),
        ),
        onPressed: () async {
          _showConfirmSubmitDialog(context, notifier);
        },
        child: const Text(
          'Nộp bài',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  void _showConfirmSubmitDialog(BuildContext context, TestViewModel notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận nộp bài"),
        content: const Text(
          "Bạn có chắc chắn muốn nộp bài? Bạn sẽ không thể sửa lại đáp án sau khi nộp.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              notifier.submitTest();
            },
            child: const Text("Nộp bài"),
          ),
        ],
      ),
    );
  }
}
