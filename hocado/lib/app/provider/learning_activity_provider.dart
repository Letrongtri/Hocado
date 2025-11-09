import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

final learningActivityServiceProvider = Provider<LearningActivityService>((
  ref,
) {
  final firestore = ref.read(firestoreProvider);
  return LearningActivityService(firestore: firestore);
});

final learningActivityRepositoryProvider = Provider<LearningActivityRepository>(
  (ref) {
    final service = ref.read(learningActivityServiceProvider);
    return LearningActivityRepositoryImpl(learningActivityService: service);
  },
);
