// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Follow {
  final String uid;
  final String displayName;
  final String? avatarUrl;
  final DateTime createdAt;

  Follow({
    required this.uid,
    required this.displayName,
    this.avatarUrl,
    required this.createdAt,
  });

  Follow copyWith({
    String? uid,
    String? displayName,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return Follow(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
    };
  }

  factory Follow.fromMap(Map<String, dynamic> map) {
    return Follow(
      uid: map['uid'] as String,
      displayName: map['displayName'] as String,
      avatarUrl: map['avatarUrl'] == null ? null : map['avatarUrl'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Follow.fromJson(String source) =>
      Follow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Follow(uid: $uid, displayName: $displayName, avatarUrl: $avatarUrl, createdAt: $createdAt)';

  @override
  bool operator ==(covariant Follow other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.displayName == displayName &&
        other.avatarUrl == avatarUrl &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      uid.hashCode ^
      displayName.hashCode ^
      avatarUrl.hashCode ^
      createdAt.hashCode;

  factory Follow.fromFirestore(DocumentSnapshot doc) {
    return Follow(
      uid: doc['uid'] as String,
      displayName: doc['displayName'] as String,
      avatarUrl: doc['avatarUrl'] == null ? null : doc['avatarUrl'] as String,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
    );
  }
}
