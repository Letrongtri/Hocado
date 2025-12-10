import 'package:hocado/data/models/models.dart';

abstract class UserArchievementRepository {
  Future<List<UserArchievement>> getUserArchievementByUserId(String uid);
}
