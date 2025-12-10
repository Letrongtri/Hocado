import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class ProfileViewModel extends AsyncNotifier<ProfileState> {
  final String uid;

  ProfileViewModel(this.uid);

  fb_auth.User? get _currentUser => ref.watch(currentUserProvider);
  FollowRepository get _followRepo => ref.read(followRepositoryProvider);
  DeckRepository get _deckRepo => ref.read(deckRepositoryProvider);
  LearningActivityRepository get _learningActivityRepo =>
      ref.read(learningActivityRepositoryProvider);
  DailyLearningStatRepository get _dailyLearningStatRepo =>
      ref.read(dailyLearningStatRepositoryProvider);

  @override
  FutureOr<ProfileState> build() async {
    final user = await ref.watch(userProfileProvider(uid).future);

    bool isMyProfile = false;
    final currentUserId = _currentUser?.uid;
    if (currentUserId != null) {
      isMyProfile = uid == currentUserId;
    }
    print(currentUserId);

    bool isFollowing = false;
    List<Deck> publicDecks = [];
    List<LearningActivity> learningActivity = [];
    List<DailyLearningStat> learningStat = [];
    if (!isMyProfile) {
      final followingUsers = await ref
          .watch(followRepositoryProvider)
          .getUserFollowing(uid);

      isFollowing = followingUsers.any((f) => f.uid == currentUserId);

      publicDecks = await _deckRepo.getPublicDecksByUserId(uid);
    } else if (currentUserId != null) {
      learningActivity = await _learningActivityRepo.getUserLearningActivities(
        currentUserId,
        limit: 10,
      );
      learningStat = await _dailyLearningStatRepo.getUserDailyLearningStat(
        currentUserId,
        limit: 7,
      );
    }

    final profileStatus = isMyProfile
        ? ProfileStatus.myProfile.name
        : isFollowing
        ? ProfileStatus.isFollowing.name
        : ProfileStatus.notFollowing.name;

    final profile = ProfileState(
      user: user,
      profileStatus: profileStatus,
      learningStats: learningStat,
      learningActivities: learningActivity,
      publicDecks: publicDecks,
    );
    return profile;
  }

  Future<void> followUser(
    String followingUid,
    String followingDisplayName,
  ) async {
    final uid = _currentUser?.uid;
    if (uid == null) return;

    try {
      final followingData = Follow(
        uid: followingUid,
        displayName: followingDisplayName,
        createdAt: DateTime.now(),
      );

      await _followRepo.followUser(uid, followingData);

      state = AsyncData(
        state.value!.copyWith(profileStatus: ProfileStatus.isFollowing.name),
      );
    } catch (e) {
      throw Exception("Could not follow user to database");
    }
  }

  Future<void> unfollowUser(String followingUid) async {
    final uid = _currentUser?.uid;
    if (uid == null) return;

    try {
      await _followRepo.unfollowUser(uid, followingUid);

      state = AsyncData(
        state.value!.copyWith(profileStatus: ProfileStatus.notFollowing.name),
      );
    } catch (e) {
      throw Exception("Could not unfollow user to database");
    }
  }
}
