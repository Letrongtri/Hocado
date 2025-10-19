import 'package:hocado/data/models/flashcard.dart';

abstract class FlashcardRepository {
  Future<List<Flashcard>> getFlashcardsByDeckId(
    String deckId,
  );

  Future<void> createFlashcards(
    List<Flashcard> flashcardData,
    String deckId,
  );

  Future<void> updateFlashcards(
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
}
