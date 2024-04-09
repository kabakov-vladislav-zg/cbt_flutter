import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/src/cbt_notes/data/cbt_notes_repo.dart';
import 'package:injectable/injectable.dart';


@singleton
class UpdateCbtNote {
  UpdateCbtNote(this._repo);
  final CbtNotesRepo _repo;

  Future<void> call(CbtNote cbtNote) async {
    return _repo.updateCbtNote(cbtNote);
  }
}