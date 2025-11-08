import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';

abstract class SavedDeckRepository {
  Future<List<Deck>> getSavedDecksByUserId(String id);

  Future<void> delete(String id);

  Future<SearchDecksResult> searchDecks({
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
