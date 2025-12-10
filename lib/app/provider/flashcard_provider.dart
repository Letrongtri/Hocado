import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

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
    final geminiService = ref.read(geminiServiceProvider);
    final storageService = ref.read(storageServiceProvider);
    return FlashcardRepositoryImpl(
      flashcardService: flashcardService,
      geminiService: geminiService,
      storageService: storageService,
    );
  },
);

// ViewModel provider
final flashcardsViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<FlashcardsViewModel, FlashcardsState, String>(
      FlashcardsViewModel.new,
    );
