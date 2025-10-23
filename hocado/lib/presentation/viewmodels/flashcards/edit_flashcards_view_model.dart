import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/data/models/flashcard.dart';
import 'package:hocado/presentation/viewmodels/flashcards/flashcards_state.dart';

class EditFlashcardsViewModel extends Notifier<FlashcardsState> {
  final String? did;

  EditFlashcardsViewModel(this.did);

  @override
  FlashcardsState build() {
    return FlashcardsState(flashcards: [newFlashcard()]);
  }

  void setFlashcards(List<Flashcard> flashcards) {
    state = state.copyWith(flashcards: [...flashcards]);
  }

  Flashcard newFlashcard() {
    return Flashcard.empty().copyWith(did: did);
  }

  void addFlashcardBelow(String fid) {
    final flashcards = state.flashcards;

    // if (fid == '') {
    //   state = state.copyWith(flashcards: [newFlashcard()]);
    // }

    final index = flashcards.indexWhere((card) => card.fid == fid);

    if (index != -1) {
      final newCard = newFlashcard();
      final newList = [...flashcards]..insert(index + 1, newCard);
      state = state.copyWith(flashcards: newList);
    }
  }

  void deleteFlashcard(String fid) {
    final newList = state.flashcards.where((card) => card.fid != fid).toList();
    state = state.copyWith(flashcards: newList);
  }

  void updateFlashcardFront(String fid, String newFront) {
    final index = state.flashcards.indexWhere((card) => card.fid == fid);

    if (index == -1) return;

    final updatedFlashcard = state.flashcards[index].copyWith(front: newFront);

    final updatedList = [...state.flashcards];
    updatedList[index] = updatedFlashcard;

    state = state.copyWith(flashcards: updatedList);
  }

  void updateFlashcardBack(String fid, String newBack) {
    final index = state.flashcards.indexWhere((card) => card.fid == fid);

    if (index == -1) return;

    final updatedFlashcard = state.flashcards[index].copyWith(back: newBack);

    final updatedList = [...state.flashcards];
    updatedList[index] = updatedFlashcard;

    state = state.copyWith(flashcards: updatedList);
  }

  void updateFlashcardNote(String fid, String newNote) {
    final index = state.flashcards.indexWhere((card) => card.fid == fid);

    if (index == -1) return;

    final updatedFlashcard = state.flashcards[index].copyWith(note: newNote);

    final updatedList = [...state.flashcards];
    updatedList[index] = updatedFlashcard;

    state = state.copyWith(flashcards: updatedList);
  }

  // xóa toàn bộ dữ liệu
  // void clearAll() {
  //   final deck = Deck.empty().copyWith(uid: _currentUser.uid);

  //   state = Flashflashcardstate(
  //     flashcards [newFlashcard(deck.did)],
  //     deck: deck,
  //   );
  // }
}
