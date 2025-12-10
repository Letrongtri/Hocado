import 'package:cloud_firestore/cloud_firestore.dart';

class UserDeckProgressService {
  final FirebaseFirestore _firestore;

  UserDeckProgressService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserDeckProgress(
    String uid,
    String did,
  ) async {
    try {
      final snapshot = await _firestore.collection('deck_progress').where({
        'uid': uid,
        'did': did,
      }).get();
      return snapshot.docs.isEmpty ? [] : snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch user deck progress from database");
    }
  }

  Future<void> createAndUpdateUserDeckProgress(
    Map<String, dynamic> data,
  ) async {
    try {
      if (data['udid'] == null || data['udid'].isEmpty) {
        throw Exception("User Deck Progress ID (udid) is required");
      }

      final docRef = _firestore.collection('deck_progress').doc(data['udid']);
      await docRef.set(data);
    } catch (e) {
      throw Exception("Could not save user deck progress to database");
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getRecentProgress(
    String uid, {
    int limit = 10,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('deck_progress')
          .where('uid', isEqualTo: uid)
          .orderBy('lastStudied', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs.isEmpty ? [] : snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch user deck progress from database");
    }
  }
}
