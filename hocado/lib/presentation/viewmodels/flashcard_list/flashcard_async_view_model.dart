import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/deck_provider.dart';
import 'package:hocado/app/provider/flashcard_provider.dart';
import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/models/flashcard.dart';
import 'package:hocado/data/repositories/deck/deck_repository.dart';
import 'package:hocado/data/repositories/flashcard/flashcard_repository.dart';

class FlashcardAsyncViewModel extends AsyncNotifier<void> {
  late final DeckRepository _deckRepository;
  late final FlashcardRepository _flashcardRepository;

  @override
  FutureOr<void> build() {
    _deckRepository = ref.read(deckRepositoryProvider);
    _flashcardRepository = ref.read(flashcardRepositoryProvider);
  }

  Future<void> saveDeckAndFlashcards(
    Deck deck,
    List<Flashcard> flashcards,
  ) async {
    try {
      state = const AsyncValue.loading();

      final totalCards = flashcards.length;

      // Save deck using the repository
      final updatedDeck = deck.copyWith(
        totalCards: totalCards,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _deckRepository.create(updatedDeck);

      // Save flashcards using the repository
      if (totalCards > 0) {
        await _flashcardRepository.createFlashcards(
          flashcards
              .map(
                (card) => card.copyWith(
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              )
              .toList(),
          deck.did,
        );
      }

      state = const AsyncValue.data(null); // thành công
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteDeckAndFlashcards(String did) async {
    try {
      state = const AsyncValue.loading();

      // Xoá flashcards trước
      await _flashcardRepository.deleteFlashcardsByDeckId(did);

      // Xoá deck
      await _deckRepository.delete(did);

      state = const AsyncValue.data(null); // thành công
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
