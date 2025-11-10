import 'package:hocado/data/models/models.dart';

abstract class UserRepository {
  // Future<List<User>> getDecksByUserId(String id);

  // Future<void> delete(String id);

  Future<void> updateUser(User user);

  Future<void> deleteUser(String id);

  Future<User> getUserById(String uid);

  Future<void> incrementCount(String uid, String field, {int count = 1});

  Future<void> decrementCount(String uid, String field, {int count = 1});

  // Future<SearchDecksResult> searchDecks({
  //   required String id,
  //   bool isFindingPublic,
  //   String? search,
  //   DocumentSnapshot? lastDocument,
  //   int limit = 10,
  // });
}
