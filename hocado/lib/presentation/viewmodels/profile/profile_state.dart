// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hocado/data/models/models.dart';

enum ProfileStatus { myProfile, isFollowing, notFollowing }

class ProfileState {
  final User user;
  final String profileStatus;
  final List<UserArchievement> achievements;
  final List<DailyLearningStat> learningStats;
  final List<LearningActivity> learningActivities;
  final List<Deck> publicDecks;

  ProfileState({
    required this.user,
    required this.profileStatus,
    this.achievements = const [],
    this.learningStats = const [],
    this.learningActivities = const [],
    this.publicDecks = const [],
  });

  ProfileState copyWith({
    User? user,
    String? profileStatus,
    List<UserArchievement>? achievements,
    List<DailyLearningStat>? learningStats,
    List<LearningActivity>? learningActivities,
    List<Deck>? publicDecks,
  }) {
    return ProfileState(
      user: user ?? this.user,
      profileStatus: profileStatus ?? this.profileStatus,
      achievements: achievements ?? this.achievements,
      learningStats: learningStats ?? this.learningStats,
      learningActivities: learningActivities ?? this.learningActivities,
      publicDecks: publicDecks ?? this.publicDecks,
    );
  }
}
