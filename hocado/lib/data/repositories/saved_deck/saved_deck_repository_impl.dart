import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/repositories/deck/deck_repository.dart';
import 'package:hocado/data/repositories/saved_deck/saved_deck_repository.dart';
import 'package:hocado/data/services/saved_deck_service.dart';

class SavedDeckRepositoryImpl implements SavedDeckRepository {
  final SavedDeckService _savedDeckService;

  SavedDeckRepositoryImpl({required SavedDeckService savedDeckService})
    : _savedDeckService = savedDeckService;

  @override
  Future<void> delete(String id) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Deck>> getSavedDecksByUserId(String id) async {
    try {
      final docs = await _savedDeckService.getUserSavedDecks(id);

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => Deck.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not convert documents to decks");
    }
  }

  @override
  Future<SearchDecksResult> searchDecks({
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
      print("Error in DeckRepository: $e");
      throw Exception("Could not convert documents to decks");
    }
  }
}
