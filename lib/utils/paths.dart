class Paths {
  static const String users = 'users';
  static const String avatars = 'avatars';
  static const String decks = 'decks';
  static const String thumbnails = 'thumbnails';
  static const String flashcards = 'flashcards';
  static const String front = 'front';
  static const String back = 'back';

  static String get avatarPath {
    return '$users/$avatars';
  }

  static String get deckThumbnailPath {
    return '$decks/$thumbnails';
  }

  static String flashcardImagePath(String id) {
    return '$flashcards/$id';
  }
}
