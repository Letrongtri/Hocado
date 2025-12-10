// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/models.dart';

class HomeDeckItem {
  final Deck deck;
  final User? author;
  final UserDeckProgress? progress;

  HomeDeckItem({required this.deck, this.author, this.progress});

  HomeDeckItem copyWith({
    Deck? deck,
    User? author,
    UserDeckProgress? progress,
  }) {
    return HomeDeckItem(
      deck: deck ?? this.deck,
      author: author ?? this.author,
      progress: progress ?? this.progress,
    );
  }
}

class HomeState {
  final List<HomeDeckItem> onGoingDecks;
  final List<HomeDeckItem> suggestedDecks;
  final bool isOnGoingDecksLoading;
  final bool isSuggestedDecksLoading;

  HomeState({
    this.onGoingDecks = const [],
    this.suggestedDecks = const [],
    this.isOnGoingDecksLoading = true,
    this.isSuggestedDecksLoading = true,
  });

  HomeState copyWith({
    List<HomeDeckItem>? onGoingDecks,
    List<HomeDeckItem>? suggestedDecks,
    bool? isOnGoingDecksLoading,
    bool? isSuggestedDecksLoading,
  }) {
    return HomeState(
      onGoingDecks: onGoingDecks ?? this.onGoingDecks,
      suggestedDecks: suggestedDecks ?? this.suggestedDecks,
      isOnGoingDecksLoading:
          isOnGoingDecksLoading ?? this.isOnGoingDecksLoading,
      isSuggestedDecksLoading:
          isSuggestedDecksLoading ?? this.isSuggestedDecksLoading,
    );
  }
}
