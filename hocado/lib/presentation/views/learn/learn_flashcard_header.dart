import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';

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
                  showDialog(
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
                                  hint!,
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
