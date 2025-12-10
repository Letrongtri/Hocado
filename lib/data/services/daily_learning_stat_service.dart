import 'package:cloud_firestore/cloud_firestore.dart';

class DailyLearningStatService {
  final FirebaseFirestore _firestore;

  DailyLearningStatService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getUserDailyLearningStat(
    String uid, {
    int limit = 7,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('daily_learning_stats')
          .where('uid', isEqualTo: uid)
          .orderBy('date', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs.isEmpty ? [] : snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch user daily learning stat from database");
    }
  }
}
