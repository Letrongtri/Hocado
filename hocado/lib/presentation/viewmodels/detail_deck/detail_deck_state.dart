import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/models/flashcard.dart';

class DetailDeckState {
  final Deck deck;
  final List<Flashcard>? cardList;

  DetailDeckState({required this.deck, required this.cardList});

  DetailDeckState copyWith({
    Deck? deck,
    List<Flashcard>? cardList,
  }) {
    return DetailDeckState(
      deck: deck ?? this.deck,
      cardList: cardList ?? this.cardList,
    );
  }
}
