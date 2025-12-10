import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

class UserArchievementRepositoryImpl implements UserArchievementRepository {
  final UserArchievementService _archievementService;

  UserArchievementRepositoryImpl({
    required UserArchievementService archievementService,
  }) : _archievementService = archievementService;

  @override
  Future<List<UserArchievement>> getUserArchievementByUserId(String uid) async {
    try {
      final docs = await _archievementService.getUserArchievement(uid);

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => UserArchievement.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not convert documents to decks");
    }
  }
}
