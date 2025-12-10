import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/views/decks/deck_list_item.dart';
import 'package:hocado/presentation/widgets/filter_tab_bar.dart';

class DecksScreen extends ConsumerWidget {
  const DecksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(decksViewModelProvider);
    final tabs = ['Của tôi', 'Đã lưu'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thư viện',
          style: theme.textTheme.headlineMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Chọn',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Search btn
          IconButton(
            onPressed: () {
              context.pushNamed(
                AppRoutes.search.name,
              );
            },
            icon: const Icon(Icons.search, size: 28),
          ),
          const SizedBox(width: Sizes.sm),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(decksViewModelProvider.notifier).refreshDecks(),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: SizedBox(height: Sizes.md)),
              SliverToBoxAdapter(
                child: FilterTabBar(
                  tabs: tabs,
                  selectedIndex: state.value?.currentTabIndex ?? 0,
                  onTabSelected: (value) {
                    ref.read(decksViewModelProvider.notifier).changeTab(value);
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.swap_vert, size: 20),
                        label: const Text('Đã cập nhật'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.grid_view_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },

          body: state.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('Lỗi tải dữ liệu: $error'),
            ),

            data: (data) {
              final decks = data.currentTabIndex == 0
                  ? data.myDecks
                  : data.savedDecks;

              if (decks == null || decks.isEmpty) {
                return const Center(
                  child: Text(
                    'Bạn chưa có bộ thẻ nào. Hãy tạo hoặc lưu bộ thẻ!',
                  ),
                );
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.sm),
                  itemCount: decks.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: Sizes.md),
                  itemBuilder: (context, index) {
                    final item = decks[index];
                    if (item is Deck) {
                      return DeckListItem(
                        title: item.name,
                        lastUpdated: item.updatedAt,
                        did: item.did,
                        thumbnailUrl: item.thumbnailUrl,
                        onDelete: () {
                          ref
                              .read(decksViewModelProvider.notifier)
                              .deleteDeck(item.did);
                        },
                      );
                    } else if (item is SavedDeck) {
                      return DeckListItem(
                        title: item.name,
                        lastUpdated: item.savedAt,
                        did: item.did,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
