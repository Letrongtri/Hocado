import 'package:hocado/data/models/models.dart';

abstract class FollowRepository {
  Future<void> followUser(String uid, Follow followingData);

  Future<void> unfollowUser(String uid, String followingUid);

  Stream<List<Follow>> getUserFollowingStream(String uid);
}
