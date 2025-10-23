// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/flashcard.dart';

class FlashcardsState {
  final List<Flashcard> flashcards;

  FlashcardsState({this.flashcards = const []});

  FlashcardsState copyWith({
    List<Flashcard>? flashcards,
  }) {
    return FlashcardsState(
      flashcards: flashcards ?? this.flashcards,
    );
  }
}
