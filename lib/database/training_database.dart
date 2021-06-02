import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
final table = 'exercise';

class DatabaseHelper {

  static final _databaseName = "Exercise.db";
  static final _databaseVersion = 1;

  static final columnId = 'id';
  static final columnUserId = 'user';
  static final columnPhase = 'phase';
  static final columnWeek = 'week';
  static final columnDay = 'day';
  static final columnReps = 'reps';
  static final columnWeight = 'weight';
  static final columnSets = 'sets';
  static final columnExerciseId = 'exercise';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $table ("
            "$columnId INTEGER PRIMARY KEY, "
            "$columnUserId INTEGER NOT NULL, "
            "$columnPhase INTEGER NOT NULL, "
            "$columnWeek INTEGER NOT NULL, "
            "$columnDay INTEGER NOT NULL, "
            "$columnReps TEXT NOT NULL, "
            "$columnWeight TEXT NOT NULL, "
            "$columnSets INTEGER NOT NULL, "
            "$columnExerciseId INTEGER NOT NULL "
            ")"
    );
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row["id"];
    List<dynamic> whereArguments = [id];
    var entry = await db.query(table, where: '$columnId = ?', whereArgs: whereArguments);
    if (entry.isEmpty){
      return await db.insert(table, row);
    }
    else return null;
  }
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> i = await db.query(table);
    return i;
  }
  Future<List<Map<String, dynamic>>> queryDayRows(int day) async {
    Database db = await instance.database;
    List<int> latest = await this.getLatest();
    List<Map<String, dynamic>> i = await db.query(table, where: '$columnDay = ? AND $columnPhase = ? AND $columnWeek = ?' , whereArgs: [day, latest[0], latest[1]] );
    return i;
  }
  Future<List<int>> getLatest() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> items = await db.query(table);
    int phase= 0;
    int week= 0;
    for(final item in items){
      if (item["phase"] >phase) {
        phase = item["phase"];
      }
      if (item["week"] >week) {
        week = item["week"];
      }
    }
    return [phase,week];
  }
  Future<int> getDays() async {
    Database db = await instance.database;
    List<int> latest = await this.getLatest();
    List<Map<String, dynamic>> items = await db.query(table, where: '$columnPhase = ? AND $columnWeek = ?' , whereArgs: [latest[0], latest[1]] );
    int day = 0;
    for(final item in items){
      if (item["day"] >day) {
        day = item["day"];
      }
    }
    return day;
  }
  Future<int> getLatestWeek() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> items = await db.query(table);
    int week= 0;
    for(final item in items){
      if (item["week"] >week) {
        week = item["week"];
      }
    }
    return week;
  }
  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
  static Future<int> deleteDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Exercise.db');
    await sqflite.deleteDatabase(path);
  }

}