import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/data/repositories/repositories.dart';

class LearningSettingsViewModel extends AsyncNotifier<LearningSettings> {
  final String did;

  LearningSettingsViewModel(this.did);

  SettingsRepository get _learningSettingsRepo =>
      ref.read(settingsRepositoryProvider);
  fb_auth.User? get _currentUser => ref.watch(currentUserProvider);

  LearningSettings initSettings = LearningSettings.empty();

  @override
  FutureOr<LearningSettings> build() async {
    final settings = await fetchMyLearningSettingsByDeckId();
    initSettings = settings;
    return settings;
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

    final currentSettings = state.value!;

    if (initSettings == currentSettings) return;

    await _learningSettingsRepo.saveDeckSettingsAsDefault(
      did,
      user.uid,
      state.value!,
    );
    initSettings = currentSettings;
  }
}
