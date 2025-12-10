import 'package:hocado/data/models/models.dart';

abstract class UserDeckProgressRepository {
  Future<List<UserDeckProgress>> getUserDeckProgress(String uid, String did);

  Future<void> createAndUpdate(UserDeckProgress userDeckProgress);

  Future<List<UserDeckProgress>> getRecentProgress(
    String uid, {
    int limit = 10,
  });
}
