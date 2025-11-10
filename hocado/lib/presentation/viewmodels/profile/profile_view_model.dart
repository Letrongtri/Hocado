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

  UserRepository get _userRepo => ref.read(userRepositoryProvider);
  fb_auth.User? get _currentUser => ref.read(currentUserProvider);

  @override
  FutureOr<ProfileState> build() async {
    final currentUserId = _currentUser?.uid;
    if (currentUserId == null) throw Exception('Bạn chưa đăng nhập.');

    final user = await _userRepo.getUserById(uid);
    final isMyProfile = uid == currentUserId;

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
      isMyProfile: isMyProfile,
      achievements: [],
      learningStats: mockStats,
      learningActivities: mockActivities,
    );
    return profile;
  }
}
