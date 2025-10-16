import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/auth_provider.dart';
import 'package:hocado/app/provider/deck_provider.dart';
import 'package:hocado/data/repositories/deck/deck_repository.dart';
import 'package:hocado/data/repositories/saved_deck/saved_deck_repository.dart';
import 'package:hocado/presentation/viewmodels/decks/deck_state.dart';

class DecksViewModel extends AsyncNotifier<DeckState> {
  late final DeckRepository _deckRepository;
  late final SavedDeckRepository _savedDeckRepository;

  @override
  FutureOr<DeckState> build() async {
    _deckRepository = ref.read(deckRepositoryProvider);
    _savedDeckRepository = ref.read(savedDeckRepositoryProvider);

    // trả về dữ liệu ban đầu khi ViewModel được khởi tạo
    return await _fetchDecks();
  }

  Future<DeckState> _fetchDecks() async {
    final user = ref.read(currentUserProvider);
    if (user == null) throw Exception('User not logged in');

    final myDecks = await _deckRepository.getDecksByUserId(user.uid);
    final savedDecks = await _savedDeckRepository.getSavedDecksByUserId(
      user.uid,
    );

    return DeckState(myDecks: myDecks, savedDecks: savedDecks);
  }

  Future<void> refreshDecks() async {
    state = const AsyncLoading(); // cho UI biết đang loading lại

    // tự báo lỗi, không cần try catch
    state = await AsyncValue.guard(() async => _fetchDecks());
  }

  // Future<void> addDeck(Deck deck) async {
  //   await _deckRepository.addDeck(deck);
  //   // cập nhật lại danh sách myDecks mà không cần fetch lại toàn bộ
  //   final current = state.value;
  //   if (current != null) {
  //     final updated = current.copyWith(
  //       myDecks: [...current.myDecks ?? [], deck],
  //     );
  //     state = AsyncData(updated);
  //   }
  // }
}
