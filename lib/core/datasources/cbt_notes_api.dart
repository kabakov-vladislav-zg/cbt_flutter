import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';

@singleton
class CbtNotesApi {
  CbtNotesApi({required this.db});

  final Database db;

  late BehaviorSubject<List<CbtNote>> _streamController;

  Future<Stream<List<CbtNote>>> getCbtNotesStream() async {
    final list = await getCbtNotes();
    _streamController = BehaviorSubject<List<CbtNote>>.seeded(list);
    return _streamController.asBroadcastStream();
  }

  Future<void> insertCbtNote(CbtNote cbtNote) async {
    await db.insert(
      'CbtNotes',
      cbtNote.toJson(),
    );

    final list = await getCbtNotes();
    _streamController.add(list);
  }

  Future<void> updateCbtNote(CbtNote cbtNote) async {
    await db.update(
      'CbtNotes',
      cbtNote.toJson(),
      where: 'uuid = ?',
      whereArgs: [cbtNote.uuid],
    );
    final list = await getCbtNotes();
    _streamController.add(list);
  }

  Future<List<CbtNote>> getCbtNotes() async {
    final List<Map<String, Object?>> map = await db.query(
      'CbtNotes',
    );
    // final List<Map<String, Object?>> map = await db.query(
    //   'CbtNotes, json_tree(CbtNotes.emotions)',
    //   where: "json_tree.key=? AND json_tree.value=?",
    //   whereArgs: ['name', 'Истерия']
    // );
    // final List<Map<String, Object?>> map = await db.rawQuery(
    //   "SELECT * FROM CbtNotes, json_tree(CbtNotes.emotions) WHERE json_tree.key='name' AND json_tree.value='Истерия'"
    // );
    return [
      for (final note in map) CbtNote.fromJson(note),
    ];
  }

  Future<void> deleteCbtNote(String uuid) async {
    await db.delete(
      'CbtNotes',
      where: 'id = ?',
      whereArgs: [uuid],
    );
    final list = await getCbtNotes();
    _streamController.add(list);
  }
}
