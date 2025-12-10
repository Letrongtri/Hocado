import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class NotificationService {
  final FirebaseFirestore _firestore;

  NotificationService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  // Tao thong bao cho nguoi dung
  Future<void> createNotification(Map<String, dynamic> data) async {
    final uid = data['uid'];
    final nid = data['nid'];
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(nid)
          .set(data);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Could not create notification to database");
    }
  }

  // Lay thong bao cua nguoi dung
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchNotifications(
    String uid, {
    int limit = 50,
  }) async {
    print(uid);
    try {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .limit(limit);
      final docSnapshot = await docRef.get();

      print(docSnapshot);

      return docSnapshot.docs.isEmpty ? [] : docSnapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch user notifications from database");
    }
  }

  Future<void> deleteNotification(String uid, String notificationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Could not delete notification from database");
    }
  }

  Future<void> deleteAllNotifications(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .get();

      final batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception("Could not delete all notifications from database");
    }
  }

  Future<void> markNotificationAsRead(String uid, String notificationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Could not mark notification as read from database");
    }
  }

  Future<void> markAllNotificationsAsRead(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .get();

      final batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception("Could not mark all notifications as read from database");
    }
  }

  Stream<int> getUnreadCountStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return 0;

      final data = snapshot.data();
      return (data?['unreadCount'] as int?) ?? 0;
    });
  }
}
