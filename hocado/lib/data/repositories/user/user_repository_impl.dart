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
  Future<void> deleteUser(String id) async {
    try {
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
  Future<void> incrementCount(String uid, String field, {int count = 1}) {
    try {
      return _userService.incrementCount(uid, field, count: count);
    } catch (e) {
      throw Exception("Could not increase count of user to database");
    }
  }

  @override
  Future<void> decrementCount(String uid, String field, {int count = 1}) {
    try {
      return _userService.decrementCount(uid, field, count: count);
    } catch (e) {
      throw Exception("Could not decrease count of user to database");
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
}
