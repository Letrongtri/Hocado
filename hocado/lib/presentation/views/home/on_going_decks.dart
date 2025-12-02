import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/presentation/widgets/deck_card.dart';

class OnGoingDecks extends ConsumerWidget {
  const OnGoingDecks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final state = ref.watch(homeViewModelProvider);

    return Column(
      children: [
        _buildOnGoingDeckHeader(theme, context),
        const SizedBox(height: Sizes.md),

        // Section 5: Decks Grid
        state.when(
          data: (data) {
            final ongoingDecks = data.onGoingDecks ?? [];

            return GridView.builder(
              itemCount: ongoingDecks.length,
              physics:
                  const NeverScrollableScrollPhysics(), // Để scroll view cha xử lý
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9, // Tỉ lệ chiều rộng/chiều cao của card
              ),
              itemBuilder: (context, index) {
                final entry = ongoingDecks[index];
                final deck = entry.keys.first;
                final owner = data.users?.firstWhere(
                  (user) => user.uid == entry.values.first,
                );
                return DeckCard(
                  did: deck.did,
                  title: deck.name,
                  description: deck.description,
                  owner: owner,
                );
              },
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Row _buildOnGoingDeckHeader(ThemeData theme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Ongoing decks', style: theme.textTheme.headlineSmall),
        TextButton(
          onPressed: () {
            if (context.mounted) context.pushNamed(AppRoutes.decks.name);
          },
          child: Text(
            'View all',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(70),
            ),
          ),
        ),
      ],
    );
  }
}
