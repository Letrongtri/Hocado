import 'package:cloud_firestore/cloud_firestore.dart';

class DailyLearningStatService {
  final FirebaseFirestore _firestore;

  DailyLearningStatService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getUserDailyLearningStat(
    String uid,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('daily_learning_stats')
          .where(uid)
          .get();
      return snapshot.docs.isEmpty ? [] : snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch user daily learning stat from database");
    }
  }

  // Future<void> createAndUpdateDailyLearningStat(
  //   Map<String, dynamic> data,
  // ) async {
  //   try {
  //     // Tạo mới deck
  //     if (data['dlid'] == null || data['dlid'].isEmpty) {
  //       throw Exception("Daily learning stat ID (dlid) is required");
  //     }

  //     final docRef = _firestore
  //         .collection('daily_learning_stats')
  //         .doc(data['dlid']);
  //     await docRef.set(data);
  //   } catch (e) {
  //     throw Exception("Could not save daily learning stat to database");
  //   }
  // }
}
