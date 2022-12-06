import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'indications_table.dart' as indications;
import 'dart:developer' as dev;
import 'package:path/path.dart';

const String dbName = 'my_package_name.db';

const tables = [
  indications.createTableQuery,
];

Future<Database> provideDb() async {
  final path = await initDb();
  return await openDatabase(
    path,
    version: 1,
    onCreate: onDbCreate,
    onConfigure: onDbConfigure,
    onOpen: (db) async {
      await db.execute('PRAGMA foreign_keys = ON;');
    },
  );
}

Future<String> initDb() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, dbName);

  if (!(await Directory(dirname(path)).exists())) {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      dev.log('Init DB Error', name: 'DB exception', error: e);
    }
  }
  return path;
}


FutureOr<void> onDbCreate(Database db, int version) async {
  for (var table in tables) {
    db.execute(table);
  }
}

FutureOr<void> onDbConfigure(Database db) async {
  await db.execute('PRAGMA foreign_keys = OFF;');
}