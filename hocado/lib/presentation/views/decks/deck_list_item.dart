import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/utils/format_date_time.dart';

class DeckListItem extends StatelessWidget {
  final String title;
  final DateTime lastUpdated;

  const DeckListItem({
    super.key,
    required this.title,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      tileColor: theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(Sizes.borderRadiusLg),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      // icon
      leading: Container(
        padding: const EdgeInsets.all(Sizes.iconXs),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        ),
        child: Icon(Icons.description_rounded, color: Colors.grey.shade600),
      ),

      title: Text(title, style: theme.textTheme.titleMedium),
      subtitle: Text(
        formatDateTime(lastUpdated),
        style: theme.textTheme.bodySmall,
      ),

      // actions
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () {},
      ),
    );
  }
}
