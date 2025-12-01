import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      cursorColor: theme.colorScheme.onPrimary,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: theme.colorScheme.onSurface.withAlpha(30),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.md),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: Sizes.md),
      ),
      onTap: () {
        if (context.mounted) {
          context.pushNamed(AppRoutes.search.name, extra: {'isFocus': true});
        }
      },
    );
  }
}
