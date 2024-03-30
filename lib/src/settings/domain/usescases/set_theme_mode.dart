import 'package:cbt_flutter/src/settings/data/repos/theme_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';


@singleton
class SetThemeMode {
  SetThemeMode(this._repo);
  final ThemeRepoImpl _repo;

  Future<void> call(ThemeMode? themeMode) async {
    return _repo.setThemeMode(themeMode ?? ThemeMode.system);
  }
}