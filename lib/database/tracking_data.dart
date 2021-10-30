import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:xcell/models/group.dart';
final table = 'tracking';

class TrackingDatabase {

  static final _databaseName = "Tracking.db";
  static final _databaseVersion = 1;

  static final columnId = 'id';
  static final columnFieldId = 'field_id';
  static final columnDate = 'date';
  static final columnValue = 'value';

  // make this a singleton class
  TrackingDatabase._privateConstructor();
  static final TrackingDatabase instance = TrackingDatabase._privateConstructor();

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
            "$columnFieldId INTEGER NOT NULL, "
            "$columnDate TEXT NOT NULL, "
            "$columnValue TEXT NOT NULL "
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
  Future<List<TextValue>> queryID(List field_ids, DateTime day) async {
    Database db = await instance.database;
    List<TextValue> items = [];
    for (final id in field_ids){
      List<Map<String, dynamic>> item = await db.query(table, where: '$columnFieldId = ? and $columnDate = ?', whereArgs: [id,day.toString()]);
      if(item.isNotEmpty) {
        TextValue val= TextValue(
          id: item[0]['field_id'],
          date: DateTime.parse(item[0]['date']),
          value: item[0]['value']
        );
        items.add(val);
      }
    }
    return items;
  }
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> i = await db.query(table);
    return i;
  }

  Future<Map<String,dynamic>> queryRow(fieldId, date) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> i = await db.query(table, where: '$columnFieldId = ? and $columnDate = ?' , whereArgs: [fieldId, date]);
    return i[0];
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
    int fieldId = row['field_id'];
    String date = row['date'];
    List<Map<String, dynamic>> item = await db.query(table, where: '$columnFieldId = ? and $columnDate = ?', whereArgs: [fieldId,date.toString()]);
    if (item.isEmpty){
      return await db.insert(table, row);
    }
    else {
      return await db.update(
          table, row, where: '$columnFieldId = ? and $columnDate = ?',
          whereArgs: [fieldId, date]);
    }
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
    String path = join(documentsDirectory.path, 'Tracking.db');
    await sqflite.deleteDatabase(path);
  }

}
String slice(String subject, [int start = 0, int end]) {
  if (subject is! String) {
    return '';
  }

  int _realEnd;
  int _realStart = start < 0 ? subject.length + start : start;
  if (end is! int) {
    _realEnd = subject.length;
  } else {
    _realEnd = end < 0 ? subject.length + end : end;
  }

  return subject.substring(_realStart, _realEnd);
}