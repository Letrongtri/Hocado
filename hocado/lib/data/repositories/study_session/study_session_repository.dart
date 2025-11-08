import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/services/services.dart';

class StudySessionRepository {
  final StudySessionService _studySessionService;

  StudySessionRepository({required StudySessionService studySessionService})
    : _studySessionService = studySessionService;

  Future<List<StudySession>> getStudySessionsByUserId(String uid) async {
    try {
      final docs = await _studySessionService.getStudySessionsByUserId(uid);

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => StudySession.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not convert documents to study sessions");
    }
  }

  Future<void> updateStudySession(StudySession studySession) {
    try {
      return _studySessionService.updateSession(studySession.toMap());
    } catch (e) {
      throw Exception("Could not create session");
    }
  }
}
