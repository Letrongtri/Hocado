import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:hocado/app/provider/firebase_provider.dart';
import 'package:hocado/data/repositories/deck/deck_repository.dart';
import 'package:hocado/data/repositories/deck/deck_repository_impl.dart';
import 'package:hocado/data/repositories/saved_deck/saved_deck_repository.dart';
import 'package:hocado/data/repositories/saved_deck/saved_deck_repository_impl.dart';
import 'package:hocado/data/services/deck_service.dart';
import 'package:hocado/data/services/saved_deck_service.dart';
import 'package:hocado/presentation/viewmodels/decks/deck_state.dart';
import 'package:hocado/presentation/viewmodels/decks/decks_view_model.dart';

// My decks
final deckServiceProvider = Provider<DeckService>((ref) {
  final firestore = ref.read(firestoreProvider);
  return DeckService(firestore: firestore);
});

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  final deckService = ref.read(deckServiceProvider);
  return DeckRepositoryImpl(decksService: deckService);
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

// Provider for deck screen tab
final decksTabIndexProvider = StateProvider<int>((ref) => 0);
