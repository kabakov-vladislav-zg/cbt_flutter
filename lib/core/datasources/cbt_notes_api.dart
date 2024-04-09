import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

@singleton
class CbtNotesApi {
  CbtNotesApi({required this.db});

  final Database db;

  Future<void> insertCbtNote(CbtNote cbtNote) async {
    await db.insert(
      'CbtNotes',
      cbtNote.toJson(),
    );
  }

  Future<void> updateCbtNote(CbtNote cbtNote) async {
    await db.update(
      'CbtNotes',
      cbtNote.toJson(),
      where: 'uuid = ?',
      whereArgs: [cbtNote.uuid],
    );
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
  }
}
