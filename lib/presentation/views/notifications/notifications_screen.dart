import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
import 'package:hocado/presentation/views/notifications/notification_item.dart';
import 'package:hocado/presentation/widgets/hocado_back.dart';
import 'package:hocado/presentation/widgets/hocado_dialog.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final notifications = ref.watch(notificationViewModelProvider);
    final notifier = ref.watch(notificationViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      appBar: _buildAppBar(context, notifier),

      body: RefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.sm,
            vertical: Sizes.md,
          ),
          child: notifications.when(
            data: (notifications) {
              if (notifications.isEmpty) {
                return Center(
                  child: Text(
                    'Bạn chưa có thông báo nào',
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                      itemBuilder: (context, index) => NotificationItem(
                        noti: notifications[index],
                      ),
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, NotificationViewModel notifier) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: colorScheme.secondary,
      leading: HocadoBack(),
      title: Text(
        'Thông báo',
        style: textTheme.headlineSmall,
      ),
      centerTitle: false,
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_vert),

          color: colorScheme.surfaceContainerHighest,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'readAll',
              child: Text(
                'Đánh dấu tất cả đã đọc',
                style: textTheme.bodyMedium,
              ),
            ),
            PopupMenuItem(
              value: 'deleteAll',
              child: Text(
                'Xóa tất cả',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'readAll') {
              await notifier.markAllNotificationsAsRead();
            } else if (value == 'deleteAll') {
              final confirm = await showConfirmDialog(
                context,
                "Xóa thông báo",
                "Bạn có chắc muốn xóa toàn bộ thông báo?",
              );

              if (confirm == null || !confirm) return;
              await notifier.deleteAllNotifications();
            }
          },
        ),
      ],
    );
  }
}
