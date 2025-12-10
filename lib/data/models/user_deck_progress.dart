// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

/* Tóm tắt tiến độ chung của người dùng với bộ flashcard */
class UserDeckProgress {
  final String udid; // 'uid_did'
  final String uid;
  final String did;
  final int? newCardsCount;
  final int? learningCardsCount;
  final DateTime? lastStudied;
  // Lưu sau khi kết thúc phiên học

  UserDeckProgress({
    required this.udid,
    required this.uid,
    required this.did,
    this.newCardsCount,
    this.learningCardsCount,
    this.lastStudied,
  });

  UserDeckProgress copyWith({
    String? udid,
    String? uid,
    String? did,
    int? newCardsCount,
    int? learningCardsCount,
    DateTime? lastStudied,
  }) {
    return UserDeckProgress(
      udid: udid ?? this.udid,
      uid: uid ?? this.uid,
      did: did ?? this.did,
      newCardsCount: newCardsCount ?? this.newCardsCount,
      learningCardsCount: learningCardsCount ?? this.learningCardsCount,
      lastStudied: lastStudied ?? this.lastStudied,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'udid': udid,
      'uid': uid,
      'did': did,
      'newCardsCount': newCardsCount,
      'learningCardsCount': learningCardsCount,
      'lastStudied': lastStudied,
    };
  }

  factory UserDeckProgress.fromMap(Map<String, dynamic> map) {
    return UserDeckProgress(
      udid: map['udid'] as String,
      uid: map['uid'] as String,
      did: map['did'] as String,
      newCardsCount: map['newCardsCount'] != null
          ? map['newCardsCount'] as int
          : null,
      learningCardsCount: map['learningCardsCount'] != null
          ? map['learningCardsCount'] as int
          : null,
      lastStudied: map['lastStudied'] != null
          ? (map['lastStudied'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDeckProgress.fromJson(String source) =>
      UserDeckProgress.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserDeckProgress(udid: $udid, uid: $uid, did: $did, newCardsCount: $newCardsCount, learningCardsCount: $learningCardsCount, lastStudied: $lastStudied)';
  }

  @override
  bool operator ==(covariant UserDeckProgress other) {
    if (identical(this, other)) return true;

    return other.udid == udid &&
        other.uid == uid &&
        other.did == did &&
        other.newCardsCount == newCardsCount &&
        other.learningCardsCount == learningCardsCount &&
        other.lastStudied == lastStudied;
  }

  @override
  int get hashCode {
    return udid.hashCode ^
        uid.hashCode ^
        did.hashCode ^
        newCardsCount.hashCode ^
        learningCardsCount.hashCode ^
        lastStudied.hashCode;
  }

  factory UserDeckProgress.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserDeckProgress(
      udid: data['udid'] as String,
      uid: data['uid'] as String,
      did: data['did'] as String,
      newCardsCount: data['newCardsCount'] != null
          ? data['newCardsCount'] as int
          : null,
      learningCardsCount: data['learningCardsCount'] != null
          ? data['learningCardsCount'] as int
          : null,
      lastStudied: data['lastStudied'] != null
          ? (data['lastStudied'] as Timestamp).toDate()
          : null,
    );
  }
}
