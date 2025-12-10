import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore;

  UserService({required FirebaseFirestore firestore}) : _firestore = firestore;

  Future<void> updateUser(Map<String, dynamic> userData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userData['uid'])
          .update(userData);
    } catch (e) {
      throw Exception("Could not update user to database");
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      throw Exception("Could not delete user from database");
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(
    String uid,
  ) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (!docSnapshot.exists) {
        throw Exception("User not found");
      }
      return docSnapshot;
    } catch (e) {
      throw Exception("Could not fetch user from database");
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String uid) {
    try {
      return _firestore.collection('users').doc(uid).snapshots();
    } catch (e) {
      throw Exception("Could not fetch user from database");
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserByIds(
    List<String> uids,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: uids)
          .get();

      return snapshot.docs.isEmpty ? [] : snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch users from database");
    }
  }

  Future<void> updateUserNextStudyTime(
    String uid,
    DateTime nextStudyTime,
  ) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'nextStudyTime': nextStudyTime,
      });
    } catch (e) {
      throw Exception("Could not update user next study time to database");
    }
  }

  // Lưu FCM token cho người dùng
  Future<void> saveFCMToken(String uid, String token) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'fcmToken': token,
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Could not save FCM token to database");
    }
  }

  Future<void> deleteFCMToken(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({'fcmToken': ''});
    } catch (e) {
      throw Exception("Could not delete FCM token from database");
    }
  }
}
