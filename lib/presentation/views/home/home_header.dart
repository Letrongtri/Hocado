import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/auth_provider.dart';
import 'package:hocado/app/provider/user_provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/user.dart';
import 'package:hocado/presentation/views/home/notification_icon.dart';
import 'package:hocado/presentation/widgets/hocado_avatar.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final currentUser = ref.watch(currentUserProvider);

    if (currentUser == null) return const SizedBox.shrink();

    final user = ref.watch(userProfileProvider(currentUser.uid));

    return user.when(
      data: (user) => _buildHeader(context, user, theme),
      error: (error, stackTrace) => const Center(child: Text('Error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Row _buildHeader(BuildContext context, User user, ThemeData theme) {
    return Row(
      children: [
        // Avatar
        HocadoAvatar(user: user, size: 25),
        const SizedBox(width: Sizes.sm),
        // Welcome Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello,', style: theme.textTheme.bodyMedium),
            Text(
              user.fullName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Notification Bell
        NotificationIcon(),
      ],
    );
  }
}
