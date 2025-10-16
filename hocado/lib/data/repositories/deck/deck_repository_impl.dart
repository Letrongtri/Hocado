import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/repositories/deck/deck_repository.dart';
import 'package:hocado/data/services/deck_service.dart';

class DeckRepositoryImpl implements DeckRepository {
  final DeckService _deckService;

  DeckRepositoryImpl({required DeckService decksService})
    : _deckService = decksService;

  @override
  Future<void> delete(String id) async {
    // TODO: implement delete
    throw UnimplementedError();
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
  Future<void> updateDeck(String id, Map<String, dynamic> data) async {
    // TODO: implement updateDeck
    throw UnimplementedError();
  }
}
