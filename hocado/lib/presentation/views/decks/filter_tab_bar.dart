import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/deck_provider.dart';

class FilterTabBar extends ConsumerWidget {
  const FilterTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(decksViewModelProvider);

    final selectedIndex = state.value?.currentTabIndex ?? 0;

    final tabs = ['Của tôi', 'Đã lưu'];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return ChoiceChip(
            label: Text(tabs[index]),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                ref.read(decksViewModelProvider.notifier).changeTab(index);
              }
            },
            backgroundColor: theme.colorScheme.surface,
            selectedColor: theme.colorScheme.onSurface,
            labelStyle: TextStyle(
              color: isSelected
                  ? theme.colorScheme.surface
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            shape: StadiumBorder(
              side: BorderSide(color: Colors.grey.shade300),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}
