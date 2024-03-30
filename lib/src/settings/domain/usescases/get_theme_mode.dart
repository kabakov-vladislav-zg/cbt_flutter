import 'package:cbt_flutter/src/settings/data/repos/theme_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';


@singleton
class GetThemeMode {

  GetThemeMode(this._repo);
  final ThemeRepoImpl _repo;

  ThemeMode call() => _repo.getThemeMode();
}