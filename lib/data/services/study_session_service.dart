import 'package:cloud_firestore/cloud_firestore.dart';

class StudySessionService {
  final FirebaseFirestore _firestore;

  StudySessionService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid, String sid) =>
      _firestore
          .collection('users')
          .doc(uid)
          .collection('study_sessions')
          .doc(sid);

  Future<void> updateSession(Map<String, dynamic> session) async {
    try {
      // Tạo mới deck
      if (session['did'] == null || session['did'].isEmpty) {
        throw Exception("Deck ID (did) is required");
      }
      if (session['sid'] == null || session['sid'].isEmpty) {
        throw Exception("Session ID (sid) is required");
      }
      if (session['uid'] == null || session['uid'].isEmpty) {
        throw Exception("User ID (uid) is required");
      }

      await _doc(session['uid'], session['sid']).set(session);
    } catch (e) {
      throw Exception("Could not save study session to database");
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getStudySessionsByUserId(
    String uid,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('study_sessions')
          .orderBy('start', descending: true)
          .get();
      return snapshot.docs.isEmpty ? [] : snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch sessions from database");
    }
  }
}
