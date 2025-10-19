import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/auth_provider.dart';
import 'package:hocado/app/provider/deck_provider.dart';
import 'package:hocado/data/repositories/deck/deck_repository.dart';
import 'package:hocado/data/repositories/saved_deck/saved_deck_repository.dart';
import 'package:hocado/presentation/viewmodels/decks/deck_state.dart';

class DecksViewModel extends AsyncNotifier<DeckState> {
  DeckRepository get _repo => ref.read(deckRepositoryProvider);
  SavedDeckRepository get _savedRepo => ref.read(savedDeckRepositoryProvider);

  @override
  FutureOr<DeckState> build() async {
    // trả về dữ liệu ban đầu khi ViewModel được khởi tạo
    return await _fetchDecks();
  }

  Future<DeckState> _fetchDecks() async {
    final user = ref.read(currentUserProvider);
    if (user == null) throw Exception('User not logged in');

    final myDecks = await _repo.getDecksByUserId(user.uid);
    final savedDecks = await _savedRepo.getSavedDecksByUserId(
      user.uid,
    );

    return DeckState(myDecks: myDecks, savedDecks: savedDecks);
  }

  Future<void> refreshDecks() async {
    state = const AsyncLoading(); // cho UI biết đang loading lại

    // tự báo lỗi, không cần try catch
    state = await AsyncValue.guard(() async => _fetchDecks());
  }
}
