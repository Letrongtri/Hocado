import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/user.dart';

class DeckCard extends StatelessWidget {
  const DeckCard({
    super.key,
    required this.did,
    required this.title,
    required this.description,
    this.owner,
  });

  final String did;
  final String title;
  final String description;
  final User? owner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.detailDeck.name,
          pathParameters: {'did': did},
        );
      },
      child: Card(
        color: theme.colorScheme.secondary,
        elevation: 0.2,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // icon
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    child: Icon(
                      Icons.description_outlined,
                      color: theme.colorScheme.onPrimary,
                      size: Sizes.iconMd,
                    ),
                  ),

                  const SizedBox(width: Sizes.xs),

                  if (owner != null)
                    Expanded(
                      child: TextButton(
                        child: Text(
                          owner?.fullName ?? '',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                        onPressed: () {
                          if (context.mounted) {
                            context.pushNamed(
                              AppRoutes.profile.name,
                              pathParameters: {'uid': owner!.uid},
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: Sizes.sm),

              // Heading
              Text(
                title,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Sizes.xs),

              // Description
              Text(
                description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
