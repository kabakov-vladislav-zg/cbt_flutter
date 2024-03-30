// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cbt_flutter/core/storage/storage_module.dart' as _i9;
import 'package:cbt_flutter/src/settings/data/datasources/settings_prefs.dart'
    as _i4;
import 'package:cbt_flutter/src/settings/data/repos/theme_repo_impl.dart'
    as _i5;
import 'package:cbt_flutter/src/settings/domain/usescases/get_theme_mode.dart'
    as _i6;
import 'package:cbt_flutter/src/settings/domain/usescases/set_theme_mode.dart'
    as _i7;
import 'package:cbt_flutter/src/settings/presentation/bloc/settings_cubit.dart'
    as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final sharedPreferencesModule = _$SharedPreferencesModule();
    await gh.factoryAsync<_i3.SharedPreferences>(
      () => sharedPreferencesModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i4.SettingsPrefs>(
        () => _i4.SettingsPrefs(prefs: gh<_i3.SharedPreferences>()));
    gh.singleton<_i5.ThemeRepoImpl>(
        () => _i5.ThemeRepoImpl(settingsPrefs: gh<_i4.SettingsPrefs>()));
    gh.singleton<_i6.GetThemeMode>(
        () => _i6.GetThemeMode(gh<_i5.ThemeRepoImpl>()));
    gh.singleton<_i7.SetThemeMode>(
        () => _i7.SetThemeMode(gh<_i5.ThemeRepoImpl>()));
    gh.factory<_i8.SettingsCubit>(() => _i8.SettingsCubit(
          getThemeMode: gh<_i6.GetThemeMode>(),
          setThemeMode: gh<_i7.SetThemeMode>(),
        ));
    return this;
  }
}

class _$SharedPreferencesModule extends _i9.SharedPreferencesModule {}
