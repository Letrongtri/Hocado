import 'package:cloud_firestore/cloud_firestore.dart';

class UserFlashcardProgressService {
  final FirebaseFirestore _firestore;

  UserFlashcardProgressService(this._firestore);

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getFlashcardProgress(
    String uid,
    String did,
  ) async {
    final snap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('flashcard_progress')
        .where('did', isEqualTo: did)
        .get();

    return snap.docs.isEmpty ? [] : snap.docs;
  }

  Future<void> updateFlashCardProgress(
    String uid,
    List<Map<String, dynamic>> data,
  ) async {
    try {
      final batch = _firestore.batch();
      final collectionRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('flashcard_progress');

      for (var item in data) {
        final docRef = collectionRef.doc(item['fid']);
        batch.set(docRef, item);
      }
      await batch.commit();
    } catch (e) {
      throw Exception("Could not save progress to database");
    }
  }
}
