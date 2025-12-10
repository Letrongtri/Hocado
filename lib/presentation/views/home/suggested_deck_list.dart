import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/widgets/hocado_avatar.dart';
import 'package:hocado/utils/format_date_time.dart';

class SuggestedDeckList extends ConsumerStatefulWidget {
  const SuggestedDeckList({
    super.key,
  });

  @override
  ConsumerState<SuggestedDeckList> createState() => _SuggestedDeckListState();
}

class _SuggestedDeckListState extends ConsumerState<SuggestedDeckList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      await ref.read(homeViewModelProvider.notifier).loadSuggested();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(homeViewModelProvider);
    final suggestedDecks = state.value?.suggestedDecks ?? [];

    if (suggestedDecks.isEmpty) return const SizedBox.shrink();

    return state.when(
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gợi ý', style: theme.textTheme.headlineSmall),
          const SizedBox(height: Sizes.md),

          ListView.separated(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: suggestedDecks.length + 1,
            separatorBuilder: (context, index) =>
                const SizedBox(height: Sizes.sm),
            itemBuilder: (context, index) {
              if (index == suggestedDecks.length) {
                return _buildFooter(ref, theme);
              }

              final homeDeckItem = suggestedDecks[index];
              final deck = homeDeckItem.deck;
              final owner = homeDeckItem.author;

              return _buildSuggestedDeckItem(
                context,
                theme,
                index,
                deck,
                owner!,
              );
            },
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Center(child: Text('Error')),
    );
  }

  Widget _buildFooter(WidgetRef ref, ThemeData theme) {
    final notifier = ref.read(homeViewModelProvider.notifier);

    if (notifier.hasMoreSuggestedDecks) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (!notifier.hasMoreSuggestedDecks) {
      return Padding(
        padding: EdgeInsets.all(Sizes.md),
        child: Center(
          child: Text(
            "Hãy theo dõi mọi người để xem nhiều bộ thẻ công khai hơn!",
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSuggestedDeckItem(
    BuildContext context,
    ThemeData theme,
    int index,
    Deck deck,
    User user,
  ) {
    return InkWell(
      onTap: () {
        if (context.mounted) {
          context.pushNamed(
            AppRoutes.detailDeck.name,
            pathParameters: {'did': deck.did},
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(Sizes.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (context.mounted) {
                      context.pushNamed(
                        AppRoutes.profile.name,
                        pathParameters: {'uid': user.uid},
                      );
                    }
                  },
                  child: HocadoAvatar(user: user, size: 25),
                ),
                const SizedBox(width: Sizes.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (context.mounted) {
                          context.pushNamed(
                            AppRoutes.profile.name,
                            pathParameters: {'uid': user.uid},
                          );
                        }
                      },
                      child: Text(
                        user.fullName,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: Sizes.xs),
                    Text(
                      formatTimeAgo(deck.updatedAt),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Sizes.sm),
            Text(deck.name, style: theme.textTheme.titleMedium),
            const SizedBox(height: Sizes.sm),
            Text(deck.description, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
