import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/detail_deck_provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/models/flashcard.dart';
import 'package:hocado/presentation/views/detail_deck/flashcard_list_item.dart';
import 'package:hocado/presentation/views/detail_deck/flashcard_pager.dart';
import 'package:hocado/presentation/views/detail_deck/learning_progress_card.dart';
import 'package:hocado/presentation/widgets/hocado_back.dart';

class DetailDeckScreen extends ConsumerWidget {
  final String deckId;
  const DetailDeckScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(detailDeckViewModelProvider(deckId));

    return state.when(
      data: (state) {
        final deck = state.deck;
        final flashcards = state.cardList;
        return _buildMainScaffold(
          theme,
          context,
          deck,
          flashcards,
          ref,
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.secondary,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.secondary,
        ),
        body: Center(
          child: Text('Error: $error, stackTrace: $stackTrace'),
        ),
      ),
    );
  }

  Scaffold _buildMainScaffold(
    ThemeData theme,
    BuildContext context,
    Deck deck,
    List<Flashcard>? flashcards,
    WidgetRef ref,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        leading: HocadoBack(),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          IconButton(
            onPressed: () {
              context.pushNamed(
                AppRoutes.editDeck.name,
                pathParameters: {'did': deckId},
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(detailDeckViewModelProvider(deckId).notifier)
              .refreshDeckDetails();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(Sizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deck.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Sizes.lg),

                // Section 1: Flashcard Pager
                FlashcardPager(flashcards: flashcards ?? []),
                const SizedBox(height: Sizes.xl),

                // Section 2: Learning Progress
                const LearningProgressCard(),
                const SizedBox(height: Sizes.xl),

                // Section 3: Conditions / Term List
                Text("Điều kiện", style: theme.textTheme.titleMedium),
                const SizedBox(height: Sizes.md),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm thuật ngữ/định nghĩa',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: theme.colorScheme.secondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),

                // Filter Chips
                _buildFilterChips(context, ref),
                const SizedBox(height: 16),

                // Term List
                if (flashcards != null)
                  ListView.separated(
                    itemCount: flashcards.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final card = flashcards[index];
                      return FlashcardListItem(
                        card: card,
                        index: index + 1,
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey.shade200,
                      height: 1,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      // Bottom "Study" Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(Sizes.md),
        color: theme.colorScheme.secondary,
        child: ElevatedButton(
          onPressed: () {
            context.pushNamed(
              AppRoutes.learningSettings.name,
              pathParameters: {'did': deckId},
            );
          },
          child: const Text(
            'Bắt đầu học',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedFilter = 0;
    // final selectedFilter = ref.watch(termFilterProvider);
    final filters = ["Xem tất cả (48)", "Vẫn đang học", "Sắp xong"];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedFilter == index;
          return ChoiceChip(
            label: Text(filters[index]),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                // ref.read(termFilterProvider.notifier).state = index;
              }
            },
            backgroundColor: theme.colorScheme.secondary,
            selectedColor: theme.colorScheme.onSurface,
            labelStyle: TextStyle(
              color: isSelected
                  ? theme.colorScheme.surface
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            shape: StadiumBorder(
              side: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}
