import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/repositories/deck/deck_repository.dart';
import 'package:hocado/data/services/deck_service.dart';

class DeckRepositoryImpl implements DeckRepository {
  final DeckService _deckService;

  DeckRepositoryImpl({required DeckService decksService})
    : _deckService = decksService;

  @override
  Future<void> delete(String id) async {
    try {
      await _deckService.deleteDeck(id);
    } catch (e) {
      throw Exception("Could not delete deck");
    }
  }

  @override
  Future<List<Deck>> getDecksByUserId(String id) async {
    try {
      final docs = await _deckService.getUserDecks(id);

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => Deck.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not convert documents to decks");
    }
  }

  @override
  Future<void> createAndUpdate(Deck deck) {
    try {
      return _deckService.createAndUpdateDeck(deck.toMap());
    } catch (e) {
      throw Exception("Could not create deck");
    }
  }

  @override
  Future<Deck> getDeckById(String id) async {
    try {
      return await _deckService.getDeckById(id).then((docSnapshot) {
        return Deck.fromFirestore(docSnapshot);
      });
    } catch (e) {
      throw Exception("Could not get deck by id");
    }
  }

  @override
  Future<SearchDecksResult> searchDecks({
    required String id,
    bool isFindingPublic = true,
    String? search,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) async {
    try {
      final result = await _deckService.searchDecks(
        id,
        search,
        lastDocument,
        limit: limit,
        isFindingPublic: isFindingPublic,
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
}
