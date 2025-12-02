import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hocado/data/models/models.dart';

typedef PaginationDecksResult = ({
  List<Deck> decks,
  DocumentSnapshot? lastDocument,
});

abstract class DeckRepository {
  Future<List<Deck>> getDecksByUserId(String id);

  Future<void> delete(String id);

  Future<void> createAndUpdate(Deck deck);

  Future<Deck> getDeckById(String id);

  Future<PaginationDecksResult> searchDecks({
    required String id,
    bool isFindingPublic,
    String? search,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  });

  Future<List<Deck>> getDecksByIds(List<String> ids);

  Future<List<Deck>> getPublicDecksByUserId(String id);

  Future<PaginationDecksResult> getSuggestedDeckByFollowingUids(
    List<String> ids, {
    int limit = 10,
    DocumentSnapshot? lastDocument,
  });
}
