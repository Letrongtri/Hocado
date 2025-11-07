import 'package:cloud_firestore/cloud_firestore.dart';

class SavedDeckService {
  final FirebaseFirestore _firestore;

  SavedDeckService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  // Lấy tất cả deck đã save của 1 user, sắp xếp theo ngày save
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserSavedDecks(
    String userId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_decks')
          // .orderBy('savedAt', descending: true)
          .get();
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
      Query<Map<String, dynamic>> query = _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_decks')
          .limit(limit);

      if (search != null && search.isNotEmpty) {
        query = query.orderBy('searchIndex').startAt([search]).endAt([
          '$search\uf8ff',
        ]);
      } else {
        // Nếu không có search, sắp xếp theo 'createdAt'
        query = query.orderBy('createdAt', descending: true);
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
}
