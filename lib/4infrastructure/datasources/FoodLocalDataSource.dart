import 'dart:io';

import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/3domain/entitites/LogEntity.dart';
import 'package:foodtracker/4infrastructure/models/MealModel.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../../3domain/entitites/MealEntity.dart';
import '../exceptions/exceptions.dart';
import '../models/FoodModel.dart';
import '../models/LogModel.dart';

abstract class FoodLocalDataSource {
  //Lesen
  ///Get Food from Database with [ean]
  Future<FoodEntity> getFood(String ean);

  ///Get all saved Foods from Database with optional [date]
  Future<List<FoodEntity>> getFoodList(String? date);

  ///Get Log from Database with [id]
  Future<LogEntity> getLog(int id);

  ///Get all saved Logs from Database
  Future<List<LogEntity>> getLogList();

  ///Get consumed Meals of a day with [date]
  Future<List<MealEntity>> getMealList(String date);

  ///Insert Food into Database with [foodModel]
  Future<int> insertToFoodTable(FoodModel foodModel);

  ///Insert Log into Database with [logModel]
  Future<int> insertToLogTable(LogModel logModel);

  ///Update Food Entry in Database with [foodModel]
  Future<int> updateFoodInTable(FoodModel foodModel);

  ///Update Log Entry in Database with [logModel]
  Future<int> updateLogInTable(LogModel logModel);

  ///Delete Log Entry in Database with [id]
  Future<int> deleteLogInTable(int id);

  ///Update saved Product data in Database with OpenFoodFacts
  Future<void> updateFoodWithSource();
}

class FoodLocalDataSourceImpl extends FoodLocalDataSource {
  // structure is based on https://www.anycodings.com/1questions/2925086/how-to-store-only-new-value-to-sqflite-data-table-in-flutter
  static final _databaseName = "foodtracker.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  FoodLocalDataSourceImpl._privateConstructor();

  static final FoodLocalDataSourceImpl instance =
      FoodLocalDataSourceImpl._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print("PFAD: $path");
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE "food" (
            "f_ean"	INTEGER NOT NULL,
            "f_brand"	TEXT,
            "f_name"	TEXT,
            "f_energy"	REAL,
            "f_fat"	REAL,
            "f_fat_saturated"	REAL,
            "f_carbohydrates"	REAL,
            "f_sugar"	REAL,
            "f_proteins"	REAL,
            "f_salt"	REAL,
            "f_serving_size"	REAL,
            "f_image_url"	TEXT,
            "f_image"	BLOB,
            PRIMARY KEY("f_ean")
          );
          ''');
    await db.execute('''
          CREATE TABLE "log" (
            "l_id"	INTEGER NOT NULL,
            "f_ean"	INTEGER NOT NULL,
            "l_amount"	REAL NOT NULL,
            "l_date"	TEXT NOT NULL,
            "l_type"	NUMERIC NOT NULL,
            FOREIGN KEY("f_ean") REFERENCES "food"("f_ean"),
            PRIMARY KEY("l_id" AUTOINCREMENT)
          )
          ''');
  }

  // Helper methods
  @override
  Future<FoodEntity> getFood(String ean) async {
    Database db = await instance.database;
    var result = await db.query('food', where: 'f_ean = ?', whereArgs: [ean]);
    if (result.isNotEmpty) {
      return FoodModel.fromDbJson(result.first);
    } else {
      throw LocalDatabaseException(
          message: "No Entry in Food Table with EAN = $ean");
    }
  }

  @override
  Future<List<FoodEntity>> getFoodList(String? date) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps;

    if (date != null) {
      //(await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
      //  print(row.values);
      //});
      String sql =
          "SELECT * FROM log INNER JOIN food ON log.f_ean=food.f_ean WHERE l_date LIKE '$date%' ORDER BY l_date DESC ";
      maps = await db.rawQuery(sql, null);
    } else {
      maps = await db.query('food', orderBy: 'f_name');
    }

    if (maps.isNotEmpty) {
      return maps.map((c) => FoodModel.fromDbJson(c)).toList();
    } else {
      throw LocalDatabaseException(message: "No saved Logs at that day");
    }
  }

  @override
  Future<LogEntity> getLog(int id) async {
    Database db = await instance.database;
    var result = await db.query('log', where: 'l_id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return LogModel.fromDbJson(result.first);
    } else {
      throw LocalDatabaseException(message: "Log with ID=$id does not exist");
    }
  }

  @override
  Future<List<LogEntity>> getLogList() async {
    Database db = await instance.database;
    var query = await db.query('log', orderBy: 'l_date');
    if (query.isNotEmpty) {
      return query.map((c) => LogModel.fromDbJson(c)).toList();
    } else {
      //evtl mit try catch mit DatabaseException
      throw LocalDatabaseException(message: "Log Table is empty");
    }
  }

  @override
  Future<List<MealEntity>> getMealList(String date) async {
    Database db = await instance.database;
    var logQuery =
        await db.rawQuery("select * from log WHERE l_date LIKE '$date%'");
    List<LogModel> logList = <LogModel>[];
    List<MealModel> mealList = <MealModel>[];

    if (logQuery.isNotEmpty) {
      print("->${logQuery.first}");
      logList = logQuery.map((c) => LogModel.fromDbJson(c)).toList();
    } else {
      throw ResultEmptyException();
      //return mealList;
    }

    Logger().d("Number of results from Log ${logList.length}");

    await Future.forEach(logList, (LogModel log) async {
      var query = await db
          .query('food', where: "f_ean = ?", whereArgs: [log.ean.toString()]);
      print("+>${query.first}");
      FoodModel food = FoodModel.fromDbJson(query.first);
      Logger().d("FoodModel: $food");
      mealList.add(MealModel(food: food, log: log));
    });

    Logger().d("Number of results from Meal${mealList.length}");
    return mealList;
  }

  @override
  Future<int> insertToFoodTable(FoodModel foodModel) async {
    Database db = await instance.database;
    return await db.insert('food', foodModel.toDbJson());
  }

  @override
  Future<int> insertToLogTable(LogModel logModel) async {
    String date;
    (logModel.date != null) ? date = "'${logModel.date!}'" : date = "datetime('now','localtime')";

    String sql =
        "INSERT INTO log VALUES (${logModel.id},${logModel.ean}, ${logModel.amount}, $date, '${logModel.type}');";
    print("->$sql");
    Database db = await instance.database;
    //return await db.insert('log', logModel.toDbJson());
    return await db.rawInsert(sql, null);
    //return Future.value(-1);
  }

  @override
  Future<int> updateFoodInTable(FoodModel foodModel) async {
    Database db = await instance.database;

    return await db.update('food', foodModel.toDbJson(),
        where: "f_ean = ?", whereArgs: [foodModel.ean]);
  }

  @override
  Future<int> updateLogInTable(LogModel logModel) async {
    Database db = await instance.database;
    return await db.update('log', logModel.toDbJson(),
        where: "l_id = ?", whereArgs: [logModel.id]);
  }

  @override
  Future<int> deleteLogInTable(int id) async {
    Database db = await instance.database;
    return await db.delete('log', where: 'l_id = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateFoodWithSource() {
    // TODO: implement updateFoodWithSource
    throw UnimplementedError();
  }

  Future<void> close() async {
    // Close the database
    await instance.close();
  }
}
