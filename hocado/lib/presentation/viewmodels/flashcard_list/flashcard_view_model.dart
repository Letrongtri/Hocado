import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/auth_provider.dart';
import 'package:hocado/data/models/deck.dart';
import 'package:hocado/data/models/flashcard.dart';
import 'package:hocado/presentation/viewmodels/flashcard_list/flashcard_list_state.dart';

class FlashcardViewModel extends Notifier<FlashcardListState> {
  late final User _currentUser;

  @override
  FlashcardListState build() {
    _currentUser = ref.read(currentUserProvider)!;

    final deck = Deck.empty().copyWith(uid: _currentUser.uid);

    return FlashcardListState(
      cardList: [newFlashcard(deck.did)],
      deck: deck,
    );
  }

  Flashcard newFlashcard(String did) {
    return Flashcard.empty().copyWith(did: did);
  }

  void addFlashcardBelow(String fid) {
    final index = state.cardList?.indexWhere((card) => card.fid == fid) ?? -1;

    if (index != -1) {
      final newCard = newFlashcard(state.deck?.did ?? '');
      final newList = [...state.cardList!]..insert(index + 1, newCard);
      state = state.copyWith(cardList: newList);
    }
  }

  void deleteFlashcard(String fid) {
    final newList = state.cardList?.where((card) => card.fid != fid).toList();
    state = state.copyWith(cardList: newList);
  }

  void updateFlashcardFront(String fid, String newFront) {
    final index = state.cardList?.indexWhere((card) => card.fid == fid) ?? -1;

    if (index == -1) return;

    final updatedFlashcard = state.cardList![index].copyWith(front: newFront);

    final updatedList = [...state.cardList!];
    updatedList[index] = updatedFlashcard;

    state = state.copyWith(cardList: updatedList);
  }

  void updateFlashcardBack(String fid, String newBack) {
    final index = state.cardList?.indexWhere((card) => card.fid == fid) ?? -1;

    if (index == -1) return;

    final updatedFlashcard = state.cardList![index].copyWith(back: newBack);

    final updatedList = [...state.cardList!];
    updatedList[index] = updatedFlashcard;

    state = state.copyWith(cardList: updatedList);
  }

  void updateFlashcardNote(String fid, String newNote) {
    final index = state.cardList?.indexWhere((card) => card.fid == fid) ?? -1;

    if (index == -1) return;

    final updatedFlashcard = state.cardList![index].copyWith(note: newNote);

    final updatedList = [...state.cardList!];
    updatedList[index] = updatedFlashcard;

    state = state.copyWith(cardList: updatedList);
  }

  void updateDeckName(String did, String newName) {
    if (state.deck?.did != did) return;

    final updatedDeck = state.deck!.copyWith(name: newName);

    state = state.copyWith(deck: updatedDeck);
  }

  void updateDeckDescription(String did, String newDescription) {
    if (state.deck?.did != did) return;

    final updatedDeck = state.deck!.copyWith(description: newDescription);

    state = state.copyWith(deck: updatedDeck);
  }

  void updateDeckIsPublic(String did, bool isPublic) {
    if (state.deck?.did != did) return;

    final updatedDeck = state.deck!.copyWith(isPublic: isPublic);
    print('Updated deck isPublic: ${updatedDeck.isPublic}');
    state = state.copyWith(deck: updatedDeck);
  }

  // xóa toàn bộ dữ liệu
  void clearAll() {
    final deck = Deck.empty().copyWith(uid: _currentUser.uid);

    state = FlashcardListState(
      cardList: [newFlashcard(deck.did)],
      deck: deck,
    );
  }
}
