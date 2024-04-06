import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';

@singleton
class DiaryNoteApi {
  DiaryNoteApi({required this.db});

  final Database db;

  List<DiaryNote> _list = [];

  final _streamController = BehaviorSubject<List<DiaryNote>>.seeded(const []);

  Stream<List<DiaryNote>> getCbtNotes() => _streamController.asBroadcastStream();

  Future<void> setDiaryNote(DiaryNote diaryNote) async {
    await insertDiaryNote(diaryNote);
    final dnlist = await diaryNotes();
    print('setDiaryNote $dnlist');

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
  Future<void> removeDiaryNote(String uuid) async {
    final list = [..._list];
    list.removeWhere((note) => note.uuid == uuid);
    _list = list;
    _streamController.add(_list);
  }

  Future<void> insertDiaryNote(DiaryNote diaryNote) async {
    await db.insert(
      'CbtNotes',
      diaryNote.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DiaryNote>> diaryNotes() async {
    final List<Map<String, Object?>> map = await db.query('CbtNotes');
    return [
      for (final note in map) DiaryNote.fromJson(note),
    ];
  }

  Future<void> updateDiaryNote(DiaryNote diaryNote) async {
    await db.update(
      'CbtNotes',
      diaryNote.toJson(),
      where: 'uuid = ?',
      whereArgs: [diaryNote.uuid],
    );
  }

  Future<void> deleteDiaryNote(String uuid) async {
    await db.delete(
      'CbtNotes',
      where: 'id = ?',
      whereArgs: [uuid],
    );
  }
}
