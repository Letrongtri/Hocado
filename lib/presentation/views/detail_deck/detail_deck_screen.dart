import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
import 'package:hocado/presentation/views/detail_deck/flashcard_list_item.dart';
import 'package:hocado/presentation/views/detail_deck/flashcard_pager.dart';
import 'package:hocado/presentation/widgets/hocado_back.dart';
import 'package:share_plus/share_plus.dart';

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
          state.ownershipStatus,
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
    DeckOwnershipStatus ownershipStatus,
    WidgetRef ref,
  ) {
    final notifier = ref.read(detailDeckViewModelProvider(deckId).notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        leading: HocadoBack(),
        actions: [
          IconButton(
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: '${deck.name} ${deck.did}',
                ),
              );
            },
            icon: const Icon(Icons.share_outlined),
          ),

          if (ownershipStatus == DeckOwnershipStatus.myDeck)
            IconButton(
              onPressed: () {
                context.pushNamed(
                  AppRoutes.editDeck.name,
                  pathParameters: {'did': deckId},
                );
              },
              icon: const Icon(Icons.edit_outlined),
            ),

          if (ownershipStatus == DeckOwnershipStatus.savedDeck)
            IconButton(
              onPressed: () async {
                final shouldDelete = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Xác nhận xóa"),
                    content: Text(
                      "Bạn có chắc chắn muốn xóa lưu bộ thẻ này không?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          "Hủy",
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Xóa",
                          style: TextStyle(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (shouldDelete == true) {
                  notifier.unsaveDeck();
                }
              },
              icon: const Icon(Icons.favorite, color: Colors.red),
            ),

          if (ownershipStatus == DeckOwnershipStatus.unsaveDeck)
            IconButton(
              onPressed: () {
                notifier.saveDeck();
              },
              icon: const Icon(Icons.favorite_outline),
            ),

          if (ownershipStatus != DeckOwnershipStatus.myDeck)
            IconButton(
              onPressed: () async {
                if (context.mounted) {
                  context.pushNamed(
                    AppRoutes.profile.name,
                    pathParameters: {'uid': deck.uid},
                  );
                }
              },
              icon: const Icon(Icons.person_2_outlined),
            ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(detailDeckViewModelProvider(deckId).notifier).build();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(Sizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.all(Sizes.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deck.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Sizes.sm),
                      Text(
                        deck.description,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Sizes.lg),

                // Section 1: Flashcard Pager
                FlashcardPager(flashcards: flashcards ?? []),
                const SizedBox(height: Sizes.xl),

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
        height: Sizes.btnLgHeight,
        color: theme.colorScheme.secondary,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Sizes.btnLgRadius,
              ),
            ),
          ),
          onPressed: () {
            showLearningOptionsSheet(context);
          },
          child: const Text(
            'Bắt đầu học',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  void showLearningOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.sm,
            vertical: Sizes.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.menu_book_rounded),
                title: const Text('Học bộ thẻ'),
                onTap: () {
                  sheetContext.pop();
                  context.pushNamed(
                    AppRoutes.learningSettings.name,
                    pathParameters: {'did': deckId},
                    queryParameters: {'mode': 'learn'},
                  );
                },
              ),
              SizedBox(height: Sizes.sm),
              ListTile(
                leading: const Icon(Icons.quiz_outlined),
                title: const Text('Kiểm tra'),
                onTap: () {
                  sheetContext.pop();
                  context.pushNamed(
                    AppRoutes.learningSettings.name,
                    pathParameters: {'did': deckId},
                    queryParameters: {'mode': 'test'},
                  );
                },
              ),
              SizedBox(height: Sizes.xl * 1.5),
            ],
          ),
        );
      },
    );
  }
}
