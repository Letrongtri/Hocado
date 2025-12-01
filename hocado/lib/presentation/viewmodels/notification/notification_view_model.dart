import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';

class NotificationViewModel extends AsyncNotifier<List<NotificationMessage>> {
  NotificationRepository get _notificationRepository => ref.read(
    notificationRepositoryProvider,
  );
  fb_auth.User? get _currentUser => ref.read(currentUserProvider);

  int get unreadCount => state.value?.where((e) => !e.isRead).length ?? 0;

  @override
  FutureOr<List<NotificationMessage>> build() async {
    if (_currentUser == null) return [];
    await _notificationRepository.initialize(_currentUser!.uid);

    // Lắng nghe tin nhắn mới (Foreground) để tự động thêm vào list hiển thị
    final subscription = _notificationRepository.onNewMessageStream.listen((
      newMessage,
    ) {
      _addNewMessageToState(newMessage);
    });
    ref.onDispose(() => subscription.cancel());

    return await _notificationRepository.fetchNotifications(_currentUser!.uid);
  }

  void _addNewMessageToState(NotificationMessage message) {
    final currentState = state.value ?? [];
    state = AsyncData([message, ...currentState]);
  }

  Future<void> refresh() async {
    if (_currentUser == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _notificationRepository.fetchNotifications(_currentUser!.uid),
    );
  }

  void setupInteractedMessage(Function(NotificationMessage) onNavigate) async {
    // 1. Check Initial Message (Terminated)
    final initialMsg = await _notificationRepository.getInitialMessage();
    if (initialMsg != null) onNavigate(initialMsg);

    // 2. Listen Firebase Interacted (Background)
    _notificationRepository.interactionStream.listen((message) {
      onNavigate(message);
    });

    // 3. Listen Local Notification Tap (Foreground)
    _notificationRepository.onLocalNotificationTap.listen((message) {
      onNavigate(message);
    });
  }

  Future<void> deleteNotification(String notificationId) async {
    final uid = _currentUser?.uid;
    if (uid == null) return;

    final current = state.value;
    if (current == null) return;

    final idx = current.indexWhere((e) => e.nid == notificationId);
    if (idx == -1) return;

    try {
      state = AsyncData(current.where((e) => e.nid != notificationId).toList());

      await _notificationRepository.deleteNotification(uid, notificationId);
    } catch (e) {
      throw Exception("Could not delete notification from database");
    }
  }

  Future<void> deleteAllNotifications() async {
    final uid = _currentUser?.uid;
    if (uid == null) return;

    final current = state.value;
    if (current == null || current.isEmpty) return;

    try {
      state = AsyncData([]);
      await _notificationRepository.deleteAllNotifications(uid);
    } catch (e) {
      state = AsyncData(current);
      throw Exception("Could not delete all notifications from database");
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final uid = _currentUser?.uid;
    if (uid == null) return;

    final current = state.value;
    if (current == null) return;

    final idx = current.indexWhere((e) => e.nid == notificationId);
    if (idx == -1) return;

    try {
      final updatedList = [...current];
      updatedList[idx] = updatedList[idx].copyWith(isRead: true);

      state = AsyncData(updatedList);

      await _notificationRepository.markNotificationAsRead(uid, notificationId);
    } catch (e) {
      state = AsyncData(current);
      throw Exception("Could not mark notification as read from database");
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    final uid = _currentUser?.uid;
    if (uid == null) return;

    final current = state.value;
    if (current == null || current.isEmpty) return;

    try {
      final updatedList = [...current];
      for (var i = 0; i < updatedList.length; i++) {
        updatedList[i] = updatedList[i].copyWith(isRead: true);
      }

      state = AsyncData(updatedList);

      await _notificationRepository.markAllNotificationsAsRead(uid);
    } catch (e) {
      state = AsyncData(current);
      throw Exception("Could not mark all notifications as read from database");
    }
  }
}
