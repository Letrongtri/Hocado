import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/widgets/hocado_dialog.dart';

class LearnFlashcardHeader extends StatelessWidget {
  final String? hint;
  const LearnFlashcardHeader({
    super.key,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(
            Icons.lightbulb_outline,
            color: theme.colorScheme.onPrimary,
          ),
          onPressed: hint == null
              ? null
              : () {
                  showNote(context, hint!);
                },
        ),
        SizedBox(width: Sizes.sm),
      ],
    );
  }
}
