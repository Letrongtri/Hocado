import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/user.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
import 'package:hocado/presentation/widgets/hocado_dialog.dart';

class FollowButton extends ConsumerWidget {
  const FollowButton({
    super.key,
    required this.user,
    required this.profileStatus,
  });

  final User user;
  final String profileStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(profileViewModelProvider(user.uid).notifier);
    return ElevatedButton(
      onPressed: () async {
        if (profileStatus == ProfileStatus.notFollowing.name) {
          await notifier.followUser(user.uid, user.fullName);
        } else if (profileStatus == ProfileStatus.isFollowing.name) {
          final confirm = await showConfirmDialog(
            context,
            'Hủy theo dõi',
            'Bạn có chắc muốn hủy theo dõi ${user.fullName} không?',
          );
          if (confirm != null && confirm) await notifier.unfollowUser(user.uid);
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: Sizes.sm, horizontal: Sizes.md),
        backgroundColor: theme.colorScheme.onPrimary,
        foregroundColor: theme.colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Sizes.btnRadius,
          ),
        ),
      ),
      child: Text(
        profileStatus == ProfileStatus.isFollowing.name
            ? 'Đang theo dõi'
            : 'Theo dõi',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
