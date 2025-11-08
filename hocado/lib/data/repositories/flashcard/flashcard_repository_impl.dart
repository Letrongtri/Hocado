import 'package:hocado/data/models/flashcard.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardService _flashcardService;

  FlashcardRepositoryImpl({required FlashcardService flashcardService})
    : _flashcardService = flashcardService;

  @override
  Future<void> createAndUpdateFlashcards(
    List<Flashcard> flashcardData,
    String deckId,
  ) async {
    try {
      await _flashcardService.createAndUpdateFlashcards(
        flashcardData.map((card) => card.toMap()).toList(),
        deckId,
      );
    } catch (e) {
      print(e);
      throw Exception("Could not create flashcards");
    }
  }

  @override
  Future<void> deleteFlashcards(
    List<String> flashcardIds,
    String deckId,
  ) async {
    try {
      return await _flashcardService.deleteFlashcards(flashcardIds, deckId);
    } catch (e) {
      throw Exception("Could not delete flashcards");
    }
  }

  @override
  Future<List<Flashcard>> getFlashcardsByDeckId(String deckId) async {
    try {
      final docs = await _flashcardService.getFlashcardsByDeckId(deckId);

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => Flashcard.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not retrieve flashcards");
    }
  }

  @override
  Future<void> deleteFlashcardsByDeckId(String deckId) async {
    try {
      return await _flashcardService.deleteFlashcardsByDeckId(deckId);
    } catch (e) {
      throw Exception("Could not delete flashcards by deck id");
    }
  }
}
