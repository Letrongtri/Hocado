// view model
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/firebase_provider.dart';
import 'package:hocado/data/repositories/flashcard/flashcard_repository.dart';
import 'package:hocado/data/repositories/flashcard/flashcard_repository_impl.dart';
import 'package:hocado/data/services/flashcard_service.dart';
import 'package:hocado/presentation/viewmodels/flashcard_list/flashcard_async_view_model.dart';
import 'package:hocado/presentation/viewmodels/flashcard_list/flashcard_list_state.dart';
import 'package:hocado/presentation/viewmodels/flashcard_list/flashcard_view_model.dart';

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
final flashcardViewModelProvider =
    NotifierProvider<FlashcardViewModel, FlashcardListState>(
      FlashcardViewModel.new,
    );

final flashcardAsyncViewModelProvider =
    AsyncNotifierProvider<FlashcardAsyncViewModel, void>(
      FlashcardAsyncViewModel.new,
    );
