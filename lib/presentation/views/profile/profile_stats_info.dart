import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';

class ProfileStatsInfo extends StatelessWidget {
  const ProfileStatsInfo({
    super.key,
    required this.followersCount,
    required this.followingCount,
    required this.createdDecksCount,
    required this.savedDecksCount,
  });

  final int followersCount;
  final int followingCount;
  final int createdDecksCount;
  final int savedDecksCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(theme, value: "$followersCount", label: "Followers"),
        _buildStatItem(theme, value: "$followingCount", label: "Following"),
        _buildStatItem(theme, value: "$createdDecksCount", label: "Đã tạo"),
        _buildStatItem(theme, value: "$savedDecksCount", label: "Đã lưu"),
      ],
    );
  }

  Widget _buildStatItem(
    ThemeData theme, {
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: Sizes.xs),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary.withAlpha(220),
          ),
        ),
      ],
    );
  }
}
