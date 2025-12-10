import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

final notificationMessagingServiceProvider = Provider((ref) {
  final firebaseMessaging = ref.read(firebaseMessagingProvider);
  return NotificationMessagingService(firebaseMessaging: firebaseMessaging);
});

final localNotificationServiceProvider = Provider((ref) {
  return LocalNotificationService();
});

final notificationServiceProvider = Provider((ref) {
  final firestore = ref.read(firestoreProvider);
  return NotificationService(firestore: firestore);
});

final notificationRepositoryProvider = Provider((ref) {
  final notificationMessagingService = ref.read(
    notificationMessagingServiceProvider,
  );
  final localNotificationService = ref.read(localNotificationServiceProvider);
  final userService = ref.read(userServiceProvider);
  final notificationService = ref.read(notificationServiceProvider);
  return NotificationRepository(
    fbService: notificationMessagingService,
    localService: localNotificationService,
    userService: userService,
    notificationService: notificationService,
  );
});

final notificationViewModelProvider =
    AsyncNotifierProvider<NotificationViewModel, List<NotificationMessage>>(
      NotificationViewModel.new,
    );

final notificationCountProvider = StreamProvider.family<int, String>(
  (ref, uid) {
    final notificationRepository = ref.watch(notificationRepositoryProvider);
    return notificationRepository.notificationCountStream(uid);
  },
);
