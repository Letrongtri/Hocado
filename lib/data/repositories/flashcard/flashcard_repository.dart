import 'package:hocado/data/models/models.dart';
import 'package:image_picker/image_picker.dart';

abstract class FlashcardRepository {
  Future<List<Flashcard>> getFlashcardsByDeckId(String deckId);

  Future<void> createAndUpdateFlashcards(
    List<Flashcard> flashcardData,
    String deckId,
    Map<String, XFile>? pickedFronts,
    Map<String, XFile>? pickedBacks,
  );

  Future<void> deleteFlashcards(
    List<String> flashcardIds,
    List<String>? imageUrls,
    String deckId,
  );

  Future<void> deleteFlashcardsByDeckId(String deckId, List<String>? imageUrls);

  Future<List<Flashcard>> generateFlashcardsFromText(String text);
}
