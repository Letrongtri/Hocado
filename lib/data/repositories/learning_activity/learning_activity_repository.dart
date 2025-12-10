import 'package:hocado/data/models/models.dart';

abstract class LearningActivityRepository {
  Future<List<LearningActivity>> getUserLearningActivities(
    String uid, {
    int limit = 10,
  });

  Future<void> createAndUpdate(LearningActivity learningActivity);
}
