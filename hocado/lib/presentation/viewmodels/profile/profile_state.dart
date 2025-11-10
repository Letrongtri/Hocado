// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/models.dart';

class ProfileState {
  final User user;
  final bool isMyProfile;
  final List<UserArchievement> achievements;
  final List<DailyLearningStat> learningStats;
  final List<LearningActivity> learningActivities;

  ProfileState({
    required this.user,
    this.isMyProfile = false,
    this.achievements = const [],
    this.learningStats = const [],
    this.learningActivities = const [],
  });

  ProfileState copyWith({
    User? user,
    bool? isMyProfile,
    List<UserArchievement>? achievements,
    List<DailyLearningStat>? learningStats,
    List<LearningActivity>? learningActivities,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isMyProfile: isMyProfile ?? this.isMyProfile,
      achievements: achievements ?? this.achievements,
      learningStats: learningStats ?? this.learningStats,
      learningActivities: learningActivities ?? this.learningActivities,
    );
  }
}
