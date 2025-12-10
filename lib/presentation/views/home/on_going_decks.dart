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

    return state.when(
      data: (data) {
        final ongoingDecks = data.onGoingDecks;

        if (ongoingDecks.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            _buildOnGoingDeckHeader(theme, context),
            const SizedBox(height: Sizes.md),

            SizedBox(
              height: 220,
              child: ListView.separated(
                itemCount: ongoingDecks.length,
                scrollDirection: Axis.horizontal,
                controller: PageController(viewportFraction: 0.8),
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: Sizes.md),
                itemBuilder: (context, index) {
                  final homeDeckItem = ongoingDecks[index];
                  final deck = homeDeckItem.deck;
                  final owner = homeDeckItem.author;
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: DeckCard(
                      did: deck.did,
                      title: deck.name,
                      description: deck.description,
                      owner: owner,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Row _buildOnGoingDeckHeader(ThemeData theme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Tiếp tục học', style: theme.textTheme.headlineSmall),
        TextButton(
          onPressed: () {
            if (context.mounted) context.pushNamed(AppRoutes.decks.name);
          },
          child: Text(
            'Tất cả',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(70),
            ),
          ),
        ),
      ],
    );
  }
}
