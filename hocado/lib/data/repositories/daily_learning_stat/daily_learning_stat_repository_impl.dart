import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

class DailyLearningStatRepositoryImpl implements DailyLearningStatRepository {
  final DailyLearningStatService _dailyLearningStatService;

  DailyLearningStatRepositoryImpl({
    required DailyLearningStatService dailyLearningStatService,
  }) : _dailyLearningStatService = dailyLearningStatService;

  @override
  Future<List<DailyLearningStat>> getUserDailyLearningStat(String uid) async {
    try {
      final docs = await _dailyLearningStatService.getUserDailyLearningStat(
        uid,
      );

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => DailyLearningStat.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not convert documents to decks");
    }
  }
}
