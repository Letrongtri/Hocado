import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

// My decks
final deckServiceProvider = Provider<DeckService>((ref) {
  final firestore = ref.read(firestoreProvider);
  return DeckService(firestore: firestore);
});

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  final deckService = ref.read(deckServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return DeckRepositoryImpl(
    decksService: deckService,
    storageService: storageService,
  );
});

// Saved decks
final savedDeckServiceProvider = Provider<SavedDeckService>((ref) {
  final firestore = ref.read(firestoreProvider);
  return SavedDeckService(firestore: firestore);
});

final savedDeckRepositoryProvider = Provider<SavedDeckRepository>((ref) {
  final deckService = ref.read(savedDeckServiceProvider);
  return SavedDeckRepositoryImpl(savedDeckService: deckService);
});

// View model
final decksViewModelProvider = AsyncNotifierProvider<DecksViewModel, DeckState>(
  DecksViewModel.new,
);
