import 'package:cloud_firestore/cloud_firestore.dart';

class SavedDeckService {
  final FirebaseFirestore _firestore;

  SavedDeckService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> _getSavedDeckRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('saved_decks');
  }

  Future<void> saveDeck(String userId, Map<String, dynamic> deckData) async {
    try {
      await _getSavedDeckRef(userId).doc(deckData['did']).set(deckData);
    } catch (e) {
      throw Exception("Could not save deck to database");
    }
  }

  Future<void> unsaveDeck(String userId, String deckId) async {
    try {
      await _getSavedDeckRef(userId).doc(deckId).delete();
    } catch (e) {
      throw Exception("Could not unsave deck from database");
    }
  }

  // Lấy tất cả deck đã save của 1 user, sắp xếp theo ngày save
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserSavedDecks(
    String userId,
  ) async {
    try {
      final snapshot = await _getSavedDeckRef(
        userId,
      ).orderBy('savedAt', descending: true).get();
      return snapshot.docs.isEmpty ? [] : snapshot.docs;
    } catch (e) {
      throw Exception("Could not fetch saved decks from database");
    }
  }

  Future<
    ({
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      DocumentSnapshot? lastDocument,
    })
  >
  searchDecks(
    String userId,
    String? search,
    DocumentSnapshot? lastDocument, {
    int limit = 10,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _getSavedDeckRef(userId).limit(limit);

      if (search != null && search.isNotEmpty) {
        query = query.orderBy('searchIndex').startAt([search]).endAt([
          '$search\uf8ff',
        ]);
      } else {
        // Nếu không có search, sắp xếp theo 'savedAt'
        query = query.orderBy('savedAt', descending: true);
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        return (
          docs: <QueryDocumentSnapshot<Map<String, dynamic>>>[],
          lastDocument: null,
        );
      }

      // lastDocument sẽ là document cuối cùng của lần truy vấn này
      final newLastDocument = snapshot.docs.last;

      // Trả về danh sách docs và lastDocument
      return (docs: snapshot.docs, lastDocument: newLastDocument);
    } catch (e) {
      print("Error fetching public decks: $e");
      throw Exception("Could not fetch decks from database");
    }
  }

  Future<bool> isDeckSavedByUser({
    required String userId,
    required String deckId,
  }) async {
    try {
      final doc = await _getSavedDeckRef(userId).doc(deckId).get();

      return doc.exists;
    } catch (e) {
      print("Error checking if deck is saved: $e");
      throw Exception("Could not check if deck is saved");
    }
  }
}
