import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

class LearningActivityRepositoryImpl implements LearningActivityRepository {
  final LearningActivityService _learningActivityService;

  LearningActivityRepositoryImpl({
    required LearningActivityService learningActivityService,
  }) : _learningActivityService = learningActivityService;

  @override
  Future<List<LearningActivity>> getUserLearningActivities(String uid) async {
    try {
      final docs = await _learningActivityService.getUserLearningActivities(
        uid,
      );

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => LearningActivity.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not convert documents to learning activities");
    }
  }

  @override
  Future<void> createAndUpdate(LearningActivity learningActivity) async {
    try {
      return _learningActivityService.createAndUpdateLearningActivity(
        learningActivity.toMap(),
      );
    } catch (e) {
      throw Exception("Could not save learning activity");
    }
  }
}
