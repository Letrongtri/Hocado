// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum LearningActivityType { studySession, createdDeck, savedDeck, archievement }

class LearningActivity {
  final String laid; // 'uid_timestamp'
  final String uid;
  final DateTime timestamp;
  final String type;
  final String? did;
  final String? deckName;
  final int? durationMinutes;
  final int? cardsReviewed;
  final int? cardsCorrect;
  final int? cardsIncorrect;
  final int? newCardsLearned;
  // lưu sau khi 1 sự kiện kết thúc

  LearningActivity({
    required this.laid,
    required this.uid,
    required this.timestamp,
    required this.type,
    this.did,
    this.deckName,
    this.durationMinutes,
    this.cardsReviewed,
    this.cardsCorrect,
    this.cardsIncorrect,
    this.newCardsLearned,
  });

  LearningActivity copyWith({
    String? laid,
    String? uid,
    DateTime? timestamp,
    String? type,
    String? did,
    String? deckName,
    int? durationMinutes,
    int? cardsReviewed,
    int? cardsCorrect,
    int? cardsIncorrect,
    int? newCardsLearned,
  }) {
    return LearningActivity(
      laid: laid ?? this.laid,
      uid: uid ?? this.uid,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      did: did ?? this.did,
      deckName: deckName ?? this.deckName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      cardsReviewed: cardsReviewed ?? this.cardsReviewed,
      cardsCorrect: cardsCorrect ?? this.cardsCorrect,
      cardsIncorrect: cardsIncorrect ?? this.cardsIncorrect,
      newCardsLearned: newCardsLearned ?? this.newCardsLearned,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'laid': laid,
      'uid': uid,
      'timestamp': timestamp,
      'type': type,
      'did': did,
      'deckName': deckName,
      'durationMinutes': durationMinutes,
      'cardsReviewed': cardsReviewed,
      'cardsCorrect': cardsCorrect,
      'cardsIncorrect': cardsIncorrect,
      'newCardsLearned': newCardsLearned,
    };
  }

  factory LearningActivity.fromMap(Map<String, dynamic> map) {
    return LearningActivity(
      laid: map['laid'] as String,
      uid: map['uid'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      type: map['type'] as String,
      did: map['did'] != null ? map['did'] as String : null,
      deckName: map['deckName'] != null ? map['deckName'] as String : null,
      durationMinutes: map['durationMinutes'] != null
          ? map['durationMinutes'] as int
          : null,
      cardsReviewed: map['cardsReviewed'] != null
          ? map['cardsReviewed'] as int
          : null,
      cardsCorrect: map['cardsCorrect'] != null
          ? map['cardsCorrect'] as int
          : null,
      cardsIncorrect: map['cardsIncorrect'] != null
          ? map['cardsIncorrect'] as int
          : null,
      newCardsLearned: map['newCardsLearned'] != null
          ? map['newCardsLearned'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LearningActivity.fromJson(String source) =>
      LearningActivity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LearningActivity(laid: $laid, uid: $uid, timestamp: $timestamp, type: $type, did: $did, deckName: $deckName, durationMinutes: $durationMinutes, cardsReviewed: $cardsReviewed, cardsCorrect: $cardsCorrect, cardsIncorrect: $cardsIncorrect, newCardsLearned: $newCardsLearned)';
  }

  @override
  bool operator ==(covariant LearningActivity other) {
    if (identical(this, other)) return true;

    return other.laid == laid &&
        other.uid == uid &&
        other.timestamp == timestamp &&
        other.type == type &&
        other.did == did &&
        other.deckName == deckName &&
        other.durationMinutes == durationMinutes &&
        other.cardsReviewed == cardsReviewed &&
        other.cardsCorrect == cardsCorrect &&
        other.cardsIncorrect == cardsIncorrect &&
        other.newCardsLearned == newCardsLearned;
  }

  @override
  int get hashCode {
    return laid.hashCode ^
        uid.hashCode ^
        timestamp.hashCode ^
        type.hashCode ^
        did.hashCode ^
        deckName.hashCode ^
        durationMinutes.hashCode ^
        cardsReviewed.hashCode ^
        cardsCorrect.hashCode ^
        cardsIncorrect.hashCode ^
        newCardsLearned.hashCode;
  }

  factory LearningActivity.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LearningActivity(
      laid: data['laid'] as String,
      uid: data['uid'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: data['type'] as String,
      did: data['did'] != null ? data['did'] as String : null,
      deckName: data['deckName'] != null ? data['deckName'] as String : null,
      durationMinutes: data['durationMinutes'] != null
          ? data['durationMinutes'] as int
          : null,
      cardsReviewed: data['cardsReviewed'] != null
          ? data['cardsReviewed'] as int
          : null,
      cardsCorrect: data['cardsCorrect'] != null
          ? data['cardsCorrect'] as int
          : null,
      cardsIncorrect: data['cardsIncorrect'] != null
          ? data['cardsIncorrect'] as int
          : null,
      newCardsLearned: data['newCardsLearned'] != null
          ? data['newCardsLearned'] as int
          : null,
    );
  }
}
