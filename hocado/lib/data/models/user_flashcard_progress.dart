// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserFlashcardProgress {
  final String uid;
  final String fid;

  final bool isStarred;
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
    this.isStarred = false,
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
    bool? isStarred,
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
      isStarred: isStarred ?? this.isStarred,
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
      'isStarred': isStarred,
      'lastReviewd': lastReviewed,
      'nextReview': nextReview,
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
      isStarred: map['isStarred'] as bool,
      lastReviewed: map['lastReviewed'] != null
          ? (map['lastReviewed'] as Timestamp).toDate()
          : null,
      nextReview: map['nextReview'] != null
          ? (map['nextReview'] as Timestamp).toDate()
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
    return 'UserFlashcardProgress(uid: $uid, fid: $fid, isStarred: $isStarred lastReviewd: $lastReviewed, nextReview: $nextReview, reviewCount: $reviewCount, correctCount: $correctCount, easeFactor: $easeFactor, interval: $interval)';
  }

  @override
  bool operator ==(covariant UserFlashcardProgress other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.fid == fid &&
        other.isStarred == isStarred &&
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
        isStarred.hashCode ^
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
      isStarred: data['isStarred'] as bool,
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
