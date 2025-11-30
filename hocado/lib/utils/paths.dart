class Paths {
  static const String users = 'users';
  static const String avatars = 'avatars';

  static String get avatarPath {
    return '$users/$avatars';
  }
}
