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

  fb_auth.User? get _currentUser => ref.read(currentUserProvider);
  FollowRepository get _followRepo => ref.read(followRepositoryProvider);
  DeckRepository get _deckRepo => ref.read(deckRepositoryProvider);

  @override
  FutureOr<ProfileState> build() async {
    final user = await ref.watch(userProfileProvider(uid).future);

    final currentUserId = _currentUser?.uid;
    if (currentUserId == null) throw Exception('Bạn chưa đăng nhập.');

    final isMyProfile = uid == currentUserId;

    bool isFollowing = false;
    List<Deck> publicDecks = [];
    if (!isMyProfile) {
      final followingUsers = await ref.watch(
        followingUsersProvider(uid).future,
      );

      isFollowing = followingUsers.any((f) => f.uid == currentUserId);

      publicDecks = await _deckRepo.getPublicDecksByUserId(uid);
    }

    final profileStatus = isMyProfile
        ? ProfileStatus.myProfile.name
        : isFollowing
        ? ProfileStatus.isFollowing.name
        : ProfileStatus.notFollowing.name;

    final List<LearningActivity> mockActivities = [
      LearningActivity(
        laid: '1',
        uid: '1',
        did: '1',
        deckName: "Từ vựng IELTS Band 8.0",
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        type: LearningActivityType.studySession.name,
        durationMinutes: 20,
        cardsReviewed: 25,
      ),
      LearningActivity(
        laid: '2',
        uid: '1',
        deckName: "Công thức Hóa Học 12",
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        type: LearningActivityType.createdDeck.name,
      ),
      LearningActivity(
        laid: '3',
        uid: '1',
        deckName: "Lịch sử Đảng",
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
        type: LearningActivityType.studySession.name,
        durationMinutes: 15,
        cardsReviewed: 18,
      ),
      LearningActivity(
        laid: '4',
        uid: '1',
        deckName: "Từ vựng IELTS Band 8.0",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        type: LearningActivityType.studySession.name,
        durationMinutes: 10,
        cardsReviewed: 15,
      ),
    ];

    final List<DailyLearningStat> mockStats = [
      DailyLearningStat(
        dlid: '1',
        uid: '1',
        date: DateTime.now().subtract(const Duration(days: 6)),
        totalMinutesStudied: 15,
        totalCardsReviewed: 20,
        totalCorrect: 18,
        totalIncorrect: 2,
      ),
      DailyLearningStat(
        dlid: '2',
        uid: '1',
        date: DateTime.now().subtract(const Duration(days: 5)),
        totalMinutesStudied: 25,
        totalCardsReviewed: 30,
        totalCorrect: 25,
        totalIncorrect: 5,
      ),
      DailyLearningStat(
        dlid: '3',
        uid: '1',
        date: DateTime.now().subtract(const Duration(days: 4)),
        totalMinutesStudied: 10,
        totalCardsReviewed: 15,
        totalCorrect: 15,
        totalIncorrect: 0,
      ),
      DailyLearningStat(
        dlid: '4',
        uid: '1',
        date: DateTime.now().subtract(const Duration(days: 3)),
        totalMinutesStudied: 30,
        totalCardsReviewed: 40,
        totalCorrect: 32,
        totalIncorrect: 8,
      ),
      DailyLearningStat(
        dlid: '5',
        uid: '1',
        date: DateTime.now().subtract(const Duration(days: 2)),
        totalMinutesStudied: 5,
        totalCardsReviewed: 10,
        totalCorrect: 8,
        totalIncorrect: 2,
      ),
      DailyLearningStat(
        dlid: '6',
        uid: '1',
        date: DateTime.now().subtract(const Duration(days: 1)),
        totalMinutesStudied: 45,
        totalCardsReviewed: 50,
        totalCorrect: 40,
        totalIncorrect: 10,
      ),
      DailyLearningStat(
        dlid: '7',
        uid: '1',
        date: DateTime.now(),
        totalMinutesStudied: 20,
        totalCardsReviewed: 25,
        totalCorrect: 22,
        totalIncorrect: 3,
      ),
    ];

    final profile = ProfileState(
      user: user,
      profileStatus: profileStatus,
      achievements: [],
      learningStats: mockStats,
      learningActivities: mockActivities,
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
