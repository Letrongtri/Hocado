import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hocado/data/models/models.dart';

typedef SearchSavedDecksResult = ({
  List<Deck> decks,
  DocumentSnapshot? lastDocument,
});

abstract class SavedDeckRepository {
  Future<List<SavedDeck>> getSavedDecksByUserId(String id);

  Future<void> unsaveDeck(String userId, String deckId);

  Future<void> saveDeck(String userId, SavedDeck savedDeck);

  Future<SearchSavedDecksResult> searchSavedDecks({
    required String id,
    String? search,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  });

  Future<bool> isDeckSavedByUser({
    required String userId,
    required String deckId,
  });
}
