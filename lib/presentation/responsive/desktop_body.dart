import 'package:flutter/material.dart';
import 'package:hocado/core/constants/images.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/utils/nav_items.dart';

class DesktopBody extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const DesktopBody({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          labelType: NavigationRailLabelType.all,
          elevation: 5,
          groupAlignment: -0.8,
          leading: Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.lg),
            child: Image.asset(Images.appLogo, height: 40, width: 40),
          ),
          destinations: appNavItems
              .map(
                (item) => NavigationRailDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: Text(item.label),
                ),
              )
              .toList(),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(child: child),
      ],
    );
  }
}
