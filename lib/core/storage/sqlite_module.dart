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
          CbtNotes(
            uuid TEXT PRIMARY KEY,
            trigger TEXT,
            timestamp INTEGER,
            isCreated TEXT,
            isCompleted TEXT,
            thoughts TEXT,
            emotions TEXT
          )
        ''');
    },
    version: 1,
  );
}