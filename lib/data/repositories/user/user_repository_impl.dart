import 'package:hocado/utils/paths.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';
import 'package:image_picker/image_picker.dart';

class UserRepositoryImpl implements UserRepository {
  final UserService _userService;
  final StorageService _storageService;

  UserRepositoryImpl({
    required UserService userService,
    required StorageService storageService,
  }) : _userService = userService,
       _storageService = storageService;
  @override
  Future<User> getUserById(String uid) async {
    try {
      return await _userService.getUserById(uid).then((docSnapshot) {
        return User.fromFirestore(docSnapshot);
      });
    } catch (e) {
      throw Exception("Could not convert documents to user");
    }
  }

  @override
  Future<void> deleteUser(String id, String? avatarUrl) async {
    try {
      if (avatarUrl != null) {
        await _storageService.deleteImage(avatarUrl);
      }
      return _userService.deleteUser(id);
    } catch (e) {
      throw Exception("Could not delete user from database");
    }
  }

  @override
  Future<void> updateUser(User user, XFile? avatar) async {
    try {
      String? avatarUrl;
      if (avatar != null) {
        final path = Paths.avatarPath;
        avatarUrl = await _storageService.uploadImage(
          image: avatar,
          path: path,
          name: user.uid,
        );
      }

      user = user.copyWith(avatarUrl: avatarUrl ?? user.avatarUrl);
      return _userService.updateUser(user.toMap());
    } catch (e) {
      throw Exception("Could not update user to database");
    }
  }

  @override
  Stream<User> getUserStream(String uid) {
    try {
      return _userService
          .getUserStream(uid)
          .map(
            (event) => User.fromFirestore(event),
          );
    } catch (e) {
      throw Exception("Could not fetch user from database");
    }
  }

  @override
  Future<List<User>> getUserByIds(List<String> uids) async {
    try {
      final docs = await _userService.getUserByIds(uids);

      if (docs.isEmpty) {
        return [];
      }

      return docs.map((doc) => User.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Could not fetch users from database");
    }
  }

  @override
  Future<void> updateUserNextStudyTime(
    String uid,
    DateTime nextStudyTime,
  ) async {
    try {
      return _userService.updateUserNextStudyTime(uid, nextStudyTime);
    } catch (e) {
      throw Exception("Could not update user next study time to database");
    }
  }
}
