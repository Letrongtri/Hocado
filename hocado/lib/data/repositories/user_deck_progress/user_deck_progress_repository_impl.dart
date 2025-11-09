import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

class UserDeckProgressRepositoryImpl implements UserDeckProgressRepository {
  final UserDeckProgressService _userDeckProgressService;

  UserDeckProgressRepositoryImpl({
    required UserDeckProgressService userDeckProgressService,
  }) : _userDeckProgressService = userDeckProgressService;

  @override
  Future<List<UserDeckProgress>> getUserDeckProgress(
    String uid,
    String did,
  ) async {
    try {
      final docs = await _userDeckProgressService.getUserDeckProgress(uid, did);

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => UserDeckProgress.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not convert documents to user deck progress");
    }
  }

  @override
  Future<void> createAndUpdate(UserDeckProgress userDeckProgress) async {
    try {
      return _userDeckProgressService.createAndUpdateUserDeckProgress(
        userDeckProgress.toMap(),
      );
    } catch (e) {
      throw Exception("Could not save user deck progress");
    }
  }
}
