import 'package:cbt_flutter/core/repos/cbt_notes_repo.dart';
import 'package:injectable/injectable.dart';


@singleton
class RemoveCbtNote {
  RemoveCbtNote(this._repo);
  final CbtNotesRepo _repo;

  Future<void> call(String uuid) async {
    return _repo.removeCbtNote(uuid);
  }
}