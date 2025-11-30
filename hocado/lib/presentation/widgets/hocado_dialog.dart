import 'package:flutter/material.dart';

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
