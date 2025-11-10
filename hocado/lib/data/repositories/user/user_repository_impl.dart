import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';

class UserRepositoryImpl implements UserRepository {
  final UserService _userService;

  UserRepositoryImpl({required UserService userService})
    : _userService = userService;
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
  Future<void> deleteUser(String id) {
    try {
      return _userService.deleteUser(id);
    } catch (e) {
      throw Exception("Could not delete user from database");
    }
  }

  @override
  Future<void> updateUser(User user) {
    try {
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
}
