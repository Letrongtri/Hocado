import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/models/flashcard.dart';

class CreateDeckState {
  final Deck deck;
  final List<Flashcard>? flashcards;

  CreateDeckState({
    required this.deck,
    required this.flashcards,
  });

  CreateDeckState copyWith({
    Deck? deck,
    List<Flashcard>? flashcards,
  }) {
    return CreateDeckState(
      deck: deck ?? this.deck,
      flashcards: flashcards ?? this.flashcards,
    );
  }

  factory CreateDeckState.empty() {
    return CreateDeckState(deck: Deck.empty(), flashcards: []);
  }
}
