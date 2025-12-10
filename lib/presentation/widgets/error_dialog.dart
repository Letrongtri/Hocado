import 'package:flutter/cupertino.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      // icon: Icon(Icons.error_outline),
      title: Text(message),
      actions: [
        CupertinoDialogAction(
          child: Text("Ok"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
