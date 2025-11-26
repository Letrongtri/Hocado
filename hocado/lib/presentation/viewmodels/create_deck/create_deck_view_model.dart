import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class CreateDeckViewModel extends AsyncNotifier<CreateDeckState> {
  final String? did;
  bool isEditMode = false;

  CreateDeckViewModel(this.did);

  // DeckRepository get _deckRepo => ref.read(deckRepositoryProvider);
  fb_auth.User? get _currentUser => ref.read(currentUserProvider);

  @override
  FutureOr<CreateDeckState> build() async {
    final userId = _currentUser?.uid;
    if (userId == null) {
      throw Exception("Hãy đăng nhập để tạo thẻ.");
    }

    // Tạo deck mới
    if (did == null || did!.isEmpty) {
      final deck = Deck.empty().copyWith(uid: userId);
      final flashcards = [newFlashcard()];
      return CreateDeckState(deck: deck, flashcards: flashcards);
    }

    // Chỉnh sửa deck của tôi
    isEditMode = true;
    final decksState = await ref.watch(decksViewModelProvider.future);

    // Tìm deck "gốc"
    Deck? pristineDeck = decksState.myDecks?.firstWhereOrNull(
      (d) => d.did == did,
    );

    if (pristineDeck == null) {
      throw Exception('Không tìm thấy Deck để chỉnh sửa.');
    }

    // Tải flashcards "gốc"
    final pristineFlashcards = await ref.watch(
      flashcardsViewModelProvider(did!).future,
    );

    // Trả về state ban đầu để chỉnh sửa
    return CreateDeckState(
      deck: pristineDeck,
      flashcards: pristineFlashcards.flashcards,
    );
  }

  void updateDeckInfo(Deck updatedDeck) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(deck: updatedDeck));
  }

  Flashcard newFlashcard() {
    return Flashcard.empty().copyWith(did: did);
  }

  void addFlashcardBelow(String fid) {
    if (!state.hasValue) return;

    final flashcards = state.value!.flashcards ?? [];

    final index = flashcards.indexWhere((card) => card.fid == fid);

    if (index != -1) {
      final newCard = newFlashcard();
      final newList = [...flashcards]..insert(index + 1, newCard);
      state = AsyncData(
        state.value!.copyWith(flashcards: newList),
      );
    }
  }

  void deleteFlashcard(String fid) {
    if (!state.hasValue) return;
    final newList = state.value!.flashcards!
        .where((card) => card.fid != fid)
        .toList();
    state = AsyncData(
      state.value!.copyWith(flashcards: newList),
    );
  }

  void updateFlashcardFront(String fid, String newFront) {
    if (!state.hasValue) return;

    final index =
        state.value!.flashcards?.indexWhere((card) => card.fid == fid) ?? -1;

    if (index == -1) return;

    final updatedFlashcard = state.value!.flashcards![index].copyWith(
      front: newFront,
    );

    final updatedList = [...state.value!.flashcards!];
    updatedList[index] = updatedFlashcard;

    state = AsyncData(
      state.value!.copyWith(flashcards: updatedList),
    );
  }

  void updateFlashcardBack(String fid, String newBack) {
    if (!state.hasValue) return;

    final index =
        state.value!.flashcards?.indexWhere((card) => card.fid == fid) ?? -1;

    if (index == -1) return;

    final updatedFlashcard = state.value!.flashcards![index].copyWith(
      back: newBack,
    );

    final updatedList = [...state.value!.flashcards!];
    updatedList[index] = updatedFlashcard;

    state = AsyncData(
      state.value!.copyWith(flashcards: updatedList),
    );
  }

  void updateFlashcardNote(String fid, String newNote) {
    if (!state.hasValue) return;

    final index =
        state.value!.flashcards?.indexWhere((card) => card.fid == fid) ?? -1;

    if (index == -1) return;

    final updatedFlashcard = state.value!.flashcards![index].copyWith(
      note: newNote,
    );

    final updatedList = [...state.value!.flashcards!];
    updatedList[index] = updatedFlashcard;

    state = AsyncData(
      state.value!.copyWith(flashcards: updatedList),
    );
  }

  Future<void> saveChanges() async {
    if (!state.hasValue) throw Exception("State không hợp lệ");

    final deckName = state.value!.deck.name.trim().isEmpty
        ? state.value!.deck.did
        : state.value!.deck.name.trim();

    final currentState = state.value!.copyWith(
      deck: state.value!.deck.copyWith(name: deckName),
    );

    final now = DateTime.now();

    // Gọi các hàm của SSOT ViewModel để cập nhật dữ liệu gốc
    await Future.wait([
      ref
          .read(decksViewModelProvider.notifier)
          .createAndUpdateDeck(
            deck: currentState.deck,
            totalCards: currentState.flashcards?.length ?? 0,
            createdAt: now,
          ),
      if (currentState.flashcards != null &&
          currentState.flashcards!.isNotEmpty)
        ref
            .read(flashcardsViewModelProvider(currentState.deck.did).notifier)
            .createAndUpdateFlashcards(
              flashcards: currentState.flashcards!,
              createdAt: now,
            ),
    ]);
  }

  Future<void> deleteDeck() async {
    if (!state.hasValue) return;

    if (isEditMode) {
      if (did == null || did!.isEmpty) {
        throw Exception("Deck ID không hợp lệ.");
      }

      await ref.read(decksViewModelProvider.notifier).deleteDeck(did!);

      await ref
          .read(flashcardsViewModelProvider(did!).notifier)
          .deleteFlashcards(did!);
    }
  }

  void loadGeneratedFlashcards(List<Flashcard> flashcards) {
    if (!state.hasValue) return;
    final currentDid = state.value!.deck.did;
    final newCards = flashcards
        .map((card) => card.copyWith(did: currentDid))
        .toList();

    state = AsyncData(state.value!.copyWith(flashcards: newCards));
  }
}
