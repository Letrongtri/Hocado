// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/deck.dart';

class DeckState {
  final List<Deck>? myDecks;
  final List<Deck>? savedDecks;
  final int currentTabIndex;

  DeckState({
    this.myDecks = const [],
    this.savedDecks = const [],
    this.currentTabIndex = 0,
  });

  DeckState copyWith({
    List<Deck>? myDecks,
    List<Deck>? savedDecks,
    int? currentTabIndex,
  }) {
    return DeckState(
      myDecks: myDecks ?? this.myDecks,
      savedDecks: savedDecks ?? this.savedDecks,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }

  // Deck? get
}
