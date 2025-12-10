import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';

class AddCardButton extends StatelessWidget {
  const AddCardButton({super.key, required this.onAddCard});
  final VoidCallback onAddCard;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.add_circle_outline, size: Sizes.iconLg),
        color: Theme.of(context).colorScheme.onPrimary.withAlpha(100),
        onPressed: onAddCard,
      ),
    );
  }
}
