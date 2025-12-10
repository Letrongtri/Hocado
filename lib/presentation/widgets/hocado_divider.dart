import 'package:flutter/material.dart';

class HocadoDivider extends StatelessWidget {
  const HocadoDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.onPrimary.withAlpha(100),
      thickness: 1.2,
    );
  }
}
