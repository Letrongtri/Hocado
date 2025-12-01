import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/services/services.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Đảm bảo Firebase đã khởi tạo vì đây là isolate riêng biệt
  // await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class NotificationMessagingService {
  final FirebaseMessaging _firebaseMessaging;
  final LocalNotificationService _localNotificationService;

  NotificationMessagingService({
    required FirebaseMessaging firebaseMessaging,
    LocalNotificationService? localNotificationService,
  }) : _firebaseMessaging = firebaseMessaging,
       _localNotificationService =
           localNotificationService ?? LocalNotificationService();

  // Xin quyền thông báo
  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> initialize() async {
    // Đăng ký background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.subscribeToTopic('daily_learners');

    // Lắng nghe Foreground message (Tách ra khỏi requestPermission)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = NotificationMessage.fromRemoteMessage(message);

      // Hiển thị Local Notification
      if (notification.title.isNotEmpty || notification.message.isNotEmpty) {
        _localNotificationService.showNotification(
          id: notification.nid.hashCode,
          title: notification.title,
          body: notification.message,
          payload: jsonEncode(notification.metadata ?? {}),
        );
      }
    });
  }

  // Lấy FCM Token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Stream lắng nghe tin nhắn khi app đang mở (Foreground)
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  // Stream lắng nghe khi user ấn vào thông báo để mở app (Background -> Foreground)
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  // Kiểm tra tin nhắn mở app từ trạng thái Terminated
  Future<RemoteMessage?> getInitialMessage() async {
    return await _firebaseMessaging.getInitialMessage();
  }
}
