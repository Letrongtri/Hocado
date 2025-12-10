import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/learning_activity/learning_activity_repository.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
import 'package:image_picker/image_picker.dart';

class CreateDeckViewModel extends AsyncNotifier<CreateDeckState> {
  final String? did;
  bool isEditMode = false;

  XFile? _pickedThumbnail;
  Map<String, XFile>? _pickedFront;
  Map<String, XFile>? _pickedBack;

  CreateDeckViewModel(this.did);

  fb_auth.User? get _currentUser => ref.watch(currentUserProvider);
  LearningActivityRepository get _activityRepo =>
      ref.watch(learningActivityRepositoryProvider);

  @override
  FutureOr<CreateDeckState> build() async {
    final userId = _currentUser?.uid;
    if (userId == null) {
      throw Exception("Hãy đăng nhập để tạo thẻ.");
    }
    _pickedThumbnail = null;
    _pickedFront = null;
    _pickedBack = null;

    // Tạo deck mới
    if (did == null || did!.isEmpty) {
      isEditMode = false;
      final deck = Deck.empty().copyWith(uid: userId);
      final flashcards = [newFlashcard()];
      state = AsyncData(CreateDeckState(deck: deck, flashcards: flashcards));
      return CreateDeckState(deck: deck, flashcards: flashcards);
    }

    // Chỉnh sửa deck của tôi
    isEditMode = true;
    final decksState = await ref.read(decksViewModelProvider.future);

    // Tìm deck "gốc"
    Deck? pristineDeck = decksState.myDecks?.firstWhereOrNull(
      (d) => d.did == did,
    );

    if (pristineDeck == null) {
      throw Exception('Không tìm thấy Deck để chỉnh sửa.');
    }

    // Tải flashcards "gốc"
    final pristineFlashcards = await ref.read(
      flashcardsViewModelProvider(did!).future,
    );

    // Trả về state ban đầu để chỉnh sửa
    state = AsyncData(
      CreateDeckState(
        deck: pristineDeck,
        flashcards: pristineFlashcards.flashcards,
      ),
    );
    return CreateDeckState(
      deck: pristineDeck,
      flashcards: pristineFlashcards.flashcards,
    );
  }

  void updateDeckInfo(Deck updatedDeck, XFile? thumbnail) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(deck: updatedDeck));
    if (thumbnail != null) _pickedThumbnail = thumbnail;
  }

  Flashcard newFlashcard() {
    return Flashcard.empty().copyWith(did: did);
  }

  void addFlashcardBelow(String fid) {
    if (!state.hasValue) return;

    final flashcards = state.value?.flashcards ?? [];

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
    _pickedFront?.remove(fid);
    _pickedBack?.remove(fid);
  }

  void updateFlashcardInfo(
    Flashcard updatedFlashcard,
    XFile? frontImage,
    XFile? backImage,
  ) {
    if (!state.hasValue) return;

    final index =
        state.value!.flashcards?.indexWhere(
          (card) => card.fid == updatedFlashcard.fid,
        ) ??
        -1;

    if (index == -1) return;

    final updatedList = [...state.value!.flashcards!];
    updatedList[index] = updatedFlashcard;

    state = AsyncData(state.value!.copyWith(flashcards: updatedList));

    if (frontImage != null) _pickedFront = {updatedFlashcard.fid: frontImage};
    if (backImage != null) _pickedBack = {updatedFlashcard.fid: backImage};
  }

  Future<void> saveChanges() async {
    final userId = _currentUser?.uid;
    if (userId == null) throw Exception("Hãy đăng nhập để tạo thẻ.");

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
            isUpdate: isEditMode,
            thumbnail: _pickedThumbnail,
          ),
      if (currentState.flashcards != null &&
          currentState.flashcards!.isNotEmpty)
        ref
            .read(flashcardsViewModelProvider(currentState.deck.did).notifier)
            .createAndUpdateFlashcards(
              flashcards: currentState.flashcards!,
              createdAt: now,
              pickedFronts: _pickedFront,
              pickedBacks: _pickedBack,
            ),
    ]);

    if (!isEditMode) {
      // Cập nhật learning activity
      final laid = '${userId}_${now.toIso8601String()}';

      final learningActivity = LearningActivity(
        laid: laid,
        uid: userId,
        timestamp: now,
        type: LearningActivityType.createdDeck.name,
        did: did,
        deckName: deckName,
      );
      await _activityRepo.createAndUpdate(learningActivity);
    }
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

  void tongglePublicDeck(bool isPublic) {
    if (!state.hasValue) return;
    state = AsyncData(
      state.value!.copyWith(
        deck: state.value!.deck.copyWith(isPublic: isPublic),
      ),
    );
  }
}
