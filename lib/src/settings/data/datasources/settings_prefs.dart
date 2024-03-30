import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class SettingsPrefs {
  const SettingsPrefs({required this.prefs});

  final SharedPreferences prefs;

  ThemeMode getThemeMode() {
    final index = prefs.getInt('ThemeMode');
    return ThemeMode.values[index ?? 0];
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    prefs.setInt('ThemeMode', mode.index);
  }
}