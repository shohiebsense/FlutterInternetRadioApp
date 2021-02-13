import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_radio_app/models/base_model_db.dart';
import 'package:internet_radio_app/models/radio_api_service.dart';
import 'package:internet_radio_app/models/radio_station.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

abstract class DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      var databasePath = await getDatabasesPath();
      String _path = path.join(databasePath, 'RadioApp.db');
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    initTables(db);
  }

  static void initTables(db) async{
    await db.execute(
        'CREATE TABLE radio (id INTEGER PRIMARY KEY NOT NULL, radio_name TEXT, radio_url TEXT, radio_desc TEXT, radio_website TEXT, radio_pic TEXT)');
    await db.execute(
        'CREATE TABLE radio_bookmark (id INTEGER PRIMARY KEY NOT NULL, is_favorite INTEGER)');
    await db.execute(
        'CREATE TABLE radio_time_update (time_latest_data TEXT)');
  }

  static void clearTables() async {
    await _db.execute("DELETE FROM radio");
    await _db.execute("DELETE FROM radio_bookmark");

  }


  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table, BaseModelDb model) async =>
      await _db.insert(table, model.toMap());

  static String getAllWithFav() {
    return "SELECT ${RadioStation.TABLE_NAME}.id, "
        "${RadioStation.TABLE_NAME}.radio_name, ${RadioStation.TABLE_NAME}.radio_url, ${RadioStation.TABLE_NAME}.radio_desc, ${RadioStation.TABLE_NAME}.radio_website, ${RadioStation.TABLE_NAME}.radio_pic, "
        " radio_bookmark.is_favorite FROM ${RadioStation.TABLE_NAME} LEFT JOIN radio_bookmark ON Radio_bookmark.id = ${RadioStation.TABLE_NAME}.id";
  }

  static String getAllWithFavAndSearchQuery(String searchQuery) {
    return getAllWithFav() + " " + generateSearchQuery(searchQuery);
  }

  static String generateSearchQuery(String searchQuery) {
    return "WHERE ${RadioStation.TABLE_NAME}.radio_name LIKE '%${searchQuery}%' OR ${RadioStation.TABLE_NAME}.radio_desc LIKE '%${searchQuery}%'";
  }

  static String getFavOnly() {
    return "SELECT ${RadioStation.TABLE_NAME}.id, "
        "${RadioStation.TABLE_NAME}.radio_name, ${RadioStation.TABLE_NAME}.radio_url, ${RadioStation.TABLE_NAME}.radio_desc, ${RadioStation.TABLE_NAME}.radio_website, ${RadioStation.TABLE_NAME}.radio_pic, "
        " radio_bookmark.is_favorite FROM ${RadioStation.TABLE_NAME} INNER JOIN radio_bookmark ON radio_bookmark.id = ${RadioStation.TABLE_NAME}.id WHERE IS_FAVORITE = 1";
  }

  static Future<bool> getTimeLatestUpdate(DateTime apiDateTime) async{
    String time = "";
    List<String> columns = new List<String>();
    columns.add("time_latest_data");


    int count = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM radio_time_update'));

    if(count == 0){
      return true;
    }

    print("length sizeeee $count");

    /*List<Map<String, dynamic>> _resultList =
    await _db.query("radio_time_update", columns: columns, limit: 1);*/

    List<Map<String, dynamic>> timeLatestData = await _db.rawQuery("SELECT time_latest_data FROM radio_time_update ORDER BY time_latest_data DESC LIMIT 1");
    print(" db_service valuee ${timeLatestData.first['time_latest_data']}");


    DateTime currentDataDateTime = DateTime.parse(timeLatestData.first['time_latest_data']);

    return apiDateTime.isAfter(currentDataDateTime);
  }

  static String getFavOnlyWithQuery(String searchQuery) {
    return getFavOnly() + " " + generateSearchQuery(searchQuery);
  }

  static Future<List<Map<String, dynamic>>> rawQuery(String sql) async =>
      _db.rawQuery(sql);

  static Future<int> rawInsert(String sql) async => await _db.rawInsert(sql);
}
