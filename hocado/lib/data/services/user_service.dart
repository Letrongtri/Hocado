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

  Future<void> incrementCount(String uid, String field, {int count = 1}) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        field: FieldValue.increment(count),
      });
    } catch (e) {
      throw Exception("Could not increase count of user to database");
    }
  }

  Future<void> decrementCount(String uid, String field, {int count = 1}) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        field: FieldValue.increment(-count),
      });
    } catch (e) {
      throw Exception("Could not decrease count of user to database");
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String uid) {
    try {
      return _firestore.collection('users').doc(uid).snapshots();
    } catch (e) {
      throw Exception("Could not fetch user from database");
    }
  }
}
