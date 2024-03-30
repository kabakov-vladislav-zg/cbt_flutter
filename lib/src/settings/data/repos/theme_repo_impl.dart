import 'package:cbt_flutter/src/settings/data/datasources/settings_prefs.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class ThemeRepoImpl {
  ThemeRepoImpl({required this.settingsPrefs});

  final SettingsPrefs settingsPrefs;

  ThemeMode getThemeMode() {
    return settingsPrefs.getThemeMode();
  }
  Future<void> setThemeMode(ThemeMode themeMode) async {
    settingsPrefs.setThemeMode(themeMode);
  }
}