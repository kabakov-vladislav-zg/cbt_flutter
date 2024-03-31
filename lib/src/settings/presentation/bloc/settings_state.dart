part of 'settings_cubit.dart';

@immutable
final class SettingsState {
  const SettingsState({
    this.themeMode = ThemeMode.system,
  });

  final ThemeMode themeMode;
}