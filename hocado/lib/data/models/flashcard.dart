// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Flashcard {
  final String fid;
  final String did;
  final String front;
  final String back;
  final String? frontImageUrl;
  final String? backImageUrl;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  Flashcard({
    required this.fid,
    required this.did,
    required this.front,
    required this.back,
    this.frontImageUrl,
    this.backImageUrl,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  Flashcard copyWith({
    String? fid,
    String? did,
    String? front,
    String? back,
    String? frontImageUrl,
    String? backImageUrl,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Flashcard(
      fid: fid ?? this.fid,
      did: did ?? this.did,
      front: front ?? this.front,
      back: back ?? this.back,
      frontImageUrl: frontImageUrl ?? this.frontImageUrl,
      backImageUrl: backImageUrl ?? this.backImageUrl,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fid': fid,
      'did': did,
      'front': front,
      'back': back,
      'frontImageUrl': frontImageUrl,
      'backImageUrl': backImageUrl,
      'note': note,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      fid: map['fid'] as String,
      did: map['did'] as String,
      front: map['front'] as String,
      back: map['back'] as String,
      frontImageUrl: map['frontImageUrl'] != null
          ? map['frontImageUrl'] as String
          : null,
      backImageUrl: map['backImageUrl'] != null
          ? map['backImageUrl'] as String
          : null,
      note: map['note'] != null ? map['note'] as String : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Flashcard.fromJson(String source) =>
      Flashcard.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Flashcard(fid: $fid, did: $did, front: $front, back: $back, frontImageUrl: $frontImageUrl, backImageUrl: $backImageUrl, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Flashcard other) {
    if (identical(this, other)) return true;

    return other.fid == fid &&
        other.did == did &&
        other.front == front &&
        other.back == back &&
        other.frontImageUrl == frontImageUrl &&
        other.backImageUrl == backImageUrl &&
        other.note == note &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return fid.hashCode ^
        did.hashCode ^
        front.hashCode ^
        back.hashCode ^
        frontImageUrl.hashCode ^
        backImageUrl.hashCode ^
        note.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  factory Flashcard.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Flashcard(
      fid: data['fid'],
      did: data['did'],
      front: data['front'],
      back: data['back'],
      frontImageUrl: data['frontImageUrl'],
      backImageUrl: data['backImageUrl'],
      note: data['note'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory Flashcard.empty() {
    return Flashcard(
      fid: Uuid().v4(),
      did: '',
      front: '',
      back: '',
      note: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
