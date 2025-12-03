import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/widgets/hocado_dialog.dart';
import 'package:hocado/utils/format_date_time.dart';

class DeckListItem extends StatelessWidget {
  final String title;
  final DateTime lastUpdated;
  final String did;

  const DeckListItem({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.did,
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
        formatTimeAgo(lastUpdated),
        style: theme.textTheme.bodySmall,
      ),

      // actions
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (sheetContext) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.sm,
                  vertical: Sizes.md,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Sửa bộ thẻ'),
                      onTap: () {
                        sheetContext.pop();
                        context.pushNamed(
                          AppRoutes.editDeck.name,
                          pathParameters: {'did': did},
                        );
                      },
                    ),
                    SizedBox(height: Sizes.sm),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Xóa bộ thẻ'),
                      onTap: () async {
                        sheetContext.pop();
                        final confirm = await showConfirmDialog(
                          context,
                          "Xóa bộ thẻ",
                          "Bạn có chắc muốn xóa bộ thẻ này không",
                        );

                        if (confirm != null && confirm) {
                          // TODO: Xóa bộ thẻ
                        }
                      },
                    ),
                    SizedBox(height: Sizes.xl * 1.5),
                  ],
                ),
              );
            },
          );
        },
      ),

      onTap: () {
        context.pushNamed(
          AppRoutes.detailDeck.name,
          pathParameters: {'did': did},
        );
      },
    );
  }
}
