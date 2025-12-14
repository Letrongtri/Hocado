import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/utils/nav_items.dart';

class MobileBody extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final bool hideBottomNav;

  const MobileBody({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.hideBottomNav = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: child,
      bottomNavigationBar: hideBottomNav
          ? null
          : NavigationBarTheme(
              data: NavigationBarThemeData(
                iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return IconThemeData(
                      color: colorScheme.onSurface,
                      size: Sizes.iconLg,
                    );
                  }
                  return IconThemeData(
                    color: colorScheme.onPrimary,
                    size: Sizes.iconMd,
                  );
                }),
              ),
              child: NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,

                height: Sizes.appBarHeight,
                elevation: Sizes.btnElevation,
                indicatorColor: Colors.transparent,
                indicatorShape: CircleBorder(),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                animationDuration: Durations.short3,
                backgroundColor: colorScheme.secondary,

                destinations: appNavItems
                    .map(
                      (item) => NavigationDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.selectedIcon),
                        label: item.label,
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
