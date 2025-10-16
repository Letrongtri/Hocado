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
          .orderBy('updatedAt', descending: true)
          .get();
      return snapshot.docs;
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
}
