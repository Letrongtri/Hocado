import 'dart:async';

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

    // Lấy progress 1 lần — vì bạn không stream progress
    final onGoingProgress = await _progressRepo.getRecentProgress(
      uid,
      limit: 6,
    );
    final dids = onGoingProgress.map((e) => e.did).toList();
    final onGoingDeckList = await _deckRepo.getDecksByIds(dids);

    final onGoingUserIds = onGoingProgress.map((e) => e.uid).toList();

    if (onGoingUserIds.isEmpty) {
      yield HomeState(
        onGoingDecks: [],
        // suggestedDecks: [],
        users: [],
      );
      return;
    }

    yield* _userRepo.getUserByIds(onGoingUserIds).map((newUsers) {
      final onGoingDecks = onGoingProgress
          .map((p) {
            final deck = onGoingDeckList.firstWhere((d) => d.did == p.did);
            return {deck: p.uid};
          })
          .whereType<Map<Deck, String>>()
          .toList();

      return HomeState(
        onGoingDecks: onGoingDecks,
        // suggestedDecks: [],
        users: newUsers,
      );
    });
  }
}
