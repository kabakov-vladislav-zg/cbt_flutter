import 'package:cbt_flutter/src/settings/domain/usescases/get_theme_mode.dart';
import 'package:cbt_flutter/src/settings/domain/usescases/set_theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  @factoryMethod
  SettingsCubit({
    required GetThemeMode getThemeMode,
    required SetThemeMode setThemeMode,
  }) :
    _getThemeMode = getThemeMode,
    _setThemeMode = setThemeMode,
    super(const SettingsState()) {
      emit(SettingsState(themeMode: _getThemeMode()));
    }

  final GetThemeMode _getThemeMode;
  final SetThemeMode _setThemeMode;

  Future<void> setThemeMode(ThemeMode? mode) async {
    _setThemeMode(mode);
    emit(SettingsState(themeMode: _getThemeMode()));
  }
}
