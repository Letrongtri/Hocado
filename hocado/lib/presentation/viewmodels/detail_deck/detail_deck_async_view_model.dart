import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/deck_provider.dart';
import 'package:hocado/app/provider/flashcard_provider.dart';
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
  Future<DetailDeckState> build() async {
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
