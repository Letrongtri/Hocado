import 'package:cloud_firestore/cloud_firestore.dart';

class SavedDeckService {
  final FirebaseFirestore _firestore;

  SavedDeckService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  // Lấy tất cả deck đã save của 1 user, sắp xếp theo ngày save
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserSavedDecks(
    String userId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_decks')
          .orderBy('savedAt', descending: true)
          .get();
      return snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch saved decks from database");
    }
  }
}
