import 'package:hocado/data/models/models.dart';

abstract class DailyLearningStatRepository {
  Future<List<DailyLearningStat>> getUserDailyLearningStat(
    String uid, {
    int limit = 7,
  });
}
