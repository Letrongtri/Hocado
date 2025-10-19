// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/models/flashcard.dart';

class FlashcardListState {
  final Deck? deck;
  final List<Flashcard>? cardList;

  FlashcardListState({required this.deck, required this.cardList});

  FlashcardListState copyWith({
    Deck? deck,
    List<Flashcard>? cardList,
  }) {
    return FlashcardListState(
      deck: deck ?? this.deck,
      cardList: cardList ?? this.cardList,
    );
  }
}
