import 'package:hocado/data/models/models.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserRepository {
  Future<void> updateUser(User user, XFile? avatar);

  Future<void> deleteUser(String id);

  Future<User> getUserById(String uid);

  Future<void> incrementCount(String uid, String field, {int count = 1});

  Future<void> decrementCount(String uid, String field, {int count = 1});

  Stream<User> getUserStream(String uid);
}
