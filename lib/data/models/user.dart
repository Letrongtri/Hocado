// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hocado/utils/xp_helper.dart';

class User {
  final String uid;
  final String email;
  final String? avatarUrl;
  final String fullName;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;
  final int xp;
  final int level;
  final int nextLevelXp;
  final int followersCount;
  final int followingCount;
  final int createdDecksCount;
  final int savedDecksCount;
  final DateTime? nextStudyTime;

  User({
    required this.uid,
    required this.email,
    this.avatarUrl,
    required this.fullName,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
    this.xp = 0,
    this.level = 1,
    this.nextLevelXp = 0,
    this.createdDecksCount = 0,
    this.savedDecksCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.nextStudyTime,
  });

  User copyWith({
    String? uid,
    String? email,
    String? avatarUrl,
    String? fullName,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
    int? xp,
    int? level,
    int? nextLevelXp,
    int? followersCount,
    int? followingCount,
    int? createdDecksCount,
    int? savedDecksCount,
    DateTime? nextStudyTime,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      nextLevelXp: nextLevelXp ?? this.nextLevelXp,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      createdDecksCount: createdDecksCount ?? this.createdDecksCount,
      savedDecksCount: savedDecksCount ?? this.savedDecksCount,
      nextStudyTime: nextStudyTime ?? this.nextStudyTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'avatarUrl': avatarUrl,
      'fullName': fullName,
      'phone': phone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastLogin': lastLogin,
      'xp': xp,
      'level': level,
      'nextLevelXp': nextLevelXp,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'createdDecksCount': createdDecksCount,
      'savedDecksCount': savedDecksCount,
      'nextStudyTime': nextStudyTime,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      avatarUrl: map['avatarUrl'] != null ? map['avatarUrl'] as String : null,
      fullName: map['fullName'] as String,
      phone: map['phone'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      lastLogin: map['lastLogin'] != null
          ? (map['lastLogin'] as Timestamp).toDate()
          : null,
      xp: map['xp'] as int,
      level: map['level'] as int,
      nextLevelXp: map['nextLevelXp'] as int,
      followersCount: map['followersCount'] as int,
      followingCount: map['followingCount'] as int,
      createdDecksCount: map['createdDecksCount'] as int,
      savedDecksCount: map['savedDecksCount'] as int,
      nextStudyTime: map['nextStudyTime'] != null
          ? (map['nextStudyTime'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, avatarUrl: $avatarUrl, fullName: $fullName, phone: $phone, createdAt: $createdAt, updatedAt: $updatedAt, lastLogin: $lastLogin, xp: $xp, level: $level, nextLevelXp: $nextLevelXp, followersCount: $followersCount, followingCount: $followingCount, createdDecksCount: $createdDecksCount, savedDecksCount: $savedDecksCount, nextStudyTime: $nextStudyTime)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.avatarUrl == avatarUrl &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.lastLogin == lastLogin &&
        other.xp == xp &&
        other.level == level &&
        other.nextLevelXp == nextLevelXp &&
        other.followersCount == followersCount &&
        other.followingCount == followingCount &&
        other.createdDecksCount == createdDecksCount &&
        other.savedDecksCount == savedDecksCount &&
        other.nextStudyTime == nextStudyTime;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        avatarUrl.hashCode ^
        fullName.hashCode ^
        phone.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        lastLogin.hashCode ^
        xp.hashCode ^
        level.hashCode ^
        nextLevelXp.hashCode ^
        followersCount.hashCode ^
        followingCount.hashCode ^
        createdDecksCount.hashCode ^
        savedDecksCount.hashCode ^
        nextStudyTime.hashCode;
  }

  // Phương thức để chuyển đổi từ Firestore DocumentSnapshot sang UserModel
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      email: data['email'],
      avatarUrl: data['avatarUrl'],
      fullName: data['fullName'],
      phone: data['phone'],
      xp: data['xp'] ?? 0,
      level: data['level'] ?? 1,
      nextLevelXp: data['nextLevelXp'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastLogin: data['lastLogin'] != null
          ? (data['lastLogin'] as Timestamp).toDate()
          : null,
      followersCount: data['followersCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
      createdDecksCount: data['createdDecksCount'] ?? 0,
      savedDecksCount: data['savedDecksCount'] ?? 0,
      nextStudyTime: data['nextStudyTime'] != null
          ? (data['nextStudyTime'] as Timestamp).toDate()
          : null,
    );
  }

  factory User.empty() => User(
    uid: '',
    email: '',
    avatarUrl: '',
    fullName: '',
    phone: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    lastLogin: DateTime.now(),
    xp: 0,
    level: 1,
    nextLevelXp: XpHelper.getXpForLevel(1),
    followersCount: 0,
    followingCount: 0,
    createdDecksCount: 0,
    savedDecksCount: 0,
  );
}
