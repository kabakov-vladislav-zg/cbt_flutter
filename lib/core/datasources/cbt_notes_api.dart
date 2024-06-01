import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/entities/cbt_notes_filter.dart';
import 'package:cbt_flutter/core/utils/json/json_converters.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

@singleton
class CbtNotesApi {
  const CbtNotesApi({required this.db});

  final Database db;

  static const table = CbtNote.table;
  static const columns = CbtNote.columns;

  Future<void> insertCbtNote(CbtNote cbtNote) async {
    await db.insert(
      table,
      cbtNote.toJson(),
    );
  }

  Future<void> updateCbtNote(CbtNote cbtNote) async {
    await db.update(
      table,
      cbtNote.toJson(),
      where: 'uuid = "${cbtNote.uuid}"',
    );
  }

  Future<void> deleteCbtNote(String uuid) async {
    await db.delete(
      table,
      where: 'uuid = "$uuid"',
    );
  }

  Future<List<CbtNote>> getCbtNotes(CbtNotesFilter? filter) async {
    final map = await db.rawQuery(_bildQuery(filter));
    return [
      for (final note in map)
        CbtNote.fromJson(note),
    ];
  }

  Future<int> countCbtNotes(CbtNotesFilter? filter) async {
    final [map] = await db.rawQuery(_bildQuery(filter, count: true));
    return map['count'] as int;
  }
}

String _bildQuery(CbtNotesFilter? filter, { bool count = false }) {
  filter = filter ?? const CbtNotesFilter();
  final uuid = filter.uuid;
  final isCompleted = filter.isCompleted;
  final dateFrom = filter.dateFrom;
  final dateTo = filter.dateTo;
  final emotion = filter.emotion;
  final corruption = filter.corruption;

  const table = CbtNote.table;
  const columns = CbtNote.columns;

  final operator = count
    ? 'SELECT count(*) AS "count"'
    : 'SELECT *';
  final from =[table];
  final where = [];

  if (uuid != null) {
    where.add('${columns.uuid} = "$uuid"');
  }

  if (isCompleted != null) {
    final flag = boolToJson(isCompleted);
    where.add('${columns.isCompleted} = "$flag"');
  }

  if (dateFrom != null) {
    final date1 = DateTime(dateFrom.year, dateFrom.month, dateFrom.day).millisecondsSinceEpoch;
    where.add('${columns.timestamp} >= $date1');
  }

  if (dateTo != null) {
    final date2 = DateTime(dateTo.year, dateTo.month, dateTo.day).millisecondsSinceEpoch;
    where.add('${columns.timestamp} < $date2');
  }

  if (emotion != null) {
    where.add('${columns.emotions} LIKE "%$emotion%"');
  }

  if (corruption != null) {
    from.add('json_tree(CbtNotes.thoughts)');
    where.add('json_tree.key="corruption" AND json_tree.value="$corruption"');
  }

  return [
    operator,
    'FROM',
    from.join(', '),
    if (where.isNotEmpty)
      ...['WHERE', where.join(' AND ')],
    'ORDER BY',
    columns.timestamp,
    'DESC',
  ].join(' ');
}
