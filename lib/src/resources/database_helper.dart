import 'dart:io';

import 'package:first_offline_app/src/resources/constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._instance();
  factory DatabaseHelper() => db;
  static final DatabaseHelper db = DatabaseHelper._instance();
  late Database _database;

  // singleton pattern
  Future<Database> get database async {
    _database = await _initDB();

    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationSupportDirectory();
    String databasePath = join(dir.path, DATABASE_NAME);

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(CREATE_POKEMON_TABLE);
  }

  Future close() async {
    var dbClient = await database;
    return dbClient.close();
  }
  
}
