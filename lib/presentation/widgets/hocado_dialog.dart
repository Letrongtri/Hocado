import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';

Future<bool?> showConfirmDialog(
  BuildContext context,
  String? title,
  String message,
) {
  final theme = Theme.of(context);
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title ?? 'Xác nhận'),
      content: Text(message, style: theme.textTheme.bodyMedium),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextButton(
                child: Text(
                  'Huỷ',
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),
            Expanded(
              child: TextButton(
                child: Text(
                  'Xác nhận',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void showSuccessSnackbar(BuildContext context, String message) {
  final theme = Theme.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: theme.textTheme.titleMedium),
      backgroundColor: theme.colorScheme.primary,
    ),
  );
}

void showErrorSnackbar(BuildContext context, String message) {
  final theme = Theme.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onError,
        ),
      ),
      backgroundColor: theme.colorScheme.error,
    ),
  );
}

Future<dynamic> showNote(BuildContext context, String note) {
  final theme = Theme.of(context);
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Sizes.borderRadiusLg,
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.md),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  note,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: Sizes.sm),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Đã hiểu"),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<String?> showInputDialog(
  BuildContext context, {
  required String title,
  String? hint,
  bool obscureText = false,
}) async {
  final controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
