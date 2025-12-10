import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

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
                'Danh hiệu',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Xem thêm',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: Sizes.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAchievementBadge(
                AppColors.almostDoneColorFg,
                Icons.water_drop,
              ),
              _buildAchievementBadge(
                AppColors.notLearnedColorFg,
                Icons.local_library,
              ),
              _buildAchievementBadge(AppColors.masteredColorFg, Icons.task_alt),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(Color color, IconData icon) {
    // Dùng Stack để đặt số level lên trên icon
    return CircleAvatar(
      radius: 40,
      backgroundColor: color.withAlpha(80),
      child: Icon(icon, color: color, size: Sizes.iconLg),
    );
  }
}
