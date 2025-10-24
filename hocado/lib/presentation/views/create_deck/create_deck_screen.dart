import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/deck_provider.dart';
import 'package:hocado/app/provider/flashcard_provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/deck.dart';
import 'package:hocado/presentation/views/create_deck/deck_info_card.dart';
import 'package:hocado/presentation/views/create_deck/flashcard_info_item.dart';
import 'package:hocado/presentation/widgets/hocado_back.dart';
import 'package:hocado/presentation/widgets/hocado_divider.dart';
import 'package:hocado/presentation/widgets/hocado_switch.dart';

class CreateDeckScreen extends ConsumerStatefulWidget {
  final String? did;

  const CreateDeckScreen({super.key, this.did});

  @override
  ConsumerState<CreateDeckScreen> createState() => _CreateDeckScreenState();
}

class _CreateDeckScreenState extends ConsumerState<CreateDeckScreen> {
  late Deck deck;
  late final String did;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // deck = widget.deck ?? Deck.empty();
    if (widget.did != null) {
      did = widget.did!;
      _loadDeck();
    } else {
      deck = Deck.empty();
      did = deck.did;
    }
  }

  Future<void> _loadDeck() async {
    setState(() => _isLoading = true);

    final fetched = await ref
        .read(decksViewModelProvider.notifier)
        .findDeckByDid(widget.did!);

    if (fetched != null) {
      deck = fetched;

      // Nếu deck có flashcards thì tải luôn
      if (deck.totalCards > 0) {
        final cards = await ref
            .read(flashcardsViewModelProvider(deck.did).notifier)
            .fetchFlashcards();

        ref
            .read(editFlashcardsViewModelProvider(deck.did).notifier)
            .setFlashcards(cards);
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Theo dõi danh sách thẻ từ provider
    final flashcardState = ref.watch(editFlashcardsViewModelProvider(did));
    final asyncDecks = ref.watch(decksViewModelProvider);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final cardList = flashcardState.flashcards;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        leading: HocadoBack(),
        title: Text(
          'Tạo thẻ',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSettingDeckModalBottomSheet(context, ref);
            },
            icon: const Icon(Icons.settings_outlined),
          ),
          SizedBox(width: Sizes.xs),
          IconButton(
            onPressed: asyncDecks.isLoading
                ? null
                : () async {
                    final now = DateTime.now();

                    await Future.wait([
                      ref
                          .read(decksViewModelProvider.notifier)
                          .createDeck(
                            deck: deck,
                            totalCards: cardList.length,
                            createdAt: now,
                          ),

                      ref
                          .read(flashcardsViewModelProvider(deck.did).notifier)
                          .createFlashcards(
                            flashcards: cardList,
                            createdAt: now,
                          ),
                    ]);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lưu thành công!')),
                      );
                    }
                    if (context.mounted) context.pop();
                  },
            icon: asyncDecks.isLoading
                ? CircularProgressIndicator()
                : Icon(Icons.check),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          children: [
            // Widget cho thông tin bộ thẻ
            DeckInfoCard(
              deck: deck,
              onUpdated: (updatedDeck) {
                setState(() {
                  deck = updatedDeck;
                });
              },
            ),
            const SizedBox(height: Sizes.md),
            HocadoDivider(),
            const SizedBox(height: Sizes.md),

            // Dùng ListView.separated để tạo danh sách thẻ và nút "+" ở giữa
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cardList.length,
              itemBuilder: (context, index) {
                final card = cardList[index];
                return Column(
                  children: [
                    FlashcardInfoItem(
                      key: ValueKey(
                        card.fid,
                      ), // Key quan trọng để Flutter nhận diện đúng widget
                      card: card,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSettingDeckModalBottomSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final theme = Theme.of(context);
    bool currentPublicStatus = deck.isPublic;

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Sizes.borderRadiusLg),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsetsGeometry.all(Sizes.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: Sizes.md),

                  ListTile(
                    title: Text("Công khai"),
                    trailing: HocadoSwitch(
                      initialValue: currentPublicStatus,
                      onChanged: (value) {
                        // Xử lý cập nhật trạng thái công khai
                        deck = deck.copyWith(isPublic: value);
                      },
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                    ),
                    tileColor: theme.colorScheme.secondary,
                  ),

                  SizedBox(height: Sizes.sm),
                  ListTile(
                    title: Text("Xoá bộ thẻ"),
                    trailing: Icon(Icons.delete),
                    textColor: theme.colorScheme.error,
                    iconColor: theme.colorScheme.error,
                    onTap: () async {
                      // Xử lý xoá bộ thẻ
                      final shouldDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Xác nhận xóa"),
                          content: Text(
                            "Bạn có chắc chắn muốn xóa bộ thẻ này không?",
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
                        await ref
                            .read(decksViewModelProvider.notifier)
                            .deleteDeck(did);

                        await ref
                            .read(flashcardsViewModelProvider(did).notifier)
                            .deleteFlashcards(did);

                        if (context.mounted) {
                          Navigator.of(context)
                            ..pop() // Đóng bottom sheet
                            ..pop()
                            ..pop(); // Quay lại
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                    ),
                    tileColor: theme.colorScheme.secondary,
                  ),

                  SizedBox(height: Sizes.xl),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
