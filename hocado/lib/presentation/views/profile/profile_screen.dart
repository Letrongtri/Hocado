import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/user_provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/viewmodels/profile/profile_state.dart';
import 'package:hocado/presentation/views/profile/achievements_section.dart';
import 'package:hocado/presentation/views/profile/learning_activities_list.dart';
import 'package:hocado/presentation/views/profile/learning_stats_chart.dart';
import 'package:hocado/presentation/views/profile/level_progress.dart';
import 'package:hocado/presentation/views/profile/profile_info.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider(userId));

    return state.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Đã có lỗi xảy ra: $error'),
        ),
      ),
      data: (state) {
        return _buildMainScaffold(context, state);
      },
    );
  }

  Scaffold _buildMainScaffold(BuildContext context, ProfileState state) {
    final theme = Theme.of(context);
    final user = state.user;
    final dailyLearningStat = state.learningStats;
    final learningActivities = state.learningActivities;

    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      extendBodyBehindAppBar: true, // Cho phép body nằm sau AppBar
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent, // AppBar trong suốt
        elevation: 0,
        actions: [
          IconButton.filled(
            icon: const Icon(Icons.upload_outlined),
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
          SizedBox(width: Sizes.sm),
          IconButton.filled(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.pushNamed(AppRoutes.appSettings.name);
            },
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
          SizedBox(width: Sizes.sm),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileInfo(user: user),

            Container(
              padding: EdgeInsets.symmetric(horizontal: Sizes.md),
              margin: EdgeInsets.only(bottom: Sizes.md),
              decoration: BoxDecoration(color: theme.colorScheme.surface),
              child: Column(
                children: [
                  const SizedBox(height: Sizes.md),

                  // Tiến độ Level
                  LevelProgress(
                    level: user.level,
                    xp: user.xp,
                    nextLevelXp: user.nextLevelXp,
                  ),
                  const SizedBox(height: Sizes.md),

                  // Danh hiệu
                  const AchievementsSection(),
                  const SizedBox(height: Sizes.md),

                  // Thống kê học
                  LearningStatsChart(stats: dailyLearningStat),
                  const SizedBox(height: Sizes.md),

                  // hoạt động
                  LearningActivitiesList(activities: learningActivities),
                  const SizedBox(height: Sizes.xl), // Đệm cuối trang
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
