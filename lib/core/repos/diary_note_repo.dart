import 'package:cbt_flutter/core/datasources/diary_note_api.dart';
import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:injectable/injectable.dart';

@singleton
class DiaryNoteRepo {
  DiaryNoteRepo({required DiaryNoteApi diaryNoteApi}) : _diaryNoteApi = diaryNoteApi;

  final DiaryNoteApi _diaryNoteApi;
  
  Future<Stream<List<DiaryNote>>> getCbtNotes() => _diaryNoteApi.getCbtNotes();

  Future<void> insertDiaryNote(DiaryNote diaryNote) async {
    return _diaryNoteApi.insertDiaryNote(diaryNote);
  }
  Future<void> updateDiaryNote(DiaryNote diaryNote) async {
    return _diaryNoteApi.updateDiaryNote(diaryNote);
  }
  Future<void> removeDiaryNote(String uuid) async {
    return _diaryNoteApi.deleteDiaryNote(uuid);
  }
}