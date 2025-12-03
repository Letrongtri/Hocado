// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SystemSettingsState {
  final ThemeMode themeMode;
  final bool isSoundOn;

  SystemSettingsState({required this.themeMode, required this.isSoundOn});

  SystemSettingsState copyWith({
    ThemeMode? themeMode,
    bool? isSoundOn,
  }) {
    return SystemSettingsState(
      themeMode: themeMode ?? this.themeMode,
      isSoundOn: isSoundOn ?? this.isSoundOn,
    );
  }
}
