import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/widgets/hocado_dialog.dart';

class LearnFlashcardHeader extends StatelessWidget {
  final String? hint;
  final bool isStarred;
  final void Function(bool isStarred)? onStarred;
  const LearnFlashcardHeader({
    super.key,
    required this.isStarred,
    this.hint,
    this.onStarred,
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
        IconButton(
          icon: isStarred
              ? Icon(
                  Icons.star,
                  color: AppColors.starColor,
                )
              : Icon(
                  Icons.star_border,
                  color: theme.colorScheme.onPrimary,
                ),
          onPressed: () {
            if (onStarred != null) onStarred!(!isStarred);
          },
        ),
      ],
    );
  }
}
