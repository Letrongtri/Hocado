import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/user_provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/models/user.dart';
import 'package:hocado/presentation/viewmodels/profile/profile_state.dart';
import 'package:hocado/presentation/views/profile/achievements_section.dart';
import 'package:hocado/presentation/views/profile/learning_activities_list.dart';
import 'package:hocado/presentation/views/profile/learning_stats_chart.dart';
import 'package:hocado/presentation/views/profile/level_progress.dart';
import 'package:hocado/presentation/views/profile/profile_info.dart';
import 'package:hocado/presentation/widgets/deck_card.dart';

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
    final profileStatus = state.profileStatus;
    final dailyLearningStat = state.learningStats;
    final learningActivities = state.learningActivities;
    final publicDecks = state.publicDecks;

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
            onPressed: () {
              context.pushNamed(
                AppRoutes.profile.name,
                pathParameters: {'uid': '4iuZc4k5WqOkrXn6x6PraUuo5Nn2'},
              );
            },
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
          SizedBox(width: Sizes.sm),

          if (profileStatus == ProfileStatus.myProfile.name)
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
            ProfileInfo(
              user: user,
              profileStatus: profileStatus,
            ),

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

                  if (profileStatus == ProfileStatus.myProfile.name)
                    Column(
                      children: [
                        // Thống kê học
                        LearningStatsChart(stats: dailyLearningStat),
                        const SizedBox(height: Sizes.md),

                        // hoạt động
                        LearningActivitiesList(activities: learningActivities),
                      ],
                    ),

                  // List decks,...
                  if (publicDecks.isNotEmpty)
                    _buildUserPublicDeck(theme, publicDecks, user),
                  const SizedBox(height: Sizes.xl), // Đệm cuối trang
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserPublicDeck(
    ThemeData theme,
    List<Deck> publicDecks,
    User user,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Sizes.sm),
              child: Text('Bộ thẻ', style: theme.textTheme.headlineSmall),
            ),
            const SizedBox(height: Sizes.sm),

            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: publicDecks.length,
              itemBuilder: (context, index) {
                final deck = publicDecks[index];
                return DeckCard(
                  did: deck.did,
                  title: deck.name,
                  description: deck.description,
                  owner: user,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
