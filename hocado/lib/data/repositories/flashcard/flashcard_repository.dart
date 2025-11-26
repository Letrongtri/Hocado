import 'package:hocado/data/models/models.dart';

abstract class FlashcardRepository {
  Future<List<Flashcard>> getFlashcardsByDeckId(
    String deckId,
  );

  Future<void> createAndUpdateFlashcards(
    List<Flashcard> flashcardData,
    String deckId,
  );

  Future<void> deleteFlashcards(
    List<String> flashcardIds,
    String deckId,
  );

  Future<void> deleteFlashcardsByDeckId(
    String deckId,
  );

  Future<List<Flashcard>> generateFlashcardsFromText(String text);
}
