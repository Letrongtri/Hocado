// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/deck.dart';

class DeckState {
  final List<Deck>? myDecks;
  final List<Deck>? savedDecks;

  DeckState({required this.myDecks, required this.savedDecks});

  DeckState copyWith({
    List<Deck>? myDecks,
    List<Deck>? savedDecks,
  }) {
    return DeckState(
      myDecks: myDecks ?? this.myDecks,
      savedDecks: savedDecks ?? this.savedDecks,
    );
  }
}
