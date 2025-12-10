// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Tag {
  final String tid;
  final String name;

  Tag({
    required this.tid,
    required this.name,
  });

  Tag copyWith({
    String? tid,
    String? name,
  }) {
    return Tag(
      tid: tid ?? this.tid,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tid': tid,
      'name': name,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      tid: map['tid'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) =>
      Tag.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Tag(tid: $tid, name: $name)';

  @override
  bool operator ==(covariant Tag other) {
    if (identical(this, other)) return true;

    return other.tid == tid && other.name == name;
  }

  @override
  int get hashCode => tid.hashCode ^ name.hashCode;

  factory Tag.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Tag(
      tid: data['tid'],
      name: data['name'],
    );
  }
}
