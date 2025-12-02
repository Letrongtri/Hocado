// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/models.dart';

class HomeState {
  final List<Map<Deck, String>>? onGoingDecks;
  final List<Map<Deck, String>>? suggestedDecks;
  final List<User>? users;

  HomeState({
    this.onGoingDecks,
    this.suggestedDecks,
    this.users,
  });

  HomeState copyWith({
    List<Map<Deck, String>>? onGoingDecks,
    List<Map<Deck, String>>? suggestedDecks,
    List<User>? users,
  }) {
    return HomeState(
      onGoingDecks: onGoingDecks ?? this.onGoingDecks,
      suggestedDecks: suggestedDecks ?? this.suggestedDecks,
      users: users ?? this.users,
    );
  }
}
