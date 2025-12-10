import 'package:hocado/data/models/models.dart';

abstract class FollowRepository {
  Future<void> followUser(String uid, Follow followingData);

  Future<void> unfollowUser(String uid, String followingUid);

  Future<List<Follow>> getUserFollowing(String uid);
}
