import 'package:hocado/data/models/deck.dart';
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
      return docs.map((doc) => Deck.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not convert documents to decks");
    }
  }
}
