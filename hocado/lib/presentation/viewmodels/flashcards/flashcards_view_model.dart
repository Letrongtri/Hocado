import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class FlashcardsViewModel extends AsyncNotifier<FlashcardsState> {
  final String did;
  FlashcardRepository get _flashcardRepository =>
      ref.read(flashcardRepositoryProvider);
  fb_auth.User? get _currentUser => ref.read(currentUserProvider);

  FlashcardsViewModel(this.did);

  @override
  FutureOr<FlashcardsState> build() async {
    final user = _currentUser;
    if (user == null) throw Exception('User not logged in');

    final flashcards = await _flashcardRepository.getFlashcardsByDeckId(did);

    return FlashcardsState(flashcards: flashcards);
  }

  Future<List<Flashcard>> fetchFlashcards() async {
    state = const AsyncLoading();
    try {
      final flashcards = await _flashcardRepository.getFlashcardsByDeckId(did);
      if (!ref.mounted) return [];

      state = AsyncData(FlashcardsState(flashcards: flashcards));
      return flashcards;
    } catch (e, st) {
      state = AsyncError(e, st);
      return [];
    }
  }

  // Future<void> refreshFlashcards() async {
  //   state = const AsyncLoading(); // cho UI biết đang loading lại

  //   // tự báo lỗi, không cần try catch
  //   state = await AsyncValue.guard(() async => _fetchFlashcards());
  // }

  Future<void> createAndUpdateFlashcards({
    required List<Flashcard> flashcards,
    required DateTime createdAt,
  }) async {
    final user = _currentUser;
    if (user == null) return;

    try {
      // Save flashcard using the repository
      final createdCards = flashcards
          .map(
            (card) => card.copyWith(createdAt: createdAt),
          )
          .toList();

      await _flashcardRepository.createAndUpdateFlashcards(createdCards, did);

      if (!ref.mounted) return;

      state = AsyncData(
        FlashcardsState(flashcards: createdCards),
      );
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteFlashcards(String did) async {
    final user = _currentUser;
    if (user == null) return;

    // Giữ lại state cũ
    final prevState = state.value;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _flashcardRepository.deleteFlashcardsByDeckId(did);

      return prevState!.copyWith(flashcards: []);
    });
  }
}
