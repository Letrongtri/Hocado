import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/detail_deck_provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/flashcard.dart';

class FlashcardFlipItem extends ConsumerStatefulWidget {
  final Flashcard card;
  final int index;
  const FlashcardFlipItem({super.key, required this.card, required this.index});

  @override
  ConsumerState<FlashcardFlipItem> createState() => _FlashcardFlipItemState();
}

class _FlashcardFlipItemState extends ConsumerState<FlashcardFlipItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ref.read(flipStateProvider(widget.index).notifier).state = true;
      } else if (status == AnimationStatus.dismissed) {
        ref.read(flipStateProvider(widget.index).notifier).state = false;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_animationController.isAnimating) return;

    final isFlipped = ref.read(flipStateProvider(widget.index));
    if (isFlipped) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // sync controller initial state with provider state
    final isFlipped = ref.read(flipStateProvider(widget.index));
    if (isFlipped && _animationController.status != AnimationStatus.completed) {
      _animationController.value = 1.0;
    } else if (!isFlipped &&
        _animationController.status != AnimationStatus.dismissed) {
      _animationController.value = 0.0;
    }

    return GestureDetector(
      onTap: _onTap,

      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = (_flipAnimation.value * pi).toDouble();
          final isFront = angle <= pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(angle),
            child: isFront
                ? _buildCard(theme, widget.card.front)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(pi),
                    child: _buildCard(theme, widget.card.back),
                  ),
          );
        },
      ),
    );
  }

  Card _buildCard(ThemeData theme, String content) {
    return Card(
      color: theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Sizes.borderRadiusLg,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  content,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.star_border_outlined),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.note_alt_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
