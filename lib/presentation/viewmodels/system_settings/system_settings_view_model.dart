import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/repositories/repositories.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';

class SystemSettingsViewModel extends AsyncNotifier<SystemSettingsState> {
  SettingsRepository get _settingsRepository =>
      ref.read(settingsRepositoryProvider);

  @override
  FutureOr<SystemSettingsState> build() async {
    final themeMode = await _settingsRepository.loadTheme();
    final isSoundOn = await _settingsRepository.loadIsSoundOn();

    return SystemSettingsState(themeMode: themeMode, isSoundOn: isSoundOn);
  }

  Future<void> saveTheme(ThemeMode themeMode) async {
    await _settingsRepository.saveTheme(themeMode);
    state = AsyncData(state.value!.copyWith(themeMode: themeMode));
  }

  Future<void> saveIsSoundOn(bool isSoundOn) async {
    await _settingsRepository.saveIsSoundOn(isSoundOn);
    state = AsyncData(state.value!.copyWith(isSoundOn: isSoundOn));
  }
}
