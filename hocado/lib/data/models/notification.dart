// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Notification {
  final String nid;
  final String uid;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  Notification({
    required this.nid,
    required this.uid,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.metadata,
  });

  Notification copyWith({
    String? nid,
    String? uid,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return Notification(
      nid: nid ?? this.nid,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nid': nid,
      'uid': uid,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt,
      'metadata': metadata,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      nid: map['nid'] as String,
      uid: map['uid'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      type: map['type'] as String,
      isRead: map['isRead'] as bool,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notification(nid: $nid, uid: $uid, title: $title, message: $message, type: $type, isRead: $isRead, createdAt: $createdAt, metadata: $metadata)';
  }

  @override
  bool operator ==(covariant Notification other) {
    if (identical(this, other)) return true;

    return other.nid == nid &&
        other.uid == uid &&
        other.title == title &&
        other.message == message &&
        other.type == type &&
        other.isRead == isRead &&
        other.createdAt == createdAt &&
        mapEquals(other.metadata, metadata);
  }

  @override
  int get hashCode {
    return nid.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        message.hashCode ^
        type.hashCode ^
        isRead.hashCode ^
        createdAt.hashCode ^
        metadata.hashCode;
  }

  factory Notification.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Notification(
      nid: data['nid'] as String,
      uid: data['uid'] as String,
      title: data['title'] as String,
      message: data['message'] as String,
      type: data['type'] as String,
      isRead: data['isRead'] as bool,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map<String, dynamic>)
          : null,
    );
  }
}
