import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/utils/format_date_time.dart';

class LearningActivitiesList extends StatelessWidget {
  final List<LearningActivity> activities;

  const LearningActivitiesList({super.key, required this.activities});

  // Helper để hiển thị icon
  Icon? _getIcon(String type) {
    if (type == LearningActivityType.createdDeck.name) {
      return Icon(Icons.add_circle, color: AppColors.masteredColorFg);
    } else if (type == LearningActivityType.studySession.name) {
      return Icon(Icons.school, color: AppColors.almostDoneColorFg);
    }
    return null;
  }

  // Helper để hiển thị nội dung
  String _getSubtitle(LearningActivity activity) {
    if (activity.type == LearningActivityType.studySession.name) {
      return "Học ${activity.durationMinutes} phút - ${activity.cardsReviewed} thẻ";
    } else if (activity.type == LearningActivityType.createdDeck.name) {
      return "Đã tạo bộ thẻ mới";
    }
    return "";
  }

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Lịch sử học tập',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: Sizes.sm),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: Colors.grey,
            ),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                contentPadding: EdgeInsets.all(Sizes.xs),
                leading: CircleAvatar(
                  backgroundColor: _getIcon(
                    activity.type,
                  )?.color?.withAlpha(80),
                  child: _getIcon(activity.type),
                ),
                title: Text(
                  activity.deckName ?? '',
                  style: theme.textTheme.titleMedium,
                ),
                subtitle: Text(_getSubtitle(activity)),
                trailing: Text(
                  formatTimeAgo(activity.timestamp),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
