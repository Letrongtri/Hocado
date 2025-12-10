import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/repositories/daily_learning_stat/daily_learning_stat_repository.dart';
import 'package:hocado/data/repositories/daily_learning_stat/daily_learning_stat_repository_impl.dart';
import 'package:hocado/data/services/services.dart';

final dailyLearningStatServiceProvider = Provider((ref) {
  final firestore = ref.read(firestoreProvider);
  return DailyLearningStatService(firestore: firestore);
});

final dailyLearningStatRepositoryProvider =
    Provider<DailyLearningStatRepository>((ref) {
      final service = ref.read(dailyLearningStatServiceProvider);
      return DailyLearningStatRepositoryImpl(dailyLearningStatService: service);
    });
