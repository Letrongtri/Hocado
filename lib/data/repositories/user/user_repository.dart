import 'package:hocado/data/models/models.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserRepository {
  Future<void> updateUser(User user, XFile? avatar);

  Future<void> deleteUser(String id, String? avatarUrl);

  Future<User> getUserById(String uid);

  Stream<User> getUserStream(String uid);

  Future<List<User>> getUserByIds(List<String> uids);

  Future<void> updateUserNextStudyTime(String uid, DateTime nextStudyTime);
}
