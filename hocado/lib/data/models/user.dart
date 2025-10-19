// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:hocado/data/models/saved_deck.dart';

class User {
  final String uid;
  final String email;
  final String? avatarUrl;
  final String fullName;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;
  final int totalPoints;
  final List<SavedDeck>? saveDecks;

  // mật khẩu không lưu trực tiếp trong model này

  User({
    required this.uid,
    required this.email,
    this.avatarUrl,
    required this.fullName,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLogin,
    required this.totalPoints,
    this.saveDecks,
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
    int? totalPoints,
    List<SavedDeck>? saveDecks,
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
      totalPoints: totalPoints ?? this.totalPoints,
      saveDecks: saveDecks ?? this.saveDecks,
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
      'totalPoints': totalPoints,
      'saveDecks': saveDecks?.map((x) => x.toMap()).toList(),
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
      totalPoints: map['totalPoints'] as int,
      saveDecks: map['saveDecks'] != null
          ? List<SavedDeck>.from(
              (map['saveDecks'] as List<int>).map<SavedDeck?>(
                (x) => SavedDeck.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, avatarUrl: $avatarUrl, fullName: $fullName, phone: $phone, createdAt: $createdAt, updatedAt: $updatedAt, lastLogin: $lastLogin, totalPoints: $totalPoints, saveDecks: $saveDecks)';
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
        other.totalPoints == totalPoints &&
        listEquals(other.saveDecks, saveDecks);
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
        totalPoints.hashCode ^
        saveDecks.hashCode;
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
      totalPoints: data['totalPoints'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastLogin: data['lastLogin'] != null
          ? (data['lastLogin'] as Timestamp).toDate()
          : null,
      saveDecks: data['saveDecks'] != null
          ? List<SavedDeck>.from(
              (data['saveDecks'] as List<int>).map<SavedDeck?>(
                (x) => SavedDeck.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }
}
