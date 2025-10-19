// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Deck {
  final String did;
  final String uid;
  final String name;
  final String description;
  final String? thumbnailUrl;
  final bool isPublic;
  final int totalCards;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String>? tagIds;

  Deck({
    required this.did,
    required this.uid,
    required this.name,
    required this.description,
    this.thumbnailUrl,
    this.isPublic = false,
    required this.totalCards,
    required this.createdAt,
    required this.updatedAt,
    this.tagIds,
  });

  Deck copyWith({
    String? did,
    String? uid,
    String? name,
    String? description,
    String? thumbnailUrl,
    bool? isPublic,
    int? totalCards,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tagIds,
  }) {
    return Deck(
      did: did ?? this.did,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isPublic: isPublic ?? this.isPublic,
      totalCards: totalCards ?? this.totalCards,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tagIds: tagIds ?? this.tagIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'did': did,
      'uid': uid,
      'name': name,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'isPublic': isPublic,
      'totalCards': totalCards,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'tagIds': tagIds,
    };
  }

  factory Deck.fromMap(Map<String, dynamic> map) {
    return Deck(
      did: map['did'] as String,
      uid: map['uid'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      thumbnailUrl: map['thumbnailUrl'] != null
          ? map['thumbnailUrl'] as String
          : null,
      isPublic: map['isPublic'] as bool,
      totalCards: map['totalCards'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      tagIds: map['tagIds'] != null
          ? List<String>.from(map['tagIds'] as List<String>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Deck.fromJson(String source) =>
      Deck.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Deck(did: $did, uid: $uid, name: $name, description: $description, thumbnailUrl: $thumbnailUrl, isPublic: $isPublic, totalCards: $totalCards, createdAt: $createdAt, updatedAt: $updatedAt, tagIds: $tagIds)';
  }

  @override
  bool operator ==(covariant Deck other) {
    if (identical(this, other)) return true;

    return other.did == did &&
        other.uid == uid &&
        other.name == name &&
        other.description == description &&
        other.thumbnailUrl == thumbnailUrl &&
        other.isPublic == isPublic &&
        other.totalCards == totalCards &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        listEquals(other.tagIds, tagIds);
  }

  @override
  int get hashCode {
    return did.hashCode ^
        uid.hashCode ^
        name.hashCode ^
        description.hashCode ^
        thumbnailUrl.hashCode ^
        isPublic.hashCode ^
        totalCards.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        tagIds.hashCode;
  }

  factory Deck.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Deck(
      did: doc.id,
      uid: data['uid'],
      name: data['name'],
      description: data['description'],
      thumbnailUrl: data['thumbnailUrl'],
      isPublic: data['isPublic'],
      totalCards: data['totalCards'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      tagIds: List<String>.from(data['tagIds'] as List<String>),
    );
  }

  factory Deck.empty() {
    return Deck(
      did: Uuid().v4(),
      uid: '',
      name: '',
      description: '',
      totalCards: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
