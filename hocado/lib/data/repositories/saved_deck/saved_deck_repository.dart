import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/repositories/deck/deck_repository.dart';

abstract class SavedDeckRepository {
  Future<List<Deck>> getSavedDecksByUserId(String id);

  Future<void> delete(String id);

  Future<SearchDecksResult> searchDecks({
    required String id,
    String? search,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  });
}
