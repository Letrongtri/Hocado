import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class SearchViewModel extends AsyncNotifier<SearchState> {
  DeckRepository get _repo => ref.read(deckRepositoryProvider);
  fb_auth.User? get _currentUser => ref.read(currentUserProvider);
  static const int _limit = 10;

  @override
  FutureOr<SearchState> build() async {
    try {
      final uid = _currentUser?.uid ?? '';
      final result = await _repo.searchDecks(
        id: uid,
        isFindingPublic: true,
        search: null,
        lastDocument: null,
        limit: _limit,
      );

      final newDecks = result.decks;
      final newLastDocument = result.lastDocument;
      final hasMore = newDecks.length == _limit;

      return SearchState(
        publicDecks: newDecks,
        publicDecksLastDocument: newLastDocument,
        publicDecksHasMore: hasMore,
        myDecks: [],
        savedDecks: [],
      );
    } catch (e, st) {
      return Future.error(e, st); // Báo lỗi khi build thất bại
    }
  }

  Future<void> changeTab(int index) async {
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(currentTabIndex: index));

      if (index == 0 && state.value!.publicDecks!.isEmpty) {
        await fetchMorePublicDecks();
      } else if (index == 1 && state.value!.myDecks!.isEmpty) {
        await fetchMoreMyDecks();
      } else if (index == 2 && state.value!.savedDecks!.isEmpty) {
        // await fetchMoreSavedDecks();
      }
    }
  }

  /// Tải thêm Public Decks
  Future<void> fetchMorePublicDecks() async {
    // Không cần tham số query vì đã được lưu trong state
    final currentState = state.value;
    if (currentState == null ||
        !currentState.publicDecksHasMore ||
        state.isLoading) {
      return; // Dừng nếu không còn, hoặc đang loading
    }

    // Đặt state về AsyncLoading nhưng giữ lại dữ liệu cũ
    // state = AsyncValue.loading();
    state = AsyncValue.data(currentState);

    try {
      final uid = _currentUser?.uid ?? '';
      final result = await _repo.searchDecks(
        id: uid,
        isFindingPublic: true,
        search: currentState.currentSearchQuery,
        lastDocument: currentState.publicDecksLastDocument,
        limit: _limit,
      );

      final newDecks = result.decks;
      final newLastDocument = result.lastDocument;
      final hasMore = newDecks.length == _limit;

      // Tạo danh sách mới bằng cách nối decks cũ và mới
      final updatedDecks = <Deck>[
        ...currentState.publicDecks ?? [],
        ...newDecks,
      ];

      // Cập nhật State
      state = AsyncValue.data(
        currentState.copyWith(
          publicDecks: updatedDecks,
          publicDecksLastDocument: newLastDocument,
          publicDecksHasMore: hasMore,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Khởi tạo/Tìm kiếm mới Public Decks
  Future<void> searchPublicDecks(String query) async {
    final currentState = state.value;
    if (currentState == null || state.isLoading) {
      return; // Dừng nếu không còn, hoặc đang loading
    }

    // Đặt state về AsyncLoading nhưng giữ lại dữ liệu cũ
    state = AsyncValue.data(currentState);

    try {
      final uid = _currentUser?.uid ?? '';
      final result = await _repo.searchDecks(
        id: uid,
        isFindingPublic: true,
        search: query,
        lastDocument: null, // Bắt đầu lại từ đầu
        limit: _limit,
      );

      final newDecks = result.decks;
      final newLastDocument = result.lastDocument;
      final hasMore = newDecks.length == _limit;

      // Cập nhật State
      state = AsyncValue.data(
        currentState.copyWith(
          publicDecks: newDecks,
          currentSearchQuery: query, // Lưu lại query
          publicDecksLastDocument: newLastDocument,
          publicDecksHasMore: hasMore,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Tải thêm my Decks
  Future<void> fetchMoreMyDecks() async {
    final currentState = state.value;
    if (currentState == null ||
        !currentState.myDecksHasMore ||
        state.isLoading) {
      return; // Dừng nếu không còn, hoặc đang loading
    }

    // Đặt state về AsyncLoading nhưng giữ lại dữ liệu cũ
    state = AsyncValue.data(currentState);

    try {
      final uid = _currentUser?.uid ?? '';
      final result = await _repo.searchDecks(
        id: uid,
        isFindingPublic: false,
        search: currentState.currentSearchQuery,
        lastDocument: currentState.myDecksLastDocument,
        limit: _limit,
      );

      final newDecks = result.decks;
      final newLastDocument = result.lastDocument;
      final hasMore = newDecks.length == _limit;

      // Tạo danh sách mới bằng cách nối decks cũ và mới
      final updatedDecks = <Deck>[
        ...currentState.myDecks ?? [],
        ...newDecks,
      ];

      // Cập nhật State
      state = AsyncValue.data(
        currentState.copyWith(
          myDecks: updatedDecks,
          myDecksLastDocument: newLastDocument,
          myDecksHasMore: hasMore,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Khởi tạo/Tìm kiếm mới my Decks
  Future<void> searchMyDecks(String query) async {
    final currentState = state.value;
    if (currentState == null || state.isLoading) {
      return; // Dừng nếu không còn, hoặc đang loading
    }

    // Đặt state về AsyncLoading nhưng giữ lại dữ liệu cũ
    state = AsyncValue.loading();

    try {
      final uid = _currentUser?.uid ?? '';
      final result = await _repo.searchDecks(
        id: uid,
        isFindingPublic: false,
        search: query,
        lastDocument: null, // Bắt đầu lại từ đầu
        limit: _limit,
      );

      final newDecks = result.decks;
      final newLastDocument = result.lastDocument;
      final hasMore = newDecks.length == _limit;

      // Cập nhật State
      state = AsyncValue.data(
        currentState.copyWith(
          myDecks: newDecks,
          currentSearchQuery: query, // Lưu lại query
          myDecksLastDocument: newLastDocument,
          myDecksHasMore: hasMore,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
