// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hocado/data/models/deck.dart';

class SearchState {
  final List<Deck>? publicDecks;
  final DocumentSnapshot? publicDecksLastDocument;
  final bool publicDecksHasMore;

  final List<Deck>? myDecks;
  final DocumentSnapshot? myDecksLastDocument;
  final bool myDecksHasMore;

  final List<Deck>? savedDecks;
  final DocumentSnapshot? savedDecksLastDocument;
  final bool savedDecksHasMore;

  final String currentSearchQuery;
  final int currentTabIndex;
  // final bool isLoading;

  SearchState({
    // this.isLoading = false,
    this.currentTabIndex = 0,
    this.currentSearchQuery = '', // Mặc định là rỗng
    this.publicDecks = const [],
    this.publicDecksLastDocument,
    this.publicDecksHasMore = true, // Mặc định là có thể load thêm
    this.myDecks = const [],
    this.myDecksLastDocument,
    this.myDecksHasMore = true, // Mặc định là có thể load thêm
    this.savedDecks = const [],
    this.savedDecksLastDocument,
    this.savedDecksHasMore = true, // Mặc định là có thể load thêm
  });

  SearchState copyWith({
    // bool? isLoading,
    int? currentTabIndex,
    String? currentSearchQuery,
    List<Deck>? publicDecks,
    DocumentSnapshot? publicDecksLastDocument,
    bool? publicDecksHasMore,
    List<Deck>? myDecks,
    DocumentSnapshot? myDecksLastDocument,
    bool? myDecksHasMore,
    List<Deck>? savedDecks,
    DocumentSnapshot? savedDecksLastDocument,
    bool? savedDecksHasMore,
  }) {
    return SearchState(
      // isLoading: isLoading ?? this.isLoading,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,

      publicDecks: publicDecks ?? this.publicDecks,
      publicDecksLastDocument:
          publicDecksLastDocument ?? this.publicDecksLastDocument,
      publicDecksHasMore: publicDecksHasMore ?? this.publicDecksHasMore,

      myDecks: myDecks ?? this.myDecks,
      myDecksLastDocument: myDecksLastDocument ?? this.myDecksLastDocument,
      myDecksHasMore: myDecksHasMore ?? this.myDecksHasMore,

      savedDecks: savedDecks ?? this.savedDecks,
      savedDecksLastDocument:
          savedDecksLastDocument ?? this.savedDecksLastDocument,
      savedDecksHasMore: savedDecksHasMore ?? this.savedDecksHasMore,
    );
  }
}
