// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/* Tóm tắt tiến độ chung của người dùng với bộ flashcard */
class UserDeckProgress {
  final String uid;
  final String did;
  final int newCardsCount;
  final int learningCardsCount;
  final DateTime? lastStudied;

  UserDeckProgress({
    required this.uid,
    required this.did,
    required this.newCardsCount,
    required this.learningCardsCount,
    this.lastStudied,
  });

  UserDeckProgress copyWith({
    String? uid,
    String? did,
    int? newCardsCount,
    int? learningCardsCount,
    DateTime? lastStudied,
  }) {
    return UserDeckProgress(
      uid: uid ?? this.uid,
      did: did ?? this.did,
      newCardsCount: newCardsCount ?? this.newCardsCount,
      learningCardsCount: learningCardsCount ?? this.learningCardsCount,
      lastStudied: lastStudied ?? this.lastStudied,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'did': did,
      'newCardsCount': newCardsCount,
      'learningCardsCount': learningCardsCount,
      'lastStudied': lastStudied?.millisecondsSinceEpoch,
    };
  }

  factory UserDeckProgress.fromMap(Map<String, dynamic> map) {
    return UserDeckProgress(
      uid: map['uid'] as String,
      did: map['did'] as String,
      newCardsCount: map['newCardsCount'] as int,
      learningCardsCount: map['learningCardsCount'] as int,
      lastStudied: map['lastStudied'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastStudied'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDeckProgress.fromJson(String source) =>
      UserDeckProgress.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserDeckProgress(uid: $uid, did: $did, newCardsCount: $newCardsCount, learningCardsCount: $learningCardsCount, lastStudied: $lastStudied)';
  }

  @override
  bool operator ==(covariant UserDeckProgress other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.did == did &&
        other.newCardsCount == newCardsCount &&
        other.learningCardsCount == learningCardsCount &&
        other.lastStudied == lastStudied;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        did.hashCode ^
        newCardsCount.hashCode ^
        learningCardsCount.hashCode ^
        lastStudied.hashCode;
  }
}
