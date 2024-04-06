import 'package:cbt_flutter/core/repos/diary_note_repo.dart';
import 'package:injectable/injectable.dart';


@singleton
class RemoveDiaryNote {
  RemoveDiaryNote(this._repo);
  final DiaryNoteRepo _repo;

  Future<void> call(String uuid) async {
    return _repo.removeDiaryNote(uuid);
  }
}