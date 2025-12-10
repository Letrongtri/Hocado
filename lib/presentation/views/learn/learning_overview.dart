import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/utils/format_date_time.dart';

class LearningOverview extends StatelessWidget {
  final StudySession studySession;

  const LearningOverview(this.studySession, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: theme.cardTheme.shape,
      elevation: 0,
      color: theme.colorScheme.secondary.withAlpha(100),
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
                  '${(studySession.correctCards * 100 / studySession.totalCards).toStringAsFixed(2)}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressRow(
              theme,
              "Số thẻ",
              studySession.totalCards.toString(),
              AppColors.almostDoneColorBg,
              AppColors.almostDoneColorFg,
              Icons.lightbulb_outline,
            ),
            _buildProgressRow(
              theme,
              "Trả lời đúng",
              studySession.correctCards.toString(),
              AppColors.masteredColorBg,
              AppColors.masteredColorFg,
              Icons.check_circle_outline,
            ),
            _buildProgressRow(
              theme,
              "Trả lời sai",
              studySession.incorrectCards.toString(),
              AppColors.notLearnedColorBg,
              AppColors.notLearnedColorFg,
              Icons.cancel_outlined,
            ),
            _buildProgressRow(
              theme,
              "Thời gian",
              formatTime(studySession.totalTime),
              AppColors.ongoingColorBg,
              AppColors.ongoingColorFg,
              Icons.hourglass_bottom_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(
    ThemeData theme,
    String label,
    String count,
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
