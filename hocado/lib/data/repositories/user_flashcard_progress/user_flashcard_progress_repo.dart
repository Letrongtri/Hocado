import 'package:hocado/data/models/user_flashcard_progress.dart';
import 'package:hocado/data/services/user_flashcard_progress_service.dart';

class UserFlashcardProgressRepo {
  final UserFlashcardProgressService _userFlashcardProgressService;

  UserFlashcardProgressRepo({
    required UserFlashcardProgressService userFlashcardProgressService,
  }) : _userFlashcardProgressService = userFlashcardProgressService;

  Future<List<UserFlashcardProgress>> getProgressForDeck(
    String uid,
    String did,
  ) async {
    try {
      final docs = await _userFlashcardProgressService.getFlashcardProgress(
        uid,
        did,
      );

      if (docs.isEmpty) {
        return [];
      }

      return docs
          .map((doc) => UserFlashcardProgress.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception("Could not convert documents to flashcard progress");
    }
  }

  Future<void> updateProgresses(
    String uid,
    List<UserFlashcardProgress> progresses,
  ) async {
    try {
      return _userFlashcardProgressService.updateFlashCardProgress(
        uid,
        progresses.map((p) => p.toMap()).toList(),
      );
    } catch (e) {
      throw Exception("Could not create deck");
    }
  }
}
