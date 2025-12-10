import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';

class LevelProgress extends StatelessWidget {
  const LevelProgress({
    super.key,
    required this.level,
    required this.xp,
    required this.nextLevelXp,
  });

  final int level;
  final int xp;
  final int nextLevelXp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(Sizes.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Levels $level',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 18,
                ),
              ),
              Text(
                '$xp/$nextLevelXp XP',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: xp / nextLevelXp,
              minHeight: 12,
              backgroundColor: theme.colorScheme.onSecondary.withAlpha(
                50,
              ), // Màu nền
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
