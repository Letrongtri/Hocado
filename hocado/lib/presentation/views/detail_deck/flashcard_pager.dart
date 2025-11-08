import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/views/detail_deck/flashcard_flip_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FlashcardPager extends ConsumerStatefulWidget {
  final List<Flashcard> flashcards;
  const FlashcardPager({super.key, required this.flashcards});

  @override
  ConsumerState<FlashcardPager> createState() => _FlashcardPagerState();
}

class _FlashcardPagerState extends ConsumerState<FlashcardPager> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.flashcards.length,
            itemBuilder: (context, index) {
              final card = widget.flashcards[index];

              return FlashcardFlipItem(card: card, index: index);
            },
          ),
        ),

        const SizedBox(height: Sizes.md),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: widget.flashcards.length,
            effect: WormEffect(
              dotHeight: 12,
              dotWidth: 12,
              activeDotColor: theme.colorScheme.primary,
              dotColor: theme.colorScheme.onSurface.withAlpha(100),
            ),
          ),
        ),
      ],
    );
  }
}
