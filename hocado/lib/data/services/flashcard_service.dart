import 'package:cloud_firestore/cloud_firestore.dart';

class FlashcardService {
  final FirebaseFirestore _firestore;
  final String collectionPath = 'flashcards';

  FlashcardService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  // Save flashcards
  Future<void> createFlashcards(
    List<Map<String, dynamic>> flashcardData,
    String did,
  ) async {
    try {
      final batch = _firestore.batch();
      final collectionRef = _firestore
          .collection('decks')
          .doc(did)
          .collection(collectionPath);

      for (var card in flashcardData) {
        final docRef = collectionRef.doc(card['fid']);
        batch.set(docRef, card);
      }
      await batch.commit();
    } catch (e) {
      throw Exception("Could not save flashcard to database");
    }
  }

  // Update flashcards
  Future<void> updateFlashcards(
    List<Map<String, dynamic>> flashcardData,
    String did,
  ) async {
    try {
      final batch = _firestore.batch();
      final collectionRef = _firestore
          .collection('decks')
          .doc(did)
          .collection(collectionPath);

      for (var card in flashcardData) {
        final docRef = collectionRef.doc(card['fid']);
        batch.update(docRef, card);
      }
      await batch.commit();
    } catch (e) {
      throw Exception("Could not update flashcard in database");
    }
  }

  // Delete flashcards by their IDs
  Future<void> deleteFlashcards(
    List<String> flashcardIds,
    String did,
  ) async {
    try {
      final batch = _firestore.batch();
      final collectionRef = _firestore
          .collection('decks')
          .doc(did)
          .collection(collectionPath);

      for (var fid in flashcardIds) {
        final docRef = collectionRef.doc(fid);
        batch.delete(docRef);
      }
      await batch.commit();
    } catch (e) {
      throw Exception("Could not delete flashcard from database");
    }
  }

  // Delete all flashcards by deck ID
  Future<void> deleteFlashcardsByDeckId(
    String did,
  ) async {
    try {
      final collectionRef = _firestore
          .collection('decks')
          .doc(did)
          .collection(collectionPath);

      final snapshot = await collectionRef.get();
      final batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception("Could not delete flashcards by deck id from database");
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getFlashcardsByDeckId(String deckId) async {
    try {
      final collectionRef = _firestore
          .collection('decks')
          .doc(deckId)
          .collection(collectionPath);

      final snapshot = await collectionRef.get();
      return snapshot.docs;
    } catch (e) {
      throw Exception("Could not retrieve flashcards from database");
    }
  }
}
