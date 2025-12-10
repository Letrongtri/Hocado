import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/widgets/hocado_dialog.dart';
import 'package:hocado/utils/format_date_time.dart';

class NotificationItem extends ConsumerWidget {
  const NotificationItem({super.key, required this.noti});

  final NotificationMessage noti;

  void _openNotification(BuildContext context) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.watch(notificationViewModelProvider.notifier);

    final icon = noti.type == NotificationType.achievement
        ? Icons.emoji_events
        : noti.type == NotificationType.reminder
        ? Icons.schedule
        : noti.type == NotificationType.social
        ? Icons.group
        : noti.type == NotificationType.promotion
        ? Icons.local_offer
        : Icons.notifications_active;

    final background = noti.type == NotificationType.achievement
        ? AppColors.masteredColorBg
        : noti.type == NotificationType.reminder
        ? AppColors.ongoingColorBg
        : noti.type == NotificationType.social
        ? AppColors.almostDoneColorBg
        : noti.type == NotificationType.promotion
        ? AppColors.notLearnedColorBg
        : theme.colorScheme.primary;

    return Dismissible(
      key: ValueKey(noti.nid),
      direction: DismissDirection.endToStart,
      background: Container(
        color: theme.colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Sizes.md),
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
      confirmDismiss: (direction) {
        return showConfirmDialog(
          context,
          "Xóa thông báo",
          "Bạn có chắc muốn xóa thông báo này?",
        );
      },
      onDismissed: (direction) async =>
          await notifier.deleteNotification(noti.nid),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: background,
          child: Icon(icon, color: theme.colorScheme.onPrimary),
        ),
        title: Text(
          noti.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: !noti.isRead ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noti.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: !noti.isRead ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              formatTimeAgo(noti.createdAt),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: !noti.isRead ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        onTap: () async {
          await notifier.markNotificationAsRead(noti.nid);
          if (context.mounted) {
            _openNotification(context);
          }
        },
      ),
    );
  }
}
