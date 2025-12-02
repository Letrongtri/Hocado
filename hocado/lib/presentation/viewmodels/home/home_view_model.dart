import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class HomeViewModel extends StreamNotifier<HomeState> {
  fb_auth.User? get _currentUser => ref.watch(currentUserProvider);
  DeckRepository get _deckRepo => ref.read(deckRepositoryProvider);
  UserRepository get _userRepo => ref.read(userRepositoryProvider);
  UserDeckProgressRepository get _progressRepo =>
      ref.read(userDeckProgressRepositoryProvider);

  final int _suggestedDecksLimit = 10;
  bool _hasMoreSuggestedDecks = true;
  DocumentSnapshot? _suggestedDecksLastDocument;

  // Cache following user ids (không cần gọi lại nhiều lần)
  List<String>? _followingUserIds;

  bool get hasMoreSuggestedDecks => _hasMoreSuggestedDecks;

  @override
  Stream<HomeState> build() {
    return fetchHomeData();
  }

  Stream<HomeState> fetchHomeData() async* {
    final uid = _currentUser?.uid;
    if (uid == null) {
      yield HomeState();
      return;
    }

    // Load on-going progress
    final onGoingProgress = await _progressRepo.getRecentProgress(
      uid,
      limit: 6,
    );

    final onGoingDids = onGoingProgress.map((e) => e.did).toList();
    final onGoingDeckList = await _deckRepo.getDecksByIds(onGoingDids);
    final onGoingUserIds = onGoingProgress.map((e) => e.uid).toList();

    // Lấy following user IDs (chỉ lấy 1 lần)
    _followingUserIds ??= (await ref.watch(
      followingUsersProvider(uid).future,
    )).map((e) => e.uid).toList();

    // Load suggested decks (using pagination)
    var suggestedDecks = <Map<Deck, String>>[];

    if (_hasMoreSuggestedDecks) {
      final pagination = await _deckRepo.getSuggestedDeckByFollowingUids(
        _followingUserIds!,
        limit: _suggestedDecksLimit,
        lastDocument: _suggestedDecksLastDocument,
      );

      final decks = pagination.decks;
      final newLastDoc = pagination.lastDocument;

      suggestedDecks = decks.map((deck) => {deck: deck.uid}).toList();

      // Update pagination state
      if (decks.length < _suggestedDecksLimit) {
        _hasMoreSuggestedDecks = false;
      }
      _suggestedDecksLastDocument = newLastDoc;
    }

    // Combine all user IDs and stream them
    final allUserIds = {
      ...onGoingUserIds,
      ..._followingUserIds!,
    }.toList();

    yield* _userRepo.getUserByIds(allUserIds).map((users) {
      // on-going deck mapping
      final onGoingDecks = onGoingProgress.map((p) {
        final deck = onGoingDeckList.firstWhere((d) => d.did == p.did);
        return {deck: p.uid};
      }).toList();

      return HomeState(
        onGoingDecks: onGoingDecks,
        suggestedDecks: suggestedDecks,
        users: users,
      );
    });
  }

  // Gọi khi user kéo load more suggested decks
  Future<void> loadMoreSuggestedDecks() async {
    if (!_hasMoreSuggestedDecks) return;

    final uid = _currentUser?.uid;
    if (uid == null) return;

    if (_followingUserIds == null) {
      final followingUsers = await ref.read(followingUsersProvider(uid).future);
      _followingUserIds = followingUsers.map((e) => e.uid).toList();
    }

    final result = await _deckRepo.getSuggestedDeckByFollowingUids(
      _followingUserIds!,
      limit: _suggestedDecksLimit,
      lastDocument: _suggestedDecksLastDocument,
    );

    // Update pagination internal state
    _suggestedDecksLastDocument = result.lastDocument;
    if (result.decks.length < _suggestedDecksLimit) {
      _hasMoreSuggestedDecks = false;
    }

    // Cập nhật state hiện tại
    final current = state.value;
    if (current == null) return;

    final appended = [
      ...current.suggestedDecks ?? <Map<Deck, String>>[],
      ...result.decks.map((d) => {d: d.uid}),
    ];

    state = AsyncData(
      current.copyWith(
        suggestedDecks: appended,
      ),
    );
  }
}
