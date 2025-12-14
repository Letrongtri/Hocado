import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/auth_provider.dart';
import 'package:hocado/app/provider/notification_provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/views/create_deck/create_options.dart';
import 'package:hocado/presentation/responsive/desktop_body.dart';
import 'package:hocado/presentation/responsive/mobile_body.dart';
import 'package:hocado/utils/nav_items.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupNotification();
    });
  }

  void _setupNotification() {
    ref.read(notificationViewModelProvider.notifier).setupInteractedMessage(
      (message) {
        if (mounted) {
          _openNotification(context, message);
        }
      },
    );
  }

  void _openNotification(BuildContext context, NotificationMessage noti) {
    final metadata = noti.metadata ?? {};

    switch (noti.type) {
      case NotificationType.achievement:
        final userId = metadata['uid'] as String;
        if (userId.isNotEmpty) {
          context.pushNamed(
            AppRoutes.profile.name,
            pathParameters: {'uid': userId},
          );
        } else {
          context.pushNamed(AppRoutes.home.name);
        }
        break;
      case NotificationType.reminder:
        final deckId = metadata['did'] as String;
        if (deckId.isNotEmpty) {
          context.pushNamed(
            AppRoutes.detailDeck.name,
            pathParameters: {'did': deckId},
          );
        } else {
          context.pushNamed(AppRoutes.home.name);
        }
        break;
      case NotificationType.social:
        final userId = metadata['uid'] as String;
        if (userId.isNotEmpty) {
          context.pushNamed(
            AppRoutes.profile.name,
            pathParameters: {'uid': userId},
          );
        } else {
          context.pushNamed(AppRoutes.home.name);
        }
        break;
      case NotificationType.promotion:
        break;
      default:
        final specificRoute = metadata['route'];
        if (specificRoute != null) {
          context.push(specificRoute);
        }
        break;
    }
  }

  void _onDestinationSelected(int index) {
    final destination = _indexToRoute(index);
    final location = GoRouterState.of(context).uri.toString();

    if (destination != location) {
      if (destination == AppRoutes.createDecks.name) {
        // context.pushNamed(destination);
        showCreateOptions(context, ref);
      } else if (destination == AppRoutes.myProfile.name) {
        final userId = ref.watch(currentUserProvider)?.uid;
        if (userId == null || userId.isEmpty) return;
        context.goNamed(destination);
      } else {
        context.goNamed(destination);
      }
    }
  }

  int _calculateSelectedIndex(BuildContext context, String location) {
    // Tìm index dựa trên routeName trong appNavItems
    // Ví dụ: location '/decks/123' sẽ match với nav item có route '/decks'
    for (int i = 0; i < appNavItems.length; i++) {
      if (location.startsWith('/create') && i == 1) return 1;
      if (location.startsWith('/decks') && i == 2) return 2;
      if (location.startsWith('/my-profile') && i == 3) return 3;
      if ((location == '/home' || location == '/') && i == 0) return 0;
    }
    return 0; // Default Home
  }

  String _indexToRoute(int index) {
    switch (index) {
      case 1:
        return AppRoutes.createDecks.name;
      case 2:
        return AppRoutes.decks.name;
      case 3:
        return AppRoutes.myProfile.name;
      default:
        return AppRoutes.home.name;
    }
  }

  bool _shouldHideBottomNav(String location) {
    // Danh sách các route muốn ẩn BottomBar trên Mobile
    // Lưu ý: Desktop vẫn hiện bình thường vì logic này chỉ truyền vào MobileShell
    final hiddenRoutes = [
      '/search',
      '/settings',
      '/notifications',
      '/profile-settings',
      '/system-settings',
      '/users/',
    ];

    // Kiểm tra xem location hiện tại có bắt đầu bằng các route trên không
    for (var route in hiddenRoutes) {
      if (location.startsWith(route)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _calculateSelectedIndex(context, location);
    final hideBottomNav = _shouldHideBottomNav(location);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < Sizes.mobileWidth) {
          return MobileBody(
            selectedIndex: selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            hideBottomNav: hideBottomNav,
            child: widget.child,
          );
        } else {
          return DesktopBody(
            selectedIndex: selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            child: widget.child,
          );
        }
      },
    );
  }
}
