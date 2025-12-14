import 'package:flutter/material.dart';
import 'package:hocado/app/routing/app_routes.dart';

class NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String routeName;

  const NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.routeName,
  });
}

// Danh sách menu
final List<NavItem> appNavItems = [
  NavItem(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    routeName: AppRoutes.home.name,
  ),
  NavItem(
    label: 'Add',
    icon: Icons.add_circle_outline,
    selectedIcon: Icons.add_circle,
    routeName: AppRoutes.createDecks.name,
  ),
  NavItem(
    label: 'Decks',
    icon: Icons.folder_copy_outlined,
    selectedIcon: Icons.folder_copy,
    routeName: AppRoutes.decks.name,
  ),
  NavItem(
    label: 'Profile',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    routeName: AppRoutes.myProfile.name,
  ),
];
