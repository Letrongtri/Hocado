import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/firebase_provider.dart';
import 'package:hocado/app/provider/shared_prefs_provider.dart';
import 'package:hocado/data/models/learning_settings.dart';
import 'package:hocado/data/repositories/settings/settings_repository.dart';
import 'package:hocado/data/services/local_settings_service.dart';
import 'package:hocado/data/services/remote_settings_service.dart';
import 'package:hocado/presentation/viewmodels/learning_settings/learning_settings_view_model.dart';

// Services
final localSettingsServices = Provider((ref) {
  final sharedPrefs = ref.read(sharedPrefsProvider);
  return LocalSettingsService(sharedPrefs);
});

final remoteSettingsServices = Provider((ref) {
  final firestore = ref.read(firestoreProvider);
  return RemoteSettingsService(firestore);
});

// settings repository
final settingsRepository = Provider(
  (ref) {
    final localService = ref.read(localSettingsServices);
    final remoteService = ref.read(remoteSettingsServices);

    return SettingsRepository(
      localSettingsService: localService,
      remoteSettingsService: remoteService,
    );
  },
);

// learning settings view model
final learningSettingsViewModel = AsyncNotifierProvider.autoDispose
    .family<LearningSettingsViewModel, LearningSettings, String>(
      LearningSettingsViewModel.new,
    );
