import 'package:cloud_firestore/cloud_firestore.dart';

class DeckService {
  final FirebaseFirestore _firestore;

  DeckService({required FirebaseFirestore firestore}) : _firestore = firestore;

  // Lấy tất cả deck của 1 user, sắp xếp theo ngày cập nhật
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserDecks(
    String userId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('decks')
          .where('uid', isEqualTo: userId)
          // .orderBy('updatedAt', descending: true)
          .get();
      return snapshot.docs.isEmpty ? [] : snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch decks from database");
    }
  }

  // Lấy decks bằng list of Ids
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDecksByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return [];

    try {
      final snapshot = await _firestore
          .collection('decks')
          .where(FieldPath.documentId, whereIn: ids)
          .get();

      return snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch decks from database");
    }
  }

  // Create decks
  Future<void> createDeck(Map<String, dynamic> deckData) async {
    try {
      // Tạo mới deck
      final docRef = _firestore.collection('decks').doc(deckData['did']);
      await docRef.set(deckData);
    } catch (e) {
      throw Exception("Could not save deck to database");
    }
  }

  // Delete deck
  Future<void> deleteDeck(String deckId) async {
    try {
      final docRef = _firestore.collection('decks').doc(deckId);
      await docRef.delete();
    } catch (e) {
      throw Exception("Could not delete deck from database");
    }
  }

  // Update deck
  Future<void> updateDeck(Map<String, dynamic> deckData) async {
    try {
      final docRef = _firestore.collection('decks').doc(deckData['did']);
      await docRef.update(deckData);
    } catch (e) {
      throw Exception("Could not update deck in database");
    }
  }

  // Get deck by Id
  Future<DocumentSnapshot<Map<String, dynamic>>> getDeckById(
    String id,
  ) async {
    try {
      final docRef = _firestore.collection('decks').doc(id);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception("Deck not found");
      }

      return docSnapshot;
    } catch (e) {
      throw Exception("Could not fetch deck from database");
    }
  }
}
