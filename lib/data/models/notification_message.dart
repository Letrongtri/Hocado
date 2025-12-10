// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

enum NotificationType {
  system, // Thông báo hệ thông (bảo trì, update, ...)
  reminder, // Nhắc nhở ôn tập
  achievement, // chúc mừng đạt danh hiệu, hoàn thành bộ thẻ,...
  social, // follow, share deck
  promotion, // giới thiệu gói/ tính năng pro, ...
}

class NotificationMessage {
  final String nid;
  final String uid;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  NotificationMessage({
    required this.nid,
    required this.uid,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.metadata,
  });

  NotificationMessage copyWith({
    String? nid,
    String? uid,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationMessage(
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
      'type': _parseTypeToString(type),
      'isRead': isRead,
      'createdAt': createdAt,
      'metadata': metadata,
    };
  }

  factory NotificationMessage.fromMap(Map<String, dynamic> map) {
    return NotificationMessage(
      nid: map['nid'] as String,
      uid: map['uid'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      type: map['type'] as NotificationType,
      isRead: map['isRead'] as bool,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationMessage.fromJson(String source) =>
      NotificationMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notification(nid: $nid, uid: $uid, title: $title, message: $message, type: $type, isRead: $isRead, createdAt: $createdAt, metadata: $metadata)';
  }

  @override
  bool operator ==(covariant NotificationMessage other) {
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

  factory NotificationMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return NotificationMessage(
      nid: data['nid'] as String,
      uid: data['uid'] as String,
      title: data['title'] as String,
      message: data['message'] as String,
      type: _parseType(data['type'] as String),
      isRead: data['isRead'] != null ? data['isRead'] as bool : false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  // Factory để parse từ Firebase RemoteMessage
  factory NotificationMessage.fromRemoteMessage(
    RemoteMessage message, {
    String? currentUid,
  }) {
    final data = message.data;
    return NotificationMessage(
      nid: data['nid'] ?? '',
      uid: currentUid ?? '',
      title: message.notification?.title ?? data['title'] ?? 'Thông báo mới',
      message: message.notification?.body ?? data['message'] ?? '',
      type: _parseType(data['type']),
      createdAt: message.sentTime ?? DateTime.now(),
      metadata: data,
    );
  }

  // Helper chuyển đổi String sang Enum
  static NotificationType _parseType(String? typeStr) {
    switch (typeStr) {
      case 'reminder':
        return NotificationType.reminder;
      case 'achievement':
        return NotificationType.achievement;
      case 'social':
        return NotificationType.social;
      case 'promotion':
        return NotificationType.promotion;
      default:
        return NotificationType.system;
    }
  }

  // Helper chuyển đổi Enum sang String
  static String _parseTypeToString(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return 'reminder';
      case NotificationType.achievement:
        return 'achievement';
      case NotificationType.social:
        return 'social';
      case NotificationType.promotion:
        return 'promotion';
      default:
        return 'system';
    }
  }

  // Helper check xem có cần điều hướng đặc biệt không
  bool get hasDeepLink => metadata != null && metadata!.containsKey('route');
}
