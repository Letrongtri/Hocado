import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/auth_provider.dart';
import 'package:hocado/app/provider/settings_provider.dart';
import 'package:hocado/data/models/learning_settings.dart';
import 'package:hocado/data/repositories/settings/settings_repository.dart';

class LearningSettingsViewModel extends AsyncNotifier<LearningSettings> {
  final String did;

  LearningSettingsViewModel(this.did);

  SettingsRepository get _learningSettingsRepo => ref.read(settingsRepository);
  User? get _currentUser => ref.read(currentUserProvider);

  @override
  FutureOr<LearningSettings> build() async {
    return await fetchMyLearningSettingsByDeckId();
  }

  Future<LearningSettings> fetchMyLearningSettingsByDeckId() async {
    final user = _currentUser;
    if (user == null) throw Exception('User not logged in');

    final settings = await _learningSettingsRepo.getEffectiveDeckSettings(
      did,
      _currentUser!.uid,
    );

    return settings;
  }

  void updateSettings(LearningSettings newSettings) {
    state = AsyncData(newSettings);
  }

  Future<void> saveDeckSettings() async {
    final user = _currentUser;
    if (user == null) throw Exception('User not logged in');

    await _learningSettingsRepo.saveDeckSettingsAsDefault(
      did,
      user.uid,
      state.value!,
    );
  }
}
