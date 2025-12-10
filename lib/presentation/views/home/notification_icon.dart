import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';

class NotificationIcon extends ConsumerWidget {
  const NotificationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null) {
      return const Icon(Icons.notifications_none_rounded);
    }

    final count = ref.watch(notificationCountProvider(currentUser.uid));

    return Padding(
      padding: const EdgeInsets.all(Sizes.sm),
      child: count.when(
        data: (count) => Badge(
          isLabelVisible: count > 0,
          label: Text(count > 99 ? '99+' : count.toString()),
          backgroundColor: theme.colorScheme.error,
          textColor: theme.colorScheme.onError,
          child: InkWell(
            onTap: () {
              context.pushNamed(AppRoutes.notifications.name);
            },
            child: const Icon(Icons.notifications_none_rounded, size: 28),
          ),
        ),
        error: (error, stackTrace) =>
            const Icon(Icons.notifications_none_rounded),
        loading: () => const Icon(Icons.notifications_none_rounded),
      ),
    );
  }
}
