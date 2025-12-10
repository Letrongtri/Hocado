// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum QuestionTypes { flashcard, multipleChoice, written, trueFalse }

enum QuestionFormat { answerWithDefinition, answerWithTerm }

class LearningSettings {
  final List<String> questionTypes;
  final String questionFormat;
  final int defaultRounds;
  final bool studyStarredOnly;
  final bool shuffle;
  final DateTime updatedAt;

  LearningSettings({
    required this.questionTypes,
    required this.questionFormat,
    this.defaultRounds = 7,
    this.studyStarredOnly = false,
    this.shuffle = true,
    required this.updatedAt,
  });

  LearningSettings copyWith({
    List<String>? questionTypes,
    String? questionFormat,
    int? defaultRounds,
    bool? studyStarredOnly,
    bool? shuffle,
    DateTime? updatedAt,
  }) {
    return LearningSettings(
      questionTypes: questionTypes ?? this.questionTypes,
      questionFormat: questionFormat ?? this.questionFormat,
      defaultRounds: defaultRounds ?? this.defaultRounds,
      studyStarredOnly: studyStarredOnly ?? this.studyStarredOnly,
      shuffle: shuffle ?? this.shuffle,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questionTypes': questionTypes,
      'questionFormat': questionFormat,
      'defaultRounds': defaultRounds,
      'studyStarredOnly': studyStarredOnly,
      'shuffle': shuffle,
      'updatedAt': updatedAt,
    };
  }

  factory LearningSettings.fromMap(Map<String, dynamic> map) {
    return LearningSettings(
      questionTypes: List<String>.from(map['questionTypes']),
      questionFormat: map['questionFormat'] as String,
      defaultRounds: map['defaultRounds'] as int,
      studyStarredOnly: map['studyStarredOnly'] as bool,
      shuffle: map['shuffle'] as bool,
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LearningSettings.fromJson(String source) =>
      LearningSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LearningSettings(questionTypes: $questionTypes, questionFormat: $questionFormat, defaultRounds: $defaultRounds, studyStarredOnly: $studyStarredOnly, shuffle: $shuffle, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant LearningSettings other) {
    if (identical(this, other)) return true;

    return listEquals(other.questionTypes, questionTypes) &&
        other.questionFormat == questionFormat &&
        other.defaultRounds == defaultRounds &&
        other.studyStarredOnly == studyStarredOnly &&
        other.shuffle == shuffle;
  }

  @override
  int get hashCode => Object.hashAll([
    Object.hashAll(questionTypes),
    questionFormat,
    defaultRounds,
    studyStarredOnly,
    shuffle,
    updatedAt,
  ]);

  factory LearningSettings.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return LearningSettings(
      questionTypes: List<String>.from(data['questionTypes']),
      questionFormat: data['questionFormat'],
      defaultRounds: data['defaultRounds'] as int,
      studyStarredOnly: data['studyStarredOnly'] as bool,
      shuffle: data['shuffle'] as bool,
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory LearningSettings.empty() {
    return LearningSettings(
      questionTypes: [QuestionTypes.flashcard.name],
      questionFormat: QuestionFormat.answerWithDefinition.name,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toSharedPrefs() {
    return {
      'questionTypes': questionTypes,
      'questionFormat': questionFormat,
      'defaultRounds': defaultRounds,
      'studyStarredOnly': studyStarredOnly,
      'shuffle': shuffle,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory LearningSettings.fromSharedPrefs(String jsonString) {
    final Map<String, dynamic> map = jsonDecode(jsonString);

    return LearningSettings(
      questionTypes: List<String>.from(map['questionTypes'] ?? []),
      questionFormat: map['questionFormat'] ?? '',
      defaultRounds: map['defaultRounds'] ?? 1,
      studyStarredOnly: map['studyStarredOnly'] ?? false,
      shuffle: map['shuffle'] ?? false,
      updatedAt: DateTime.parse((map['updatedAt'] as String)),
    );
  }

  String toSharedPrefsString() {
    return jsonEncode(toSharedPrefs());
  }
}
