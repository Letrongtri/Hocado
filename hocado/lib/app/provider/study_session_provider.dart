import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/firebase_provider.dart';
import 'package:hocado/data/repositories/study_session/study_session_repository.dart';
import 'package:hocado/data/services/study_session_service.dart';

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
