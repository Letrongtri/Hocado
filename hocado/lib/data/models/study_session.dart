// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class StudySession {
  final String sid;
  final String uid;
  final String did;
  final DateTime start;
  final DateTime? end;
  final int totalCards;
  final int correctCards;
  final int incorrectCards;
  final int skippedCards;
  final String mode; // Ex: review/learn/test
  final int totalTime; // seconds

  StudySession({
    required this.sid,
    required this.uid,
    required this.did,
    required this.start,
    this.end,
    required this.totalCards,
    required this.correctCards,
    required this.incorrectCards,
    required this.skippedCards,
    required this.mode,
    required this.totalTime,
  });

  StudySession copyWith({
    String? sid,
    String? uid,
    String? did,
    DateTime? start,
    DateTime? end,
    int? totalCards,
    int? correctCards,
    int? incorrectCards,
    int? skippedCards,
    String? mode,
    int? totalTime,
  }) {
    return StudySession(
      sid: sid ?? this.sid,
      uid: uid ?? this.uid,
      did: did ?? this.did,
      start: start ?? this.start,
      end: end ?? this.end,
      totalCards: totalCards ?? this.totalCards,
      correctCards: correctCards ?? this.correctCards,
      incorrectCards: incorrectCards ?? this.incorrectCards,
      skippedCards: skippedCards ?? this.skippedCards,
      mode: mode ?? this.mode,
      totalTime: totalTime ?? this.totalTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sid': sid,
      'uid': uid,
      'did': did,
      'start': start,
      'end': end,
      'totalCards': totalCards,
      'correctCards': correctCards,
      'incorrectCards': incorrectCards,
      'skippedCards': skippedCards,
      'mode': mode,
      'totalTime': totalTime,
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      sid: map['sid'] as String,
      uid: map['uid'] as String,
      did: map['did'] as String,
      start: (map['start'] as Timestamp).toDate(),
      end: map['end'] != null ? (map['end'] as Timestamp).toDate() : null,
      totalCards: map['totalCards'] as int,
      correctCards: map['correctCards'] as int,
      incorrectCards: map['incorrectCards'] as int,
      skippedCards: map['skippedCards'] as int,
      mode: map['mode'] as String,
      totalTime: map['totalTime'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudySession.fromJson(String source) =>
      StudySession.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StudySession(sid: $sid, uid: $uid, did: $did, start: $start, end: $end, totalCards: $totalCards, correctCards: $correctCards, incorrectCards: $incorrectCards, skippedCards: $skippedCards, mode: $mode, totalTime: $totalTime)';
  }

  @override
  bool operator ==(covariant StudySession other) {
    if (identical(this, other)) return true;

    return other.sid == sid &&
        other.uid == uid &&
        other.did == did &&
        other.start == start &&
        other.end == end &&
        other.totalCards == totalCards &&
        other.correctCards == correctCards &&
        other.incorrectCards == incorrectCards &&
        other.skippedCards == skippedCards &&
        other.mode == mode &&
        other.totalTime == totalTime;
  }

  @override
  int get hashCode {
    return sid.hashCode ^
        uid.hashCode ^
        did.hashCode ^
        start.hashCode ^
        end.hashCode ^
        totalCards.hashCode ^
        correctCards.hashCode ^
        incorrectCards.hashCode ^
        skippedCards.hashCode ^
        mode.hashCode ^
        totalTime.hashCode;
  }

  factory StudySession.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return StudySession(
      sid: data['sid'] as String,
      uid: data['uid'] as String,
      did: data['did'] as String,
      start: (data['start'] as Timestamp).toDate(),
      end: data['end'] != null ? (data['end'] as Timestamp).toDate() : null,
      totalCards: data['totalCards'] as int,
      correctCards: data['correctCards'] as int,
      incorrectCards: data['incorrectCards'] as int,
      skippedCards: data['skippedCards'] as int,
      mode: data['mode'] as String,
      totalTime: data['totalTime'] as int,
    );
  }
}
