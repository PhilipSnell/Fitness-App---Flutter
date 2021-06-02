import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:xcell/models/training_set.dart';
final table = 'exerciseSet';

class SetDatabase {

  static final _databaseName = "Set.db";
  static final _databaseVersion = 1;

  static final columnId = 't_id';
  static final columnSets = 'sets';
  static final columnReps = 'reps';
  static final columnWeights = 'weights';
  static final columnEId = 'e_id';

  // make this a singleton class
  SetDatabase._privateConstructor();
  static final SetDatabase instance = SetDatabase._privateConstructor();

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
            "$columnSets INTEGER NOT NULL, "
            "$columnReps TEXT NOT NULL, "
            "$columnWeights TEXT NOT NULL, "
            "$columnEId INTEGER NOT NULL "
            ")"
    );
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int t_id = row["t_id"];
    List<dynamic> whereArguments = [t_id];
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
  Future<List<TrainingSet>> queryID(int t_id, String defaultRep, String defaultWeight, int e_id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> items = await db.query(table, where: '$columnId = ?', whereArgs: [t_id]);
    if(items.isEmpty){
      return [];
    }else {
      int setId = items[0]["t_id"];
      int sets = items[0]["sets"];
      List<String> reps = items[0]["reps"].split(',');
      List<String> weights =  items[0]["weights"].split(',');
      int e_id = items[0]["e_id"];
      List<TrainingSet> set_list = [];
      for (var i=0; i<reps.length; i+=1){
        set_list.add(TrainingSet(t_id: setId, sets: sets, reps: reps[i], weights: weights[i], e_id: e_id));
      }
      //List<TrainingSet> sets =
      return set_list;
    }
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
    String path = join(documentsDirectory.path, 'Set.db');
    await sqflite.deleteDatabase(path);
  }

}