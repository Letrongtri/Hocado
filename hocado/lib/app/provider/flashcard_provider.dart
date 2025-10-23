import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/firebase_provider.dart';
import 'package:hocado/data/repositories/flashcard/flashcard_repository.dart';
import 'package:hocado/data/repositories/flashcard/flashcard_repository_impl.dart';
import 'package:hocado/data/services/flashcard_service.dart';
import 'package:hocado/presentation/viewmodels/flashcards/edit_flashcards_view_model.dart';
import 'package:hocado/presentation/viewmodels/flashcards/flashcards_state.dart';
import 'package:hocado/presentation/viewmodels/flashcards/flashcards_view_model.dart';

// Service provider
final flashcardServiceProvider = Provider<FlashcardService>(
  (ref) {
    final firestore = ref.read(firestoreProvider);
    return FlashcardService(firestore: firestore);
  },
);

// Repository provider
final flashcardRepositoryProvider = Provider<FlashcardRepository>(
  (ref) {
    final flashcardService = ref.read(flashcardServiceProvider);
    return FlashcardRepositoryImpl(flashcardService: flashcardService);
  },
);

// ViewModel provider
final flashcardsViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<FlashcardsViewModel, FlashcardsState, String>(
      FlashcardsViewModel.new,
    );

final editFlashcardsViewModelProvider = NotifierProvider.autoDispose
    .family<EditFlashcardsViewModel, FlashcardsState, String>(
      EditFlashcardsViewModel.new,
    );
