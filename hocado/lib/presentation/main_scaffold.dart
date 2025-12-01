import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/auth_provider.dart';
import 'package:hocado/app/provider/notification_provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/views/create_deck/create_options.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.toString();

    final currentIndex = _locationToIndex(location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(
                color: theme.colorScheme.onSurface,
                size: Sizes.iconLg,
              );
            }
            return IconThemeData(
              color: theme.colorScheme.onPrimary,
              size: Sizes.iconMd,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            final destination = _indexToRoute(index);
            if (destination != location) {
              if (destination == AppRoutes.createDecks.name) {
                // context.pushNamed(destination);
                showCreateOptions(context, ref);
              } else if (destination == AppRoutes.profile.name) {
                final userId = ref.watch(currentUserProvider)?.uid;
                if (userId == null || userId.isEmpty) return;
                context.goNamed(destination, pathParameters: {'uid': userId});
              } else {
                context.goNamed(destination);
              }
            }
          },

          height: Sizes.appBarHeight,
          elevation: Sizes.btnElevation,
          indicatorColor: Colors.transparent,
          indicatorShape: CircleBorder(),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          animationDuration: Durations.short3,
          backgroundColor: theme.colorScheme.secondary,

          destinations: [
            NavigationDestination(
              icon: currentIndex == 0
                  ? Icon(Icons.home)
                  : Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: currentIndex == 1
                  ? Icon(Icons.folder_copy)
                  : Icon(Icons.folder_copy_outlined),
              label: 'Decks',
            ),
            NavigationDestination(
              icon: currentIndex == 2
                  ? Icon(Icons.add_circle)
                  : Icon(Icons.add_circle_outline),
              label: 'Add',
            ),
            NavigationDestination(
              icon: currentIndex == 3
                  ? Icon(Icons.person)
                  : Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  int _locationToIndex(String location) {
    if (location.startsWith('/decks')) return 1;
    if (location.startsWith('/create')) return 2;
    if (location.startsWith('/users')) return 3;
    return 0; // default: home
  }

  String _indexToRoute(int index) {
    switch (index) {
      case 1:
        return AppRoutes.decks.name;
      case 2:
        return AppRoutes.createDecks.name;
      case 3:
        return AppRoutes.profile.name;
      default:
        return AppRoutes.home.name;
    }
  }
}
