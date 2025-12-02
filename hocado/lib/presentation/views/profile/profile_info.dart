import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/images.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/user.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
import 'package:hocado/presentation/views/profile/follow_button.dart';
import 'package:hocado/presentation/views/profile/profile_stats_info.dart';
import 'package:hocado/presentation/widgets/hocado_avatar.dart';
import 'package:hocado/utils/format_date_time.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
    required this.user,
    required this.profileStatus,
  });

  final User user;
  final String profileStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          children: [
            // background
            Container(
              height: Sizes.backgroundProfileHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                image: DecorationImage(
                  image: AssetImage(Images.profileBg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Nội dung chính
            Column(
              children: [
                // Khoảng trống cho AppBar và icon camera
                const SizedBox(height: 140),

                // Icon camera
                Row(
                  children: [
                    SizedBox(width: Sizes.md),
                    // Avatar
                    HocadoAvatar(user: user),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: theme.colorScheme.onPrimary,
                      ),
                      iconSize: 30,
                      onPressed: () {
                        // Xử lý chọn ảnh bìa
                      },
                    ),
                    SizedBox(width: Sizes.sm),
                  ],
                ),
              ],
            ),
          ],
        ),

        _buildProfileInfo(user, theme),
      ],
    );
  }

  Container _buildProfileInfo(User user, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
      margin: EdgeInsets.only(bottom: Sizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Sizes.md),
          // tên
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  user.fullName,
                  style: theme.textTheme.headlineMedium,
                ),
              ),

              if (profileStatus != ProfileStatus.myProfile.name)
                FollowButton(user: user, profileStatus: profileStatus),
            ],
          ),
          const SizedBox(height: Sizes.sm),
          Row(
            children: [
              _buildInfoItem(
                theme,
                user.email,
                Icons.email_outlined,
                AppColors.almostDoneColorFg,
                AppColors.almostDoneColorBg,
              ),

              const SizedBox(width: Sizes.sm), // khoảng cách trước vạch
              Container(
                width: Sizes.dividerHeight, // độ dày vạch
                height: Sizes.md, // chiều cao vạch
                color: theme.colorScheme.onPrimary, // màu vạch
              ),
              const SizedBox(width: Sizes.sm),

              _buildInfoItem(
                theme,
                user.phone,
                Icons.phone_outlined,
                AppColors.notLearnedColorFg,
                AppColors.notLearnedColorBg,
              ),
            ],
          ),
          const SizedBox(height: Sizes.sm),
          _buildInfoItem(
            theme,
            'Tham gia ${formatDate(user.createdAt)}',
            Icons.calendar_month_outlined,
            AppColors.correctColorFg,
            AppColors.correctColorBg,
          ),
          const SizedBox(height: Sizes.lg),

          // Thống kê 4 mục
          ProfileStatsInfo(
            followersCount: user.followersCount,
            followingCount: user.followingCount,
            createdDecksCount: user.createdDecksCount,
            savedDecksCount: user.savedDecksCount,
          ),
        ],
      ),
    );
  }

  Row _buildInfoItem(
    ThemeData theme,
    String text,
    IconData icon,
    Color fg,
    Color bg,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(Sizes.xs),
          margin: EdgeInsets.only(right: Sizes.xs),
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: Sizes.iconSm,
            color: fg,
          ),
        ),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary.withAlpha(220),
          ),
        ),
      ],
    );
  }
}
