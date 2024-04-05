import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/core/repos/diary_note_repo.dart';
import 'package:injectable/injectable.dart';


@singleton
class SetDiaryNote {
  SetDiaryNote(this._repo);
  final DiaryNoteRepo _repo;

  Future<void> call(DiaryNote diaryNote) async {
    return _repo.setDiaryNote(diaryNote);
  }
}