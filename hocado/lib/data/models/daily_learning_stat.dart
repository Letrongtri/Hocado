// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DailyLearningStat {
  final String dlid; // 'uid_date'
  final String uid;
  final DateTime date; // Dấu thời gian cho ngày đó (thường là 00:00:00)
  final int totalMinutesStudied;
  final int totalCardsReviewed;
  final int totalCorrect;
  final int totalIncorrect;
  final int totalNewCardsLearned;
  // Cloud function: sau khi learning activity được tạo

  DailyLearningStat({
    required this.dlid,
    required this.uid,
    required this.date,
    required this.totalMinutesStudied,
    required this.totalCardsReviewed,
    required this.totalCorrect,
    required this.totalIncorrect,
    required this.totalNewCardsLearned,
  });

  DailyLearningStat copyWith({
    String? dlid,
    String? uid,
    DateTime? date,
    int? totalMinutesStudied,
    int? totalCardsReviewed,
    int? totalCorrect,
    int? totalIncorrect,
    int? totalNewCardsLearned,
  }) {
    return DailyLearningStat(
      dlid: dlid ?? this.dlid,
      uid: uid ?? this.uid,
      date: date ?? this.date,
      totalMinutesStudied: totalMinutesStudied ?? this.totalMinutesStudied,
      totalCardsReviewed: totalCardsReviewed ?? this.totalCardsReviewed,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalIncorrect: totalIncorrect ?? this.totalIncorrect,
      totalNewCardsLearned: totalNewCardsLearned ?? this.totalNewCardsLearned,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dlid': dlid,
      'uid': uid,
      'date': date,
      'totalMinutesStudied': totalMinutesStudied,
      'totalCardsReviewed': totalCardsReviewed,
      'totalCorrect': totalCorrect,
      'totalIncorrect': totalIncorrect,
      'totalNewCardsLearned': totalNewCardsLearned,
    };
  }

  factory DailyLearningStat.fromMap(Map<String, dynamic> map) {
    return DailyLearningStat(
      dlid: map['dlid'] as String,
      uid: map['uid'] as String,
      date: (map['date'] as Timestamp).toDate(),
      totalMinutesStudied: map['totalMinutesStudied'] as int,
      totalCardsReviewed: map['totalCardsReviewed'] as int,
      totalCorrect: map['totalCorrect'] as int,
      totalIncorrect: map['totalIncorrect'] as int,
      totalNewCardsLearned: map['totalNewCardsLearned'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyLearningStat.fromJson(String source) =>
      DailyLearningStat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DailyLearningStat(dlid: $dlid, uid: $uid, date: $date, totalMinutesStudied: $totalMinutesStudied, totalCardsReviewed: $totalCardsReviewed, totalCorrect: $totalCorrect, totalIncorrect: $totalIncorrect, totalNewCardsLearned: $totalNewCardsLearned)';
  }

  @override
  bool operator ==(covariant DailyLearningStat other) {
    if (identical(this, other)) return true;

    return other.dlid == dlid &&
        other.uid == uid &&
        other.date == date &&
        other.totalMinutesStudied == totalMinutesStudied &&
        other.totalCardsReviewed == totalCardsReviewed &&
        other.totalCorrect == totalCorrect &&
        other.totalIncorrect == totalIncorrect &&
        other.totalNewCardsLearned == totalNewCardsLearned;
  }

  @override
  int get hashCode {
    return dlid.hashCode ^
        uid.hashCode ^
        date.hashCode ^
        totalMinutesStudied.hashCode ^
        totalCardsReviewed.hashCode ^
        totalCorrect.hashCode ^
        totalIncorrect.hashCode ^
        totalNewCardsLearned.hashCode;
  }

  factory DailyLearningStat.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DailyLearningStat(
      dlid: data['dlid'] as String,
      uid: data['uid'] as String,
      date: (data['date'] as Timestamp).toDate(),
      totalMinutesStudied: data['totalMinutesStudied'] as int,
      totalCardsReviewed: data['totalCardsReviewed'] as int,
      totalCorrect: data['totalCorrect'] as int,
      totalIncorrect: data['totalIncorrect'] as int,
      totalNewCardsLearned: data['totalNewCardsLearned'] as int,
    );
  }
}
