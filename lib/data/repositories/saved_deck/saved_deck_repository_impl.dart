import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

class SavedDeckRepositoryImpl implements SavedDeckRepository {
  final SavedDeckService _savedDeckService;

  SavedDeckRepositoryImpl({required SavedDeckService savedDeckService})
    : _savedDeckService = savedDeckService;

  @override
  Future<void> saveDeck(String userId, SavedDeck savedDeck) {
    try {
      return _savedDeckService.saveDeck(userId, savedDeck.toMap());
    } catch (e) {
      throw Exception("Could not save deck");
    }
  }

  @override
  Future<void> unsaveDeck(String userId, String deckId) async {
    try {
      return _savedDeckService.unsaveDeck(userId, deckId);
    } catch (e) {
      throw Exception("Could not unsave deck");
    }
  }

  @override
  Future<List<SavedDeck>> getSavedDecksByUserId(String id) async {
    try {
      final docs = await _savedDeckService.getUserSavedDecks(id);

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => SavedDeck.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not convert documents to decks");
    }
  }

  @override
  Future<SearchSavedDecksResult> searchSavedDecks({
    required String id,
    String? search,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) async {
    try {
      final result = await _savedDeckService.searchDecks(
        id,
        search,
        lastDocument,
        limit: limit,
      );

      final docs = result.docs;
      final newLastDocument = result.lastDocument;

      if (docs.isEmpty) {
        return (decks: <Deck>[], lastDocument: null);
      }

      final decks = docs.map((doc) => Deck.fromFirestore(doc)).toList();

      return (decks: decks, lastDocument: newLastDocument);
    } catch (e) {
      throw Exception("Could not convert documents to decks");
    }
  }

  @override
  Future<bool> isDeckSavedByUser({
    required String userId,
    required String deckId,
  }) async {
    try {
      return await _savedDeckService.isDeckSavedByUser(
        userId: userId,
        deckId: deckId,
      );
    } catch (e) {
      throw Exception("Could not check if deck is saved");
    }
  }
}
