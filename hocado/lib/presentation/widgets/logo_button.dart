import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';

class LogoButton extends StatelessWidget {
  final String iconName;
  final VoidCallback? onPressed;

  const LogoButton({
    super.key,
    required this.iconName,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Image(
          width: Sizes.iconLg,
          height: Sizes.iconLg,
          image: AssetImage(iconName),
        ),
      ),
    );
  }
}
