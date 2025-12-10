import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';

void showCreateOptions(BuildContext context, WidgetRef ref) {
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
              leading: const Icon(Icons.edit),
              title: const Text('Tạo thủ công'),
              onTap: () {
                sheetContext.pop();
                context.pushNamed(AppRoutes.createDecks.name);
              },
            ),
            SizedBox(height: Sizes.sm),
            ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('Tạo thông minh từ File'),
              onTap: () {
                sheetContext.pop();
                // Mở quy trình AI
                _handleAiImport(context, ref);
              },
            ),
            SizedBox(height: Sizes.xl * 1.5),
          ],
        ),
      );
    },
  );
}

Future<void> _handleAiImport(BuildContext context, WidgetRef ref) async {
  final text = await ref.read(fileServiceProvider).pickAndExtractText();

  if (text != null) {
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      final cards = await ref
          .read(flashcardRepositoryProvider)
          .generateFlashcardsFromText(text);

      if (context.mounted) {
        Navigator.of(context).pop();
        context.pushNamed(
          AppRoutes.createDecks.name,
          extra: cards,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }
}
