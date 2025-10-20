import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/flashcard.dart';

class FlashcardListItem extends StatelessWidget {
  final Flashcard card;
  final int index;

  const FlashcardListItem({super.key, required this.card, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      margin: EdgeInsets.only(bottom: Sizes.sm),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  index.toString(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
                const SizedBox(width: Sizes.sm),
                Chip(
                  // TODO: Replace with actual status
                  label: Text('ongoing'),
                  labelStyle: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.ongoingColorFg,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: AppColors.ongoingColorBg,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.xs),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide.none,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.star_border_outlined,
                    size: Sizes.iconMd,
                  ),
                  color: theme.colorScheme.onSurface.withAlpha(100),
                ),
              ],
            ),

            const SizedBox(height: Sizes.sm),
            Text(
              card.front,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: Sizes.sm),
            Text(card.back, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
