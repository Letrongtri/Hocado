import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/core/constants/sizes.dart';

class AddCardButton extends ConsumerWidget {
  final String fid;
  final String did;
  const AddCardButton({super.key, required this.fid, required this.did});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.add_circle_outline, size: Sizes.iconLg),
        color: Theme.of(context).colorScheme.onPrimary.withAlpha(100),
        onPressed: () {
          // Gọi hàm addCard từ provider
          ref
              .read(createDeckViewModelProvider(did).notifier)
              .addFlashcardBelow(fid);
        },
      ),
    );
  }
}
