import 'package:flutter/foundation.dart';
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

  @override
  Future<List<UserDeckProgress>> getRecentProgress(
    String uid, {
    int limit = 10,
  }) async {
    try {
      final docs = await _userDeckProgressService.getRecentProgress(
        uid,
        limit: limit,
      );

      return docs.map((doc) => UserDeckProgress.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Could not convert documents to user deck progress");
    }
  }
}
