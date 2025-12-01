import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Stream để UI hoặc Router lắng nghe khi user tap vào thông báo
  final StreamController<String?> _onNotificationClick =
      StreamController<String?>.broadcast();
  Stream<String?> get onNotificationClick => _onNotificationClick.stream;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'com.letrongtri.hocado',
    'Hocado',
    description: 'Thông báo từ Hocado',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('hocado_noti_sound'),
  );

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/hocado_icon');
    const DarwinInitializationSettings isoSettings =
        DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: isoSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Khi user tap vào thông báo, đẩy payload vào stream
        _onNotificationClick.add(response.payload);
      },
    );

    // Yêu cầu quyền trên android 13+
    _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // Yêu cầu quyền trên iOS
    _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/hocado_icon',
      sound: channel.sound,
    );

    // cho ios
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(id, title, body, details, payload: payload);
  }
}
