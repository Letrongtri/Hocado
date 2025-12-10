import 'package:cloud_firestore/cloud_firestore.dart';

class FollowService {
  final FirebaseFirestore _firestore;

  FollowService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  Future<void> followUser(
    String uid,
    Map<String, dynamic> followingData,
  ) async {
    final followingUid = followingData['uid'];

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('following')
          .doc(followingUid)
          .set(followingData);
    } catch (e) {
      throw Exception("Could not follow user to database");
    }
  }

  Future<void> unfollowUser(String uid, String followingUid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('following')
          .doc(followingUid)
          .delete();
    } catch (e) {
      throw Exception("Could not unfollow user to database");
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserFollowing(
    String uid,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('following')
          .get();

      return snapshot.docs.isEmpty ? [] : snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch user following from database");
    }
  }
}
