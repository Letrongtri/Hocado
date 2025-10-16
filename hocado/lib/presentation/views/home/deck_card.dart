import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';

class DeckCard extends StatelessWidget {
  const DeckCard({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.secondary,
      elevation: 0.2,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // icon
            Container(
              padding: const EdgeInsets.all(Sizes.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.description_outlined,
                color: theme.colorScheme.primary,
                size: Sizes.iconMd,
              ),
            ),
            const SizedBox(height: Sizes.md),

            // Heading
            Text(
              title,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Sizes.xs),

            // Description
            Text(
              description,
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
