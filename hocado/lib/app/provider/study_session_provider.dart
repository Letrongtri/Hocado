import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

// Services
final studySessionServiceProvider = Provider((ref) {
  final firestore = ref.read(firestoreProvider);
  return StudySessionService(firestore: firestore);
});

// Repository
final studySessionRepositoryProvider = Provider((ref) {
  final studySessionService = ref.read(studySessionServiceProvider);
  return StudySessionRepository(studySessionService: studySessionService);
});
