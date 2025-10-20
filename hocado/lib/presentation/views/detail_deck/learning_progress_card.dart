import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';

class LearningProgressCard extends StatelessWidget {
  const LearningProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: theme.cardTheme.shape,
      elevation: 0,
      color: theme.colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tiến độ học tập", style: theme.textTheme.titleMedium),
                Text(
                  "82%",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressRow(
              theme,
              "Thẻ mới",
              0,
              AppColors.notLearnedColorBg,
              AppColors.notLearnedColorFg,
              Icons.lightbulb_outline,
            ),
            _buildProgressRow(
              theme,
              "Vẫn đang học",
              7,
              AppColors.ongoingColorBg,
              AppColors.ongoingColorFg,
              Icons.hourglass_bottom_outlined,
            ),
            _buildProgressRow(
              theme,
              "Sắp xong",
              7,
              AppColors.almostDoneColorBg,
              AppColors.almostDoneColorFg,
              Icons.rotate_right,
            ),
            _buildProgressRow(
              theme,
              "Thành thạo",
              34,
              AppColors.masteredColorBg,
              AppColors.masteredColorFg,
              Icons.check_circle_outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(
    ThemeData theme,
    String label,
    int count,
    Color bgColor,
    Color iconColor,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            radius: 16,
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            count.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
