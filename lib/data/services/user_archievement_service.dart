import 'package:cloud_firestore/cloud_firestore.dart';

class UserArchievementService {
  final FirebaseFirestore _firestore;

  UserArchievementService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> _getUserArchievementRef(
    String uid,
  ) {
    return _firestore.collection('users').doc(uid).collection('archievements');
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserArchievement(
    String uid,
  ) async {
    try {
      final snapshot = await _getUserArchievementRef(
        uid,
      ).orderBy('unlockedAt', descending: true).get();
      return snapshot.docs.isEmpty ? [] : snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch archievements from database");
    }
  }
}
