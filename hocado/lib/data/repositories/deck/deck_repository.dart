import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hocado/data/models/deck.dart';

typedef SearchDecksResult = ({
  List<Deck> decks,
  DocumentSnapshot? lastDocument,
});

abstract class DeckRepository {
  Future<List<Deck>> getDecksByUserId(String id);

  Future<void> updateDeck(String id, Deck data);

  Future<void> delete(String id);

  Future<void> create(Deck deck);

  Future<Deck> getDeckById(String id);

  Future<SearchDecksResult> searchDecks({
    required String id,
    bool isFindingPublic,
    String? search,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  });
}
