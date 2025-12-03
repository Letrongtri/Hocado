import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';

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
      padding: const EdgeInsets.all(Sizes.md),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Text(
          index.toString(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            // TODO: implement
          },
          icon: const Icon(
            Icons.star_border_outlined,
            size: Sizes.iconMd,
          ),
          color: theme.colorScheme.onSurface.withAlpha(100),
        ),
        title: Text(
          card.front,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(card.back, style: theme.textTheme.bodyMedium),
      ),
    );
  }
}
