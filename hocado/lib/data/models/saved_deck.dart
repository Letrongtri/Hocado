// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SavedDeck {
  final String deckId;
  final DocumentReference deckRef;
  final DateTime savedAt;

  SavedDeck({
    required this.deckId,
    required this.deckRef,
    required this.savedAt,
  });

  SavedDeck copyWith({
    String? deckId,
    DocumentReference? deckRef,
    DateTime? savedAt,
  }) {
    return SavedDeck(
      deckId: deckId ?? this.deckId,
      deckRef: deckRef ?? this.deckRef,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deckId': deckId,
      'deckRef': deckRef,
      'savedAt': savedAt.millisecondsSinceEpoch,
    };
  }

  factory SavedDeck.fromMap(Map<String, dynamic> map) {
    return SavedDeck(
      deckId: map['deckId'] as String,
      deckRef: map['deckRef'],
      savedAt: DateTime.fromMillisecondsSinceEpoch(map['savedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedDeck.fromJson(String source) =>
      SavedDeck.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SavedDeck(deckId: $deckId, deckRef: $deckRef, savedAt: $savedAt)';

  @override
  bool operator ==(covariant SavedDeck other) {
    if (identical(this, other)) return true;

    return other.deckId == deckId &&
        other.deckRef == deckRef &&
        other.savedAt == savedAt;
  }

  @override
  int get hashCode => deckId.hashCode ^ deckRef.hashCode ^ savedAt.hashCode;

  factory SavedDeck.fromFirestore(Map<String, dynamic> data, String id) {
    return SavedDeck(
      deckId: data['deckId'] ?? id,
      deckRef: data['deckRef'],
      savedAt: (data['savedAt'] as Timestamp).toDate(),
    );
  }
}
