import 'package:cloud_firestore/cloud_firestore.dart';

class LearningActivityService {
  final FirebaseFirestore _firestore;

  LearningActivityService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getUserLearningActivities(
    String uid,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('learning_activities')
          .where(uid)
          .get();
      return snapshot.docs.isEmpty ? [] : snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch user learning activities from database");
    }
  }

  Future<void> createAndUpdateLearningActivity(
    Map<String, dynamic> data,
  ) async {
    try {
      if (data['laid'] == null || data['laid'].isEmpty) {
        throw Exception("Learning Activity ID (laid) is required");
      }

      final docRef = _firestore
          .collection('learning_activities')
          .doc(data['laid']);
      await docRef.set(data);
    } catch (e) {
      throw Exception("Could not save learning activity to database");
    }
  }
}
