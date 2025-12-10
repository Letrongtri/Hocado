import 'package:hocado/data/models/follow.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

class FollowRepositoryImpl implements FollowRepository {
  final FollowService _followService;

  FollowRepositoryImpl({required FollowService followService})
    : _followService = followService;

  @override
  Future<void> followUser(String uid, Follow followingData) {
    try {
      return _followService.followUser(uid, followingData.toMap());
    } catch (e) {
      throw Exception("Could not follow user to database");
    }
  }

  @override
  Future<void> unfollowUser(String uid, String followingUid) {
    try {
      return _followService.unfollowUser(uid, followingUid);
    } catch (e) {
      throw Exception("Could not unfollow user to database");
    }
  }

  @override
  Future<List<Follow>> getUserFollowing(String uid) async {
    try {
      final docs = await _followService.getUserFollowing(uid);

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => Follow.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not fetch user following from database");
    }
  }
}
