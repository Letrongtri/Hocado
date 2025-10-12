// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserFlashcardProgress {
  final String uid;
  final String fid;

  final DateTime? lastReviewed;
  final DateTime? nextReview;
  final int reviewCount;
  final int correctCount;
  final double easeFactor;
  final int interval;
  // easeFactor:  hệ số dễ nhớ (dùng trong thuật toán SM-2) giá trị càng cao thì ôn tập càng giãn cách

  UserFlashcardProgress({
    required this.uid,
    required this.fid,
    this.lastReviewed,
    this.nextReview,
    required this.reviewCount,
    required this.correctCount,
    required this.easeFactor,
    required this.interval,
  });

  UserFlashcardProgress copyWith({
    String? uid,
    String? fid,
    DateTime? lastReviewed,
    DateTime? nextReview,
    int? reviewCount,
    int? correctCount,
    double? easeFactor,
    int? interval,
  }) {
    return UserFlashcardProgress(
      uid: uid ?? this.uid,
      fid: fid ?? this.fid,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      nextReview: nextReview ?? this.nextReview,
      reviewCount: reviewCount ?? this.reviewCount,
      correctCount: correctCount ?? this.correctCount,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'fid': fid,
      'lastReviewd': lastReviewed?.millisecondsSinceEpoch,
      'nextReview': nextReview?.millisecondsSinceEpoch,
      'reviewCount': reviewCount,
      'correctCount': correctCount,
      'easeFactor': easeFactor,
      'interval': interval,
    };
  }

  factory UserFlashcardProgress.fromMap(Map<String, dynamic> map) {
    return UserFlashcardProgress(
      uid: map['uid'] as String,
      fid: map['fid'] as String,
      lastReviewed: map['lastReviewed'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastReviewd'] as int)
          : null,
      nextReview: map['nextReview'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['nextReview'] as int)
          : null,
      reviewCount: map['reviewCount'] as int,
      correctCount: map['correctCount'] as int,
      easeFactor: map['easeFactor'] as double,
      interval: map['interval'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserFlashcardProgress.fromJson(String source) =>
      UserFlashcardProgress.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'UserFlashcardProgress(uid: $uid, fid: $fid, lastReviewd: $lastReviewed, nextReview: $nextReview, reviewCount: $reviewCount, correctCount: $correctCount, easeFactor: $easeFactor, interval: $interval)';
  }

  @override
  bool operator ==(covariant UserFlashcardProgress other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.fid == fid &&
        other.lastReviewed == lastReviewed &&
        other.nextReview == nextReview &&
        other.reviewCount == reviewCount &&
        other.correctCount == correctCount &&
        other.easeFactor == easeFactor &&
        other.interval == interval;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fid.hashCode ^
        lastReviewed.hashCode ^
        nextReview.hashCode ^
        reviewCount.hashCode ^
        correctCount.hashCode ^
        easeFactor.hashCode ^
        interval.hashCode;
  }

  factory UserFlashcardProgress.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserFlashcardProgress(
      uid: data['uid'] as String,
      fid: data['fid'] as String,
      lastReviewed: data['lastReviewed'] != null
          ? (data['lastReviewd'] as Timestamp).toDate()
          : null,
      nextReview: data['nextReview'] != null
          ? (data['nextReview'] as Timestamp).toDate()
          : null,
      reviewCount: data['reviewCount'] as int,
      correctCount: data['correctCount'] as int,
      easeFactor: data['easeFactor'] as double,
      interval: data['interval'] as int,
    );
  }
}
