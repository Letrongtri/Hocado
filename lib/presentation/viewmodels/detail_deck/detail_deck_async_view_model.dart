import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class DetailDeckAsyncViewModel extends AsyncNotifier<DetailDeckState> {
  final String did;

  DetailDeckAsyncViewModel(this.did);

  DeckRepository get _deckRepo => ref.read(deckRepositoryProvider);
  fb_auth.User? get _currentUser => ref.watch(currentUserProvider);
  SavedDeckRepository get _savedDeckRepository =>
      ref.read(savedDeckRepositoryProvider);

  @override
  FutureOr<DetailDeckState> build() async {
    final decksAsyncValue = ref.watch(decksViewModelProvider);
    final flashcardsAsyncValue = ref.watch(flashcardsViewModelProvider(did));

    if (decksAsyncValue.isLoading || flashcardsAsyncValue.isLoading) {
      // Nếu 1 trong 2 provider chính đang load
      return Completer<DetailDeckState>().future;
    }

    // Xử lý lỗi (nếu có)
    if (decksAsyncValue.hasError) {
      throw decksAsyncValue.error!;
    }
    if (flashcardsAsyncValue.hasError) {
      throw flashcardsAsyncValue.error!;
    }

    // Nếu cả hai đều có dữ liệu (data)
    final deckState = decksAsyncValue.value;
    final flashcardsState = flashcardsAsyncValue.value;

    if (flashcardsState == null) {
      // Trường hợp hiếm gặp, nhưng để an toàn
      throw Exception('Failed to load flashcards state.');
    }

    // Lấy Deck từ state đã watch
    Deck? deck;
    if (deckState != null) {
      deck = (deckState.myDecks ?? []).firstWhereOrNull((d) => d.did == did);
      // deck ??= (deckState.savedDecks ?? []).firstWhereOrNull(
      //   (d) => d.did == did,
      // );
    }

    if (deck == null) {
      try {
        // Đây là trường hợp deck "lạ" (public, shared link)
        deck = await _deckRepo.getDeckById(did);
      } catch (e, st) {
        state = AsyncError(e, st);
        throw Exception('Không tìm thấy Deck.');
      }
    } else {}

    // 5. Lấy flashcards từ state đã watch
    final flashcards = flashcardsState.flashcards;

    final ownership = await _determineOwnershipStatus(deck);

    return DetailDeckState(
      deck: deck,
      cardList: flashcards,
      ownershipStatus: ownership,
    );
  }

  Future<DeckOwnershipStatus> _determineOwnershipStatus(Deck deck) async {
    if (_currentUser?.uid != null && deck.uid == _currentUser!.uid) {
      return DeckOwnershipStatus.myDeck;
    }

    // Đã Lưu (Nếu UID không trùng, nhưng có trong savedDecks)
    final isSaved = await _savedDeckRepository.isDeckSavedByUser(
      userId: _currentUser?.uid ?? '',
      deckId: deck.did,
    );
    if (isSaved) return DeckOwnershipStatus.savedDeck;

    // Các trường hợp còn lại
    return DeckOwnershipStatus.unsaveDeck;
  }

  Future<void> saveDeck() async {
    final ownership = state.value?.ownershipStatus;
    if (ownership != DeckOwnershipStatus.unsaveDeck) return;

    final deck = state.value?.deck;
    if (deck == null) {
      throw Exception('Không thể lưu deck');
    }

    ref.read(decksViewModelProvider.notifier).saveDeck(deck);
  }

  Future<void> unsaveDeck() async {
    final ownership = state.value?.ownershipStatus;
    if (ownership != DeckOwnershipStatus.savedDeck) return;

    ref.read(decksViewModelProvider.notifier).unsaveDeck(did);
  }

  // Future<DetailDeckState> _buildState(Deck deck) async {
  //   final ownership = await _determineOwnershipStatus(deck);

  //   // Ví dụ, nếu bạn muốn đồng bộ flashcards:
  //   final flashcardsAsync = ref.read(flashcardsViewModelProvider(did));
  //   final flashcards = flashcardsAsync.value?.flashcards ?? [];

  //   return DetailDeckState(
  //     deck: deck,
  //     cardList: flashcards,
  //     ownershipStatus: ownership,
  //   );
  // }

  // @override
  // FutureOr<DetailDeckState> build() async {
  //   Future.microtask(() {
  //     // Nghe DecksViewModel, nếu deck thay đổi thì reload lại deck detail
  //     ref.listen(decksViewModelProvider, (prev, next) async {
  //       if (next.hasValue) {
  //         final decks = next.value!;
  //         Deck? deckChanged;

  //         deckChanged = decks.myDecks?.firstWhereOrNull(
  //           (deck) => deck.did == did,
  //         );
  //         deckChanged ??= decks.savedDecks?.firstWhereOrNull(
  //           (deck) => deck.did == did,
  //         );

  //         if (deckChanged != null && state.hasValue) {
  //           state = AsyncData(
  //             state.value!.copyWith(deck: deckChanged),
  //           );
  //         }
  //       }
  //     });

  //     // Nghe FlashcardsViewModel(did)
  //     ref.listen(flashcardsViewModelProvider(did), (prev, next) {
  //       if (next.hasValue && state.hasValue) {
  //         state = AsyncData(
  //           state.value!.copyWith(cardList: next.value!.flashcards),
  //         );
  //       }
  //     });
  //   });

  //   final deck = await _deckRepository.getDeckById(did);
  //   final flashcards = await _flashcardRepository.getFlashcardsByDeckId(did);
  //   final ownership = await _determineOwnershipStatus(deck);

  //   return DetailDeckState(
  //     deck: deck,
  //     cardList: flashcards,
  //     ownershipStatus: ownership,
  //   );
  // }

  // Future<void> refreshDeckDetails() async {
  //   ref.invalidate(flashcardsViewModelProvider(did))
  //   // loading state
  //   state = const AsyncLoading();
  //   state = await AsyncValue.guard(() async {
  //     final deck = await _deckRepository.getDeckById(did);
  //     final flashcards = await _flashcardRepository.getFlashcardsByDeckId(did);
  //     return DetailDeckState(
  //       deck: deck,
  //       cardList: flashcards,
  //     );
  //   });
  // }
}
