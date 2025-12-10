// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserArchievement {
  final String uid;
  final String aid;
  final DateTime unlockedAt;

  UserArchievement({
    required this.uid,
    required this.aid,
    required this.unlockedAt,
  });

  UserArchievement copyWith({
    String? uid,
    String? aid,
    DateTime? unlockedAt,
  }) {
    return UserArchievement(
      uid: uid ?? this.uid,
      aid: aid ?? this.aid,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'aid': aid,
      'unlockedAt': unlockedAt,
    };
  }

  factory UserArchievement.fromMap(Map<String, dynamic> map) {
    return UserArchievement(
      uid: map['uid'] as String,
      aid: map['aid'] as String,
      unlockedAt: (map['unlockedAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserArchievement.fromJson(String source) =>
      UserArchievement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserArchievement(uid: $uid, aid: $aid, unlockedAt: $unlockedAt)';

  @override
  bool operator ==(covariant UserArchievement other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.aid == aid &&
        other.unlockedAt == unlockedAt;
  }

  @override
  int get hashCode => uid.hashCode ^ aid.hashCode ^ unlockedAt.hashCode;

  factory UserArchievement.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserArchievement(
      uid: data['uid'] as String,
      aid: data['aid'] as String,
      unlockedAt: (data['unlockedAt'] as Timestamp).toDate(),
    );
  }
}
