// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String username;
  final String avatarUrl;
  final String fullName;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;
  final int totalPoints;

  // mật khẩu không lưu trực tiếp trong model này

  User({
    required this.uid,
    required this.email,
    required this.username,
    required this.avatarUrl,
    required this.fullName,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLogin,
    required this.totalPoints,
  });

  User copyWith({
    String? uid,
    String? email,
    String? username,
    String? avatarUrl,
    String? fullName,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
    int? totalPoints,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
      'fullName': fullName,
      'phone': phone,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'lastLogin': lastLogin?.millisecondsSinceEpoch,
      'totalPoints': totalPoints,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      avatarUrl: map['avatarUrl'] as String,
      fullName: map['fullName'] as String,
      phone: map['phone'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      lastLogin: map['lastLogin'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLogin'] as int)
          : null,
      totalPoints: map['totalPoints'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, username: $username, avatarUrl: $avatarUrl, fullName: $fullName, phone: $phone, createdAt: $createdAt, updatedAt: $updatedAt, lastLogin: $lastLogin, totalPoints: $totalPoints)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.username == username &&
        other.avatarUrl == avatarUrl &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.lastLogin == lastLogin &&
        other.totalPoints == totalPoints;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        username.hashCode ^
        avatarUrl.hashCode ^
        fullName.hashCode ^
        phone.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        lastLogin.hashCode ^
        totalPoints.hashCode;
  }

  // Phương thức để chuyển đổi từ Firestore DocumentSnapshot sang UserModel
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      username: data['username'],
      email: data['email'],
      avatarUrl: data['avatarUrl'],
      fullName: data['fullName'],
      phone: data['phone'],
      totalPoints: data['totalPoints'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastLogin: data['lastLogin'] != null
          ? (data['lastLogin'] as Timestamp).toDate()
          : null,
    );
  }
}
