import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/utils/json/json_converters.dart';
import 'package:equatable/equatable.dart';
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
      where: 'uuid = ${cbtNote.uuid}',
    );
  }

  Future<List<CbtNote>> getCbtNotes() async {
    final List<Map<String, Object?>> map = await db.rawQuery(_getQuery());
    return [
      for (final note in map) CbtNote.fromJson(note),
    ];
  }

  Future<void> deleteCbtNote(String uuid) async {
    await db.delete(
      table,
      where: 'uuid = $uuid',
    );
  }
}

String _getQuery([CbtNoteFilter? filter]) {
  filter = filter ?? const CbtNoteFilter();
  final uuid = filter.uuid;
  final isCompleted = filter.isCompleted;
  final dateFrom = filter.dateFrom;
  final dateTo = filter.dateTo;
  final emotion = filter.emotion;
  final corruption = filter.corruption;

  const table = CbtNote.table;
  const columns = CbtNote.columns;

  final from =[table];
  final where = [];

  if (uuid != null) {
    where.add('${columns.uuid} = $uuid');
  }

  if (isCompleted != null) {
    final flag = boolToJson(isCompleted);
    where.add('${columns.isCompleted} = $flag}');
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
    'SELECT *',
    'FROM',
    from.join(', '),
    if (where.isNotEmpty)
      ...['WHERE', where.join(' AND ')],
    'ORDER BY',
    columns.timestamp,
    'DESC',
  ].join(' ');
}

class CbtNoteFilter extends Equatable {
  const CbtNoteFilter({
    this.uuid,
    this.isCompleted,
    this.dateFrom,
    this.dateTo,
    this.emotion,
    this.corruption,
  });

  final String? uuid;
  final bool? isCompleted;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? emotion;
  final String? corruption;

  @override
  get props => [uuid, isCompleted, dateFrom, dateTo, emotion, corruption];
}
