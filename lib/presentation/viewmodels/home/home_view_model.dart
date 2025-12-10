import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class HomeViewModel extends AsyncNotifier<HomeState> {
  FollowRepository get _followRepo => ref.read(followRepositoryProvider);
  DeckRepository get _deckRepo => ref.read(deckRepositoryProvider);
  UserRepository get _userRepo => ref.read(userRepositoryProvider);
  UserDeckProgressRepository get _progressRepo =>
      ref.read(userDeckProgressRepositoryProvider);

  bool get hasMoreSuggestedDecks => _hasMore;

  // ignore: unused_field
  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  final int _limit = 10;
  List<String>? _followingUserIds;

  @override
  FutureOr<HomeState> build() async {
    _hasMore = true;
    _lastDoc = null;
    _followingUserIds = null;

    state = AsyncData(HomeState());

    loadOnGoing();
    loadSuggested();

    return state.value!;
  }

  Future<void> loadOnGoing() async {
    final uid = ref.watch(currentUserProvider)?.uid;
    if (uid == null) return;

    try {
      // Load Progress
      final progressList = await _progressRepo.getRecentProgress(uid, limit: 6);

      if (progressList.isEmpty) {
        _updateState(
          (s) => s.copyWith(onGoingDecks: [], isOnGoingDecksLoading: false),
        );
        return;
      }

      // Load Decks & Authors song song
      final dids = progressList.map((e) => e.did).toList();
      final decks = await _deckRepo.getDecksByIds(dids);

      final authorIds = decks.map((e) => e.uid).toSet().toList();

      final authors = await _userRepo.getUserByIds(authorIds);

      // Mapping
      final items = progressList.map((p) {
        final deck = decks.firstWhere(
          (d) => d.did == p.did,
          orElse: () => Deck.empty(),
        );
        final author = authors.firstWhere(
          (u) => u.uid == deck.uid,
          orElse: () => User.empty(),
        );
        return HomeDeckItem(deck: deck, author: author, progress: p);
      }).toList();

      // Cập nhật UI ngay lập tức
      _updateState(
        (s) => s.copyWith(onGoingDecks: items, isOnGoingDecksLoading: false),
      );
    } catch (e) {
      _updateState((s) => s.copyWith(isOnGoingDecksLoading: false));
    }
  }

  Future<void> loadSuggested() async {
    final uid = ref.watch(currentUserProvider)?.uid;
    if (uid == null) return;

    if (!_hasMore) return;

    try {
      final followingUsser = await _followRepo.getUserFollowing(uid);
      _followingUserIds = followingUsser.map((e) => e.uid).toList();

      if (_followingUserIds!.isEmpty) {
        // Tắt loading và trả về list rỗng
        _updateState(
          (s) => s.copyWith(suggestedDecks: [], isSuggestedDecksLoading: false),
        );
        _hasMore = false;
        return;
      }

      final result = await _deckRepo.getSuggestedDeckByFollowingUids(
        _followingUserIds!,
        limit: _limit,
        lastDocument: null,
      );

      // Lưu lại pagination info
      _lastDoc = result.lastDocument;
      if (result.decks.length < _limit) {
        _hasMore = false;
      }

      final authorIds = result.decks.map((e) => e.uid).toSet().toList();
      final authors = await _userRepo.getUserByIds(authorIds);

      final items = result.decks.map((deck) {
        final author = authors.firstWhere(
          (u) => u.uid == deck.uid,
          orElse: () => User.empty(),
        );
        return HomeDeckItem(deck: deck, author: author);
      }).toList();

      _updateState(
        (s) =>
            s.copyWith(suggestedDecks: items, isSuggestedDecksLoading: false),
      );
    } catch (e) {
      _updateState((s) => s.copyWith(isSuggestedDecksLoading: false));
    }
  }

  void _updateState(HomeState Function(HomeState) fn) {
    if (state.value != null) {
      state = AsyncData(fn(state.value!));
    }
  }
}
