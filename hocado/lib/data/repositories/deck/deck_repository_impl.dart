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
      return docs.map((doc) => Deck.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not convert documents to decks");
    }
  }

  @override
  Future<void> updateDeck(String id, Deck data) async {
    try {
      await _deckService.updateDeck(data.toMap());
    } catch (e) {
      throw Exception("Could not update deck");
    }
  }

  @override
  Future<void> create(Deck deck) {
    try {
      return _deckService.createDeck(deck.toMap());
    } catch (e) {
      throw Exception("Could not create deck");
    }
  }
}
