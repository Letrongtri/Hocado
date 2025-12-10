// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Archievement {
  final String aid;
  final String name;
  final String description;
  final String type;
  final int requiredPoints;

  Archievement({
    required this.aid,
    required this.name,
    required this.description,
    required this.type,
    required this.requiredPoints,
  });

  Archievement copyWith({
    String? aid,
    String? name,
    String? description,
    String? type,
    int? requiredPoints,
  }) {
    return Archievement(
      aid: aid ?? this.aid,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      requiredPoints: requiredPoints ?? this.requiredPoints,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'aid': aid,
      'name': name,
      'description': description,
      'type': type,
      'requiredPoints': requiredPoints,
    };
  }

  factory Archievement.fromMap(Map<String, dynamic> map) {
    return Archievement(
      aid: map['aid'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      type: map['type'] as String,
      requiredPoints: map['requiredPoints'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Archievement.fromJson(String source) =>
      Archievement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Archievement(aid: $aid, name: $name, description: $description, type: $type, requiredPoints: $requiredPoints)';
  }

  @override
  bool operator ==(covariant Archievement other) {
    if (identical(this, other)) return true;

    return other.aid == aid &&
        other.name == name &&
        other.description == description &&
        other.type == type &&
        other.requiredPoints == requiredPoints;
  }

  @override
  int get hashCode {
    return aid.hashCode ^
        name.hashCode ^
        description.hashCode ^
        type.hashCode ^
        requiredPoints.hashCode;
  }

  factory Archievement.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Archievement(
      aid: data['aid'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      type: data['type'] as String,
      requiredPoints: data['requiredPoints'] as int,
    );
  }
}
