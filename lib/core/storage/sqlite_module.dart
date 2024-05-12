import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@module
abstract class SqliteModule {
  @preResolve
  Future<Database> get db => getDb();
}

Future<Database> getDb() async {
  return openDatabase(
    join(await getDatabasesPath(), 'cbt_diary.db'),
    onCreate: (db, version) {
      return db.execute('''
          CREATE TABLE
          ${CbtNote.table} (
            ${CbtNote.model}
          )
        ''');
    },
    version: 1,
  );
}