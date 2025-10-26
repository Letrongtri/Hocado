import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/firebase_provider.dart';
import 'package:hocado/data/repositories/user_flashcard_progress/user_flashcard_progress_repo.dart';
import 'package:hocado/data/services/user_flashcard_progress_service.dart';

final userFlashcardProgressServicesProvider =
    Provider<UserFlashcardProgressService>((ref) {
      final firestore = ref.read(firestoreProvider);
      return UserFlashcardProgressService(firestore);
    });

final userFlashcardProgressRepoProvider = Provider<UserFlashcardProgressRepo>((
  ref,
) {
  final service = ref.read(userFlashcardProgressServicesProvider);
  return UserFlashcardProgressRepo(userFlashcardProgressService: service);
});
