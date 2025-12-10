import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';

class HocadoButtonLg extends StatelessWidget {
  const HocadoButtonLg({
    super.key,
    required this.text,
    this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Sizes.btnHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.onPrimary,
          foregroundColor: Theme.of(
            context,
          ).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Sizes.btnRadius,
            ),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
