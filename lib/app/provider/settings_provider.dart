import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/data/services/services.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

// Services
final localSettingsServiceProvider = Provider((ref) {
  final sharedPrefs = ref.read(sharedPrefsProvider);
  return LocalSettingsService(sharedPrefs);
});

final remoteSettingsServiceProvider = Provider((ref) {
  final firestore = ref.read(firestoreProvider);
  return RemoteSettingsService(firestore);
});

// settings repository
final settingsRepositoryProvider = Provider(
  (ref) {
    final localService = ref.read(localSettingsServiceProvider);
    final remoteService = ref.read(remoteSettingsServiceProvider);

    return SettingsRepository(
      localSettingsService: localService,
      remoteSettingsService: remoteService,
    );
  },
);

// learning settings view model
final learningSettingsViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<LearningSettingsViewModel, LearningSettings, String>(
      LearningSettingsViewModel.new,
    );

// system settings view model
final systemSettingsViewModelProvider =
    AsyncNotifierProvider.autoDispose<
      SystemSettingsViewModel,
      SystemSettingsState
    >(SystemSettingsViewModel.new);
