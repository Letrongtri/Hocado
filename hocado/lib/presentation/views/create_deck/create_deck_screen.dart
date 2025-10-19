import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/flashcard_provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/views/create_deck/deck_info_card.dart';
import 'package:hocado/presentation/views/create_deck/flashcard_info_item.dart';
import 'package:hocado/presentation/widgets/hocado_divider.dart';

class CreateDeckScreen extends ConsumerWidget {
  const CreateDeckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theo dõi danh sách thẻ từ provider
    final state = ref.watch(flashcardViewModelProvider);

    final asyncState = ref.watch(flashcardAsyncViewModelProvider);
    final asyncNotifier = ref.read(flashcardAsyncViewModelProvider.notifier);

    final cardList = state.cardList;
    final deck = state.deck;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Tạo thẻ',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSettingDeckModalBottomSheet(
                context,
                ref,
                isPublic: deck?.isPublic ?? false,
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
          SizedBox(width: Sizes.xs),
          IconButton(
            onPressed: asyncState.isLoading
                ? null
                : () async {
                    await asyncNotifier.saveDeckAndFlashcards(deck!, cardList!);

                    asyncState.when(
                      data: (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lưu thành công!')),
                        );
                        Navigator.of(context).pop();
                      },
                      error: (e, _) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lưu thất bại: $e')),
                        );
                      },
                      loading: () {},
                    );
                  },
            icon: asyncState.isLoading
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
            DeckInfoCard(deck: deck!),
            const SizedBox(height: Sizes.md),
            HocadoDivider(),
            const SizedBox(height: Sizes.md),

            // Dùng ListView.separated để tạo danh sách thẻ và nút "+" ở giữa
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cardList!.length,
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

  Future<VoidCallback?> _showSettingDeckModalBottomSheet(
    BuildContext context,
    WidgetRef ref, {
    bool isPublic = true,
  }) {
    final asyncNotifier = ref.read(flashcardViewModelProvider.notifier);
    final state = ref.watch(flashcardViewModelProvider);

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Sizes.borderRadiusLg),
        ),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        bool currentPublicStatus = isPublic;

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
                    trailing: Switch(
                      value: currentPublicStatus,
                      activeThumbColor: theme.colorScheme.primary,
                      onChanged: (value) {
                        // Xử lý cập nhật trạng thái công khai
                        // currentPublicStatus = value;
                        setState(() {
                          currentPublicStatus = value;
                        });
                        asyncNotifier.updateDeckIsPublic(
                          state.deck!.did,
                          value,
                        );
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
                        ref
                            .read(flashcardViewModelProvider.notifier)
                            .clearAll();

                        await ref
                            .read(flashcardAsyncViewModelProvider.notifier)
                            .deleteDeckAndFlashcards(state.deck!.did);
                        Navigator.of(context)
                          ..pop() // Đóng bottom sheet
                          ..pop(); // Quay lại
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
