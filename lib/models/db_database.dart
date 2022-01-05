import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbDatabase {
  static const _dbName = 'allDatabase.db';
  static const _expenseTable = 'Expenses';
  static const _incomeTable = 'Income';
  static const _dateTable = 'Date';

  static const exId = 'id';
  static const exTitle = 'title';
  static const exCategory = 'category';
  static const exDescription = 'name';
  static const exDate = 'date';
  static const exAmount = 'Amount';

  static const inId = 'id';
  static const inAmount = 'Amount';
  static const inDate = 'date';
  static const inCategory = 'category';

  static const dateId = 'id';
  static const date = 'date';

  DbDatabase.privateConstructor();
  static final DbDatabase instance = DbDatabase.privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbpath = path.join(directory.path, _dbName);
    return await openDatabase(dbpath, version: 2, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_expenseTable (
      $exId TEXT PRIMARY KEY,
      $exTitle TEXT NOT NULL,
      $exCategory TEXT NOT NULL,
      $exDescription TEXT,
      $exDate TEXT NOT NULL,
      $exAmount INTEGER NOT NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE $_incomeTable (
      $inId TEXT PRIMARY KEY,
      $inCategory TEXT NOT NULL,
      $inDate TEXT NOT NULL,
      $inAmount INTEGER NOT NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE $_dateTable (
      $dateId TEXT PRIMARY KEY,
      $date TEXT NOT NULL
      )
      ''');
  }

  Future<int> insertExpense(Map<String, dynamic> data) async {
    Database? db = await instance.database;
    return await db!.insert(_expenseTable, data);
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    Database? db = await instance.database;
    return await db!.query(_expenseTable);
  }

  Future<int> deleteExpense(String id) async {
    Database? db = await instance.database;
    return await db!.delete(_expenseTable, where: '$exId = ?', whereArgs: [id]);
  }

  Future<int> insertIncome(Map<String, dynamic> data) async {
    Database? db = await instance.database;
    return await db!.insert(_incomeTable, data);
  }

  Future<List<Map<String, dynamic>>> getIncome() async {
    Database? db = await instance.database;
    return await db!.query(_incomeTable);
  }

  Future<int> deleteIncome(String id) async {
    Database? db = await instance.database;
    return await db!.delete(_incomeTable, where: '$exId = ?', whereArgs: [id]);
  }

  Future<int> insertDate(Map<String, dynamic> data) async {
    Database? db = await instance.database;
    return await db!.insert(_dateTable, data);
  }

  Future<int> updateDate(Map<String, dynamic> data) async {
    Database? db = await instance.database;
    String id = data[dateId];

    return await db!
        .update(_dateTable, data, where: '$dateId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getDate() async {
    Database? db = await instance.database;
    return await db!.query(_dateTable);
  }
}
