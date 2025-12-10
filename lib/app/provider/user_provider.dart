import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final firestore = ref.read(firestoreProvider);
  return UserService(firestore: firestore);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userService = ref.read(userServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return UserRepositoryImpl(
    userService: userService,
    storageService: storageService,
  );
});

final profileViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<ProfileViewModel, ProfileState, String>(
      ProfileViewModel.new,
    );

// lấy user data theo id
final userProfileProvider = StreamProvider.family<User, String>((ref, uid) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUserStream(uid);
});

// profile settings
final profileSettingsViewModelProvider =
    AsyncNotifierProvider<ProfileSettingsViewModel, void>(() {
      return ProfileSettingsViewModel();
    });
