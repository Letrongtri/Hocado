import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteSettingsService {
  final FirebaseFirestore _firestore;

  RemoteSettingsService(this._firestore);

  DocumentReference<Map<String, dynamic>> _doc(String uid, String did) =>
      _firestore
          .collection('users')
          .doc(uid)
          .collection('deck_settings')
          .doc(did);

  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchDeckSettings(
    String uid,
    String did,
  ) async {
    final snap = await _doc(uid, did).get();
    if (!snap.exists) return null;
    return snap;
  }

  Future<void> upsertDeckSettings(
    String uid,
    String did,
    Map<String, dynamic> s,
  ) async {
    await _doc(uid, did).set(s, SetOptions(merge: true));
  }
}
