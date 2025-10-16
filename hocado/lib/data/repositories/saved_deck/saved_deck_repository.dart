import 'package:hocado/data/models/deck.dart';

abstract class SavedDeckRepository {
  Future<List<Deck>> getSavedDecksByUserId(String id);

  Future<void> delete(String id);
}
