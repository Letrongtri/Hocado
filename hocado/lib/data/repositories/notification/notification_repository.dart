import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/services/services.dart';

class NotificationRepository {
  final NotificationMessagingService _fbService;
  final LocalNotificationService _localService;
  final UserService _userService;
  final NotificationService _notificationService;

  NotificationRepository({
    required NotificationMessagingService fbService,
    required LocalNotificationService localService,
    required UserService userService,
    required NotificationService notificationService,
  }) : _fbService = fbService,
       _localService = localService,
       _userService = userService,
       _notificationService = notificationService;

  Future<void> initialize(String uid) async {
    await _localService.init();

    await _fbService.initialize();
    await _fbService.requestPermission();

    final token = await _fbService.getToken();
    await _userService.saveFCMToken(uid, token!);
  }

  // Stream xử lý khi user bấm vào thông báo (từ cả Background lẫn Foreground)
  Stream<NotificationMessage> get interactionStream {
    // 1. Stream từ Firebase (Background -> App)
    final backgroundStream = _fbService.onMessageOpenedApp.map(
      (msg) => NotificationMessage.fromRemoteMessage(msg),
    );
    return backgroundStream;
  }

  Stream<NotificationMessage> get onLocalNotificationTap {
    return _localService.onNotificationClick.map((payload) {
      final data = payload != null ? jsonDecode(payload) : <String, dynamic>{};
      return NotificationMessage(
        nid: 'local_tap',
        uid: '',
        title: '',
        message: '',
        type: NotificationType.system,
        createdAt: DateTime.now(),
        metadata: data,
      );
    });
  }

  Future<NotificationMessage?> getInitialMessage() async {
    final msg = await _fbService.getInitialMessage();
    if (msg != null) {
      return NotificationMessage.fromRemoteMessage(msg);
    }
    return null;
  }

  Stream<NotificationMessage> get onNewMessageStream {
    return _fbService.onMessage.map(
      (msg) => NotificationMessage.fromRemoteMessage(msg),
    );
  }

  // CRUD
  Future<List<NotificationMessage>> fetchNotifications(
    String uid, {
    int limit = 50,
  }) async {
    try {
      final messages = await _notificationService.fetchNotifications(
        uid,
        limit: limit,
      );

      return messages
          .map((doc) => NotificationMessage.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> deleteNotification(String uid, String notificationId) async {
    try {
      await _notificationService.deleteNotification(uid, notificationId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteAllNotifications(String uid) async {
    try {
      await _notificationService.deleteAllNotifications(uid);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> markNotificationAsRead(String uid, String notificationId) async {
    try {
      await _notificationService.markNotificationAsRead(uid, notificationId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> markAllNotificationsAsRead(String uid) async {
    try {
      await _notificationService.markAllNotificationsAsRead(uid);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> createNotification(NotificationMessage notification) async {
    try {
      await _notificationService.createNotification(notification.toMap());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Stream<int> notificationCountStream(String? uid) {
    if (uid == null) {
      return Stream.value(0);
    }
    return _notificationService.getUnreadCountStream(uid);
  }
}
