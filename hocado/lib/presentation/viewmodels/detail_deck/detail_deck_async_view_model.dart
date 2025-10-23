import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/deck_provider.dart';
import 'package:hocado/app/provider/flashcard_provider.dart';
import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/repositories/deck/deck_repository.dart';
import 'package:hocado/data/repositories/flashcard/flashcard_repository.dart';
import 'package:hocado/presentation/viewmodels/detail_deck/detail_deck_state.dart';

class DetailDeckAsyncViewModel extends AsyncNotifier<DetailDeckState> {
  final String did;

  DetailDeckAsyncViewModel(this.did);

  DeckRepository get _deckRepository => ref.read(deckRepositoryProvider);
  FlashcardRepository get _flashcardRepository =>
      ref.read(flashcardRepositoryProvider);

  @override
  FutureOr<DetailDeckState> build() async {
    Future.microtask(() {
      // Nghe DecksViewModel, nếu deck thay đổi thì reload lại deck detail
      ref.listen(decksViewModelProvider, (prev, next) async {
        if (next.hasValue) {
          final decks = next.value!;
          Deck? deckChanged;

          deckChanged = decks.myDecks?.firstWhereOrNull(
            (deck) => deck.did == did,
          );
          deckChanged ??= decks.savedDecks?.firstWhereOrNull(
            (deck) => deck.did == did,
          );

          if (deckChanged != null && state.hasValue) {
            state = AsyncData(
              state.value!.copyWith(deck: deckChanged),
            );
          }
        }
      });

      // Nghe FlashcardsViewModel(did)
      ref.listen(flashcardsViewModelProvider(did), (prev, next) {
        if (next.hasValue && state.hasValue) {
          state = AsyncData(
            state.value!.copyWith(cardList: next.value!.flashcards),
          );
        }
      });
    });

    final deck = await _deckRepository.getDeckById(did);
    final flashcards = await _flashcardRepository.getFlashcardsByDeckId(did);

    return DetailDeckState(
      deck: deck,
      cardList: flashcards,
    );
  }

  Future<void> refreshDeckDetails() async {
    // loading state
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final deck = await _deckRepository.getDeckById(did);
      final flashcards = await _flashcardRepository.getFlashcardsByDeckId(did);
      return DetailDeckState(
        deck: deck,
        cardList: flashcards,
      );
    });
  }
}
