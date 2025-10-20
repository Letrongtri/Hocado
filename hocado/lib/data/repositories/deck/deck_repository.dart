import 'package:hocado/data/models/deck.dart';

abstract class DeckRepository {
  Future<List<Deck>> getDecksByUserId(String id);

  Future<void> updateDeck(String id, Deck data);

  Future<void> delete(String id);

  Future<void> create(Deck deck);

  Future<Deck> getDeckById(String id);
}
