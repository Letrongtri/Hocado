import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class DecksViewModel extends AsyncNotifier<DeckState> {
  DeckRepository get _repo => ref.read(deckRepositoryProvider);
  SavedDeckRepository get _savedRepo => ref.read(savedDeckRepositoryProvider);
  fb_auth.User? get _currentUser => ref.read(currentUserProvider);
  UserRepository get _userRepo => ref.read(userRepositoryProvider);

  @override
  FutureOr<DeckState> build() async {
    // trả về dữ liệu ban đầu khi ViewModel được khởi tạo
    return await _fetchDecks();
  }

  Future<DeckState> _fetchDecks() async {
    final user = _currentUser;
    if (user == null) throw Exception('User not logged in');

    final myDecks = await _repo.getDecksByUserId(user.uid);
    final savedDecks = await _savedRepo.getSavedDecksByUserId(
      user.uid,
    );

    return DeckState(
      myDecks: myDecks,
      savedDecks: savedDecks,
      currentTabIndex: 0,
    );
  }

  Future<void> refreshDecks() async {
    state = const AsyncLoading(); // cho UI biết đang loading lại

    // tự báo lỗi, không cần try catch
    state = await AsyncValue.guard(() async => _fetchDecks());
  }

  Future<void> createAndUpdateDeck({
    required Deck deck,
    int? totalCards,
    required DateTime createdAt,
    bool isUpdate = false,
  }) async {
    // Save deck using the repository
    final updatedDeck = deck.copyWith(
      totalCards: totalCards,
      createdAt: createdAt,
      updatedAt: createdAt,
      searchIndex:
          '${deck.name.toLowerCase()} ${deck.description.toLowerCase()}',
    );
    await _repo.createAndUpdate(updatedDeck);

    final currentDecks = List<Deck>.from(state.value!.myDecks!);
    if (isUpdate) {
      final index = state.value?.myDecks?.indexWhere(
        (d) => d.did == updatedDeck.did,
      );

      if (index != null && index != -1) {
        currentDecks.removeAt(index);
      }
    } else {
      final field = "createdDecksCount";
      _userRepo.incrementCount(_currentUser!.uid, field);
    }

    final newMyDecks = [updatedDeck, ...currentDecks];

    state = AsyncData(
      state.value?.copyWith(myDecks: newMyDecks) ??
          DeckState(myDecks: [updatedDeck]),
    );
  }

  void changeTab(int index) {
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(currentTabIndex: index));
    }
  }

  Future<void> deleteDeck(String did) async {
    final user = _currentUser;
    if (user == null) return;

    final currentState = state.value;
    if (currentState == null) return;

    final decks = currentState.myDecks;
    final index = decks!.indexWhere((item) => item.did == did);
    if (index == -1) return;

    state = const AsyncLoading();

    try {
      await _repo.delete(did);

      final field = "createdDecksCount";
      _userRepo.decrementCount(_currentUser!.uid, field);

      final updatedDecks = List<Deck>.from(decks)..removeAt(index);

      state = AsyncData(currentState.copyWith(myDecks: updatedDecks));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> saveDeck(Deck deck) async {
    final user = _currentUser;
    if (user == null) return;

    final currentState = state.value;
    if (currentState == null) return;

    final decks = currentState.savedDecks ?? [];

    state = const AsyncLoading();

    try {
      final savedDeck = SavedDeck(
        did: deck.did,
        savedAt: DateTime.now(),
        description: deck.description,
        name: deck.name,
        uid: deck.uid,
        searchIndex: deck.searchIndex,
        thumbnailUrl: deck.thumbnailUrl,
      );

      await _savedRepo.saveDeck(user.uid, savedDeck);

      final field = "savedDecksCount";
      _userRepo.incrementCount(_currentUser!.uid, field);

      final updatedDecks = [savedDeck, ...decks];

      state = AsyncData(currentState.copyWith(savedDecks: updatedDecks));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> unsaveDeck(String did) async {
    final user = _currentUser;
    if (user == null) return;

    final currentState = state.value;
    if (currentState == null) return;

    final decks = currentState.savedDecks;
    final index = decks!.indexWhere((item) => item.did == did);
    if (index == -1) return;

    state = const AsyncLoading();

    try {
      await _savedRepo.unsaveDeck(user.uid, did);

      final field = "savedDecksCount";
      _userRepo.decrementCount(_currentUser!.uid, field);

      final updatedDecks = List<SavedDeck>.from(decks)..removeAt(index);

      state = AsyncData(currentState.copyWith(savedDecks: updatedDecks));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Deck? findDeckByDid(String did) {
  //   // Lấy danh sách hiện có trong state
  //   final decksState = state.value;
  //   if (decksState == null) return null;

  //   // Tìm trong myDecks và savedDecks
  //   final myDeck = decksState.myDecks?.firstWhereOrNull(
  //     (deck) => deck.did == did,
  //   );
  //   if (myDeck != null) return myDeck;

  //   final savedDeck = decksState.savedDecks?.firstWhereOrNull(
  //     (deck) => deck.did == did,
  //   );
  //   return savedDeck;
  // }

  // Future<void> updateDeck(Deck updatedDeck) async {
  //   final currentState = state.value;
  //   if (currentState == null) return;

  //   final decks = currentState.myDecks;
  //   final index = decks!.indexWhere((item) => item.did == updatedDeck.did);
  //   if (index == -1) return;

  //   state = const AsyncLoading();

  //   try {
  //     await _repo.updateDeck(updatedDeck.did, updatedDeck);

  //     final updatedDecks = List<Deck>.from(decks)..[index] = updatedDeck;

  //     state = AsyncData(currentState.copyWith(myDecks: updatedDecks));
  //   } catch (e, st) {
  //     state = AsyncError(e, st);
  //   }
  // }
}
