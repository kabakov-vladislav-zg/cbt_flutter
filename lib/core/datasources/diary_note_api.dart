import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:rxdart/subjects.dart';

@singleton
class DiaryNoteApi {
  DiaryNoteApi();

  List<DiaryNote> _list = [];

  final _streamController = BehaviorSubject<List<DiaryNote>>.seeded(const []);

  Stream<List<DiaryNote>> getCbtNotes() => _streamController.asBroadcastStream();

  void setDiaryNote(DiaryNote diaryNote) {
    final list = [..._list];
    final uuid = diaryNote.uuid;
    final index = list.indexWhere((note) => note.uuid == uuid);
    if (index == -1) {
      list.add(diaryNote);
    } else {
      list[index] = diaryNote;
    }
    _list = list;
    _streamController.add(_list);
  }
  void removeDiaryNote(String uuid) {
    final list = [..._list];
    list.removeWhere((note) => note.uuid == uuid);
    _list = list;
    _streamController.add(_list);
  }
}
