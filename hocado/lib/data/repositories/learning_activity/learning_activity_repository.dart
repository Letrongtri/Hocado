import 'package:hocado/data/models/models.dart';

abstract class LearningActivityRepository {
  Future<List<LearningActivity>> getUserLearningActivities(String uid);

  Future<void> createAndUpdate(LearningActivity learningActivity);
}
