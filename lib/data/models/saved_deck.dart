// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SavedDeck {
  final String did;
  final DateTime savedAt;

  final String uid;
  final String name;
  final String description;
  final String? thumbnailUrl;
  final List<String>? searchIndex;

  SavedDeck({
    required this.did,
    required this.savedAt,

    required this.uid,
    required this.name,
    required this.description,
    this.thumbnailUrl,
    this.searchIndex,
  });

  SavedDeck copyWith({
    String? did,
    DateTime? savedAt,
    String? uid,
    String? name,
    String? description,
    String? thumbnailUrl,
    List<String>? searchIndex,
  }) {
    return SavedDeck(
      did: did ?? this.did,
      savedAt: savedAt ?? this.savedAt,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      searchIndex: searchIndex ?? this.searchIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'did': did,
      'savedAt': savedAt,
      'uid': uid,
      'name': name,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'searchIndex': searchIndex,
    };
  }

  factory SavedDeck.fromMap(Map<String, dynamic> map) {
    return SavedDeck(
      did: map['did'] as String,
      savedAt: (map['savedAt'] as Timestamp).toDate(),
      uid: map['uid'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      thumbnailUrl: map['thumbnailUrl'] != null
          ? map['thumbnailUrl'] as String
          : null,
      searchIndex: map['searchIndex'] != null
          ? List<String>.from(map['searchIndex'] ?? [])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedDeck.fromJson(String source) =>
      SavedDeck.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SavedDeck(did: $did, savedAt: $savedAt,  uid: $uid, name: $name, description: $description, thumbnailUrl: $thumbnailUrl, searchIndex: $searchIndex)';

  @override
  bool operator ==(covariant SavedDeck other) {
    if (identical(this, other)) return true;

    return other.did == did &&
        other.savedAt == savedAt &&
        other.uid == uid &&
        other.name == name &&
        other.description == description &&
        other.thumbnailUrl == thumbnailUrl;
  }

  @override
  int get hashCode {
    return did.hashCode ^
        savedAt.hashCode ^
        uid.hashCode ^
        name.hashCode ^
        description.hashCode ^
        thumbnailUrl.hashCode;
  }

  factory SavedDeck.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return SavedDeck(
      did: data['did'],
      savedAt: (data['savedAt'] as Timestamp).toDate(),
      uid: data['uid'],
      name: data['name'],
      description: data['description'],
      thumbnailUrl: data['thumbnailUrl'],
      searchIndex: data['searchIndex'] != null
          ? List<String>.from(data['searchIndex'] ?? [])
          : null,
    );
  }
}
