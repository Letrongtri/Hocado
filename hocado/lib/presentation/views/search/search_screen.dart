import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
import 'package:hocado/presentation/widgets/deck_card.dart';
import 'package:hocado/presentation/widgets/filter_tab_bar.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController searchController;
  late ScrollController _scrollController;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _scrollController = ScrollController();

    // Lắng nghe sự kiện scroll
    _scrollController.addListener(_onScroll);

    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = searchController.text.trim();
      final stateData = ref.read(searchViewModelProvider).value;
      final notifier = ref.read(searchViewModelProvider.notifier);

      if (query.isEmpty) {
        // Nếu search trống, reset lại dữ liệu
        notifier.build();
        return;
      }

      switch (stateData?.currentTabIndex ?? 0) {
        case 0:
          notifier.searchPublicDecks(query);
          break;
        case 1:
          notifier.searchMyDecks(query);
          break;
        case 2:
          // notifier.searchSavedDecks(query);
          break;
      }
    });
  }

  void _onScroll() {
    final stateData = ref.read(searchViewModelProvider).value;
    final notifier = ref.read(searchViewModelProvider.notifier);
    if (stateData == null) return;

    // Khi scroll gần cuối (>= 80%)
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_scrollController.position.outOfRange) {
      // Kiểm tra tab nào đang active
      switch (stateData.currentTabIndex) {
        case 0: // Tất cả
          if (stateData.publicDecksHasMore &&
              !ref.read(searchViewModelProvider).isLoading) {
            notifier.fetchMorePublicDecks();
          }
          break;

        case 1: // Của tôi
          if (stateData.myDecksHasMore &&
              !ref.read(searchViewModelProvider).isLoading) {
            notifier.fetchMoreMyDecks();
          }
          break;

        case 2: // Đã lưu
          if (stateData.savedDecksHasMore &&
              !ref.read(searchViewModelProvider).isLoading) {
            // notifier.fetchMoreSavedDecks();
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchViewModelProvider);
    final theme = Theme.of(context);
    final tabs = ['Tất cả', 'Của tôi', 'Đã lưu'];

    return Scaffold(
      appBar: AppBar(
        // Search bar
        title: TextField(
          controller: searchController,
          cursorColor: theme.colorScheme.onPrimary,
          decoration: InputDecoration(
            hintText: 'Search',
            suffixIcon: const Icon(Icons.search_outlined),
            filled: true,
            fillColor: theme.colorScheme.secondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Sizes.md),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Sizes.sm,
              vertical: Sizes.md,
            ),
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            PinnedHeaderSliver(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Sizes.sm),
                color: theme.colorScheme.surface,
                child: FilterTabBar(
                  tabs: tabs,
                  selectedIndex: state.value?.currentTabIndex ?? 0,
                  onTabSelected: (value) {
                    // Khi đổi tab, không cần reset dữ liệu tìm kiếm
                    ref.read(searchViewModelProvider.notifier).changeTab(value);
                    // Có thể cuộn lên đầu nếu cần
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                ),
              ),
            ),
          ];
        },

        body: state.when(
          loading: () {
            // Nếu có dữ liệu cũ thì hiển thị, nếu không thì hiển thị center loading
            if (state.value?.publicDecks?.isNotEmpty == true) {
              return _buildDeckList(state.value!, isInitialLoading: true);
            }
            return const Center(child: CircularProgressIndicator());
          },
          error: (error, stack) => Center(
            child: Text('Lỗi tải dữ liệu: $error'),
          ),

          data: (data) {
            return _buildDeckList(
              data,
              isInitialLoading: false,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDeckList(
    SearchState data, {
    required bool isInitialLoading,
  }) {
    final viewState = ref.watch(searchViewModelProvider);

    // ✅ Chọn danh sách deck theo tab hiện tại
    final List<Deck>? decks;
    bool showLoadingFooter = false;
    String emptyMessage = '';

    switch (data.currentTabIndex) {
      case 0: // Tất cả
        decks = data.publicDecks;
        showLoadingFooter = data.publicDecksHasMore && viewState.isLoading;
        emptyMessage = 'Không tìm thấy bộ thẻ công khai nào.';
        break;

      case 1: // Của tôi
        decks = data.myDecks;
        showLoadingFooter = data.myDecksHasMore && viewState.isLoading;
        emptyMessage = 'Bạn chưa có bộ thẻ cá nhân nào.';
        break;

      case 2: // Đã lưu
        decks = data.savedDecks;
        showLoadingFooter = data.savedDecksHasMore && viewState.isLoading;
        emptyMessage = 'Bạn chưa lưu bộ thẻ nào.';
        break;

      default:
        decks = [];
    }

    if ((decks == null || decks.isEmpty) && !isInitialLoading) {
      return Center(
        child: Text(
          emptyMessage,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    // // Chỉ kiểm tra rỗng khi không có lỗi và không phải đang tải lần đầu
    // if (decks!.isEmpty && !isInitialLoading) {
    //   return Center(
    //     child: Text(
    //       data.currentTabIndex == 0
    //           ? 'Không tìm thấy bộ thẻ công khai nào.'
    //           : 'Bạn chưa có bộ thẻ cá nhân nào.',
    //     ),
    //   );
    // }

    // final bool showLoadingFooter =
    //     data.currentTabIndex == 0 &&
    //     data.publicDecksHasMore &&
    //     ref.watch(searchViewModelProvider).isLoading;

    // Số lượng item trong ListView (cộng thêm 1 cho loading footer nếu có)
    final itemCount = (decks?.length ?? 0) + (showLoadingFooter ? 1 : 0);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: GridView.builder(
        physics:
            const NeverScrollableScrollPhysics(), // Để scroll view cha xử lý
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: Sizes.md,
          mainAxisSpacing: Sizes.md,
          childAspectRatio:
              Sizes.cardAspectRatio, // Tỉ lệ chiều rộng/chiều cao của card
        ),
        key: ValueKey(
          data.currentTabIndex,
        ), // Thay đổi key khi đổi tab để kích hoạt AnimatedSwitcher
        controller: _scrollController, // Gán ScrollController vào GridView
        padding: const EdgeInsets.symmetric(horizontal: Sizes.sm),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          // Xử lý Loading Footer
          if (index == decks!.length && showLoadingFooter) {
            return const Padding(
              padding: EdgeInsets.all(Sizes.md),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // Xử lý Deck Card
          final deck = decks[index];
          return DeckCard(
            did: deck.did,
            title: deck.name,
            description: deck.description,
          );
        },
      ),
    );
  }
}
