import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';

@singleton
class DiaryNoteApi {
  DiaryNoteApi({required this.db});

  final Database db;

  late BehaviorSubject<List<DiaryNote>> _streamController;

  Future<Stream<List<DiaryNote>>> getCbtNotes() async {
    final list = await diaryNotes();
    _streamController = BehaviorSubject<List<DiaryNote>>.seeded(list);
    return _streamController.asBroadcastStream();
  }

  Future<void> insertDiaryNote(DiaryNote diaryNote) async {
    await db.insert(
      'CbtNotes',
      diaryNote.toJson(),
    );

    final list = await diaryNotes();
    _streamController.add(list);
  }

  Future<void> updateDiaryNote(DiaryNote diaryNote) async {
    await db.update(
      'CbtNotes',
      diaryNote.toJson(),
      where: 'uuid = ?',
      whereArgs: [diaryNote.uuid],
    );
    final list = await diaryNotes();
    _streamController.add(list);
  }

  Future<List<DiaryNote>> diaryNotes() async {
    final List<Map<String, Object?>> map = await db.query('CbtNotes');
    return [
      for (final note in map) DiaryNote.fromJson(note),
    ];
  }

  Future<void> deleteDiaryNote(String uuid) async {
    await db.delete(
      'CbtNotes',
      where: 'id = ?',
      whereArgs: [uuid],
    );
    final list = await diaryNotes();
    _streamController.add(list);
  }
}
