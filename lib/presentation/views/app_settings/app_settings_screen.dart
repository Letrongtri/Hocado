import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/widgets/hocado_back.dart';
import 'package:hocado/presentation/widgets/hocado_dialog.dart';

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        leading: HocadoBack(),
        title: Text(
          'Cài đặt',
          style: theme.textTheme.headlineSmall,
        ),
        centerTitle: false,
      ),

      body: Padding(
        padding: EdgeInsets.only(top: Sizes.sm, bottom: Sizes.md),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: Sizes.md),
                child: Text(
                  'Tài khoản',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              SizedBox(height: Sizes.sm),
              _buildSettingItem(
                theme,
                icon: Icons.person,
                title: 'Cài đặt tài khoản',
                onTap: () {
                  context.pushNamed(AppRoutes.profileSettings.name);
                },
              ),
              SizedBox(height: Sizes.sm),
              _buildSettingItem(
                theme,
                icon: Icons.palette,
                iconColor: AppColors.ongoingColorBg,
                title: 'Tùy chỉnh',
                onTap: () {
                  context.pushNamed(AppRoutes.systemSettings.name);
                },
              ),

              SizedBox(height: Sizes.md),
              Padding(
                padding: const EdgeInsets.only(left: Sizes.md),
                child: Text(
                  'Hỗ trợ và pháp lý',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              SizedBox(height: Sizes.sm),
              _buildSettingItem(
                theme,
                icon: Icons.help,
                iconColor: AppColors.ongoingColorBg,
                title: 'Hỗ trợ',
                onTap: () {},
              ),
              SizedBox(height: Sizes.sm),
              _buildSettingItem(
                theme,
                icon: Icons.privacy_tip,
                iconColor: AppColors.almostDoneColorBg,
                title: 'Chính sách bảo mật',
                onTap: () {},
              ),
              SizedBox(height: Sizes.sm),

              _buildSettingItem(
                theme,
                icon: Icons.logout,
                iconColor: AppColors.incorrectColorBg,
                title: 'Đăng xuất',
                hasTrailing: false,
                onTap: () async {
                  final confirm = await showConfirmDialog(
                    context,
                    "Đăng xuất",
                    "Bạn có chắc muốn đăng xuất?",
                  );

                  if (confirm == null || !confirm) return;

                  ref.read(profileSettingsViewModelProvider.notifier).signOut();
                  ref.invalidate(currentUserProvider);
                  if (context.mounted) {
                    showSuccessSnackbar(context, "Đăng xuất thành công!");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    ThemeData theme, {
    required String title,
    required IconData icon,
    Color? iconColor,
    required Function() onTap,
    bool hasTrailing = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.xs),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: iconColor ?? theme.colorScheme.primary,
            child: Icon(
              icon,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          title: Text(
            title,
            style: theme.textTheme.titleMedium,
          ),
          trailing: hasTrailing
              ? Icon(
                  Icons.arrow_forward_ios,
                  color: theme.colorScheme.onPrimary,
                )
              : null,
        ),
      ),
    );
  }
}
