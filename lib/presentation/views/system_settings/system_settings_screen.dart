import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/widgets/hocado_back.dart';
import 'package:hocado/presentation/widgets/hocado_switch.dart';

class SystemSettingsScreen extends ConsumerWidget {
  const SystemSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(systemSettingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: HocadoBack(),
        title: Text(
          'Tùy chỉnh',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: state.when(
        data: (data) {
          final notifier = ref.watch(systemSettingsViewModelProvider.notifier);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.md,
                    vertical: Sizes.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: Sizes.sm,
                          top: Sizes.sm,
                        ),
                        child: Text(
                          'Giao diện',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      const SizedBox(height: Sizes.sm),
                      _buildThemeOptionItem(
                        theme,
                        context,
                        text: 'Tươi sáng',
                        isChosen: data.themeMode == ThemeMode.light,
                        onTap: () {
                          notifier.saveTheme(ThemeMode.light);
                        },
                      ),

                      const SizedBox(height: Sizes.sm),
                      _buildThemeOptionItem(
                        theme,
                        context,
                        text: 'Bí ẩn',
                        isChosen: data.themeMode == ThemeMode.dark,
                        onTap: () {
                          notifier.saveTheme(ThemeMode.dark);
                        },
                      ),

                      const SizedBox(height: Sizes.sm),
                      _buildThemeOptionItem(
                        theme,
                        context,
                        text: 'Mặc định hệ thống',
                        isChosen: data.themeMode == ThemeMode.system,
                        onTap: () {
                          notifier.saveTheme(ThemeMode.system);
                        },
                      ),

                      const SizedBox(height: Sizes.md),
                      _buildToggleSound(ref, theme, data.isSoundOn, (value) {
                        notifier.saveIsSoundOn(value);
                      }),

                      const SizedBox(height: Sizes.xl),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildThemeOptionItem(
    ThemeData theme,
    BuildContext context, {
    required String text,
    bool isChosen = false,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: theme.textTheme.bodyLarge),
          Container(
            padding: const EdgeInsets.only(bottom: Sizes.xs),
            child: Icon(
              (isChosen) ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isChosen
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withAlpha(180),
              size: Sizes.iconMd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSound(
    WidgetRef ref,
    ThemeData theme,
    bool initialValue,
    Function(bool) onChanged,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Âm thanh",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            HocadoSwitch(initialValue: initialValue, onChanged: onChanged),
          ],
        ),
        SizedBox(height: Sizes.xs),
      ],
    );
  }
}
