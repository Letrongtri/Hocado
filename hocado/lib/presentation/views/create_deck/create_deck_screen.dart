import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/views/create_deck/deck_info_card.dart';
import 'package:hocado/presentation/views/create_deck/flashcard_info_item.dart';
import 'package:hocado/presentation/widgets/hocado_back.dart';
import 'package:hocado/presentation/widgets/hocado_divider.dart';
import 'package:hocado/presentation/widgets/hocado_switch.dart';

class CreateDeckScreen extends ConsumerStatefulWidget {
  final String? did;
  final List<Flashcard>? flashcards;

  const CreateDeckScreen({super.key, this.did, this.flashcards});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateDeckScreenState();
}

class _CreateDeckScreenState extends ConsumerState<CreateDeckScreen> {
  String? did;
  List<Flashcard>? flashcards;
  bool _hasLoadedAiCards = false;

  @override
  void initState() {
    super.initState();
    did = widget.did;
    flashcards = widget.flashcards;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final asyncCreateState = ref.watch(createDeckViewModelProvider(did));

    return asyncCreateState.when(
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Đã có lỗi xảy ra: $error'),
        ),
      ),
      data: (createState) {
        if (widget.flashcards != null && !_hasLoadedAiCards) {
          Future.microtask(() {
            if (mounted) {
              ref
                  .read(createDeckViewModelProvider(widget.did).notifier)
                  .loadGeneratedFlashcards(widget.flashcards!);

              setState(() {
                _hasLoadedAiCards = true;
              });
            }
          });
        }

        final deck = createState.deck;
        final cardList = createState.flashcards;

        return _buildMainScaffold(theme, ref, context, deck, cardList);
      },
    );
  }

  Scaffold _buildMainScaffold(
    ThemeData theme,
    WidgetRef ref,
    BuildContext context,
    Deck deck,
    List<Flashcard>? cardList,
  ) {
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
              _showSettingDeckModalBottomSheet(context, ref, deck);
            },
            icon: const Icon(Icons.settings_outlined),
          ),
          SizedBox(width: Sizes.xs),
          IconButton(
            onPressed: () async {
              await ref
                  .read(createDeckViewModelProvider(did).notifier)
                  .saveChanges();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lưu thành công!')),
                );
                context.pop();
              }
            },
            icon: Icon(Icons.check),
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
              onUpdated: (record) {
                final updatedDeck = record.$1;
                final thumbnail = record.$2;
                ref
                    .read(createDeckViewModelProvider(did).notifier)
                    .updateDeckInfo(updatedDeck, thumbnail);
              },
            ),
            const SizedBox(height: Sizes.md),
            HocadoDivider(),
            const SizedBox(height: Sizes.md),

            // Dùng ListView.separated để tạo danh sách thẻ và nút "+" ở giữa
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cardList?.length ?? 0,
              itemBuilder: (context, index) {
                final card = cardList![index];
                return Column(
                  children: [
                    FlashcardInfoItem(
                      key: ValueKey(
                        card.fid,
                      ), // Key quan trọng để Flutter nhận diện đúng widget
                      card: card,
                      onCardDelete: (fid) {
                        ref
                            .read(createDeckViewModelProvider(did).notifier)
                            .deleteFlashcard(fid);
                      },
                      onCardChanged: (record) {
                        final flashcard = record.$1;
                        final frontImage = record.$2;
                        final backImage = record.$3;

                        ref
                            .read(createDeckViewModelProvider(did).notifier)
                            .updateFlashcardInfo(
                              flashcard,
                              frontImage,
                              backImage,
                            );
                      },
                      onAddCard: () {
                        ref
                            .read(createDeckViewModelProvider(did).notifier)
                            .addFlashcardBelow(card.fid);
                      },
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
    Deck deck,
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
                            .read(
                              createDeckViewModelProvider(did).notifier,
                            )
                            .deleteDeck();

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
