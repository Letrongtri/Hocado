import 'package:hocado/data/models/models.dart';

enum DeckOwnershipStatus {
  myDeck,
  savedDeck,
  unsaveDeck,
}

class DetailDeckState {
  final Deck deck;
  final List<Flashcard>? cardList;
  final DeckOwnershipStatus ownershipStatus;

  DetailDeckState({
    required this.deck,
    required this.cardList,
    this.ownershipStatus = DeckOwnershipStatus.unsaveDeck,
  });

  DetailDeckState copyWith({
    Deck? deck,
    List<Flashcard>? cardList,
    DeckOwnershipStatus? ownershipStatus,
  }) {
    return DetailDeckState(
      deck: deck ?? this.deck,
      cardList: cardList ?? this.cardList,
      ownershipStatus: ownershipStatus ?? this.ownershipStatus,
    );
  }
}
