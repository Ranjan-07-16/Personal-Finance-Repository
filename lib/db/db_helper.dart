import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/income.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finance_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        email    TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        username TEXT NOT NULL DEFAULT ''
      )
    ''');
    await db.execute('''
      CREATE TABLE expenses (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        amount   REAL    NOT NULL,
        category TEXT    NOT NULL,
        reason   TEXT    NOT NULL,
        colorValue INTEGER NOT NULL,
        dateMs   INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE income (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        amount   REAL    NOT NULL,
        source   TEXT    NOT NULL,
        reason   TEXT    NOT NULL,
        colorValue INTEGER NOT NULL,
        dateMs   INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS expenses (
          id       INTEGER PRIMARY KEY AUTOINCREMENT,
          amount   REAL    NOT NULL,
          category TEXT    NOT NULL,
          reason   TEXT    NOT NULL,
          colorValue INTEGER NOT NULL,
          dateMs   INTEGER NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS income (
          id       INTEGER PRIMARY KEY AUTOINCREMENT,
          amount   REAL    NOT NULL,
          source   TEXT    NOT NULL,
          reason   TEXT    NOT NULL,
          colorValue INTEGER NOT NULL,
          dateMs   INTEGER NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      // Add username column; existing rows get an empty string default.
      await db.execute(
        "ALTER TABLE users ADD COLUMN username TEXT NOT NULL DEFAULT ''",
      );
    }
  }

  // ─── INCOME CRUD ────────────────────────────────────────────────────────────

  Future<int> insertIncome(Income income) async {
    final db = await instance.database;
    return db.insert('income', {
      'amount': income.amount,
      'source': income.source,
      'reason': income.reason,
      'colorValue': income.color.value,
      'dateMs': income.date.millisecondsSinceEpoch,
    });
  }

  Future<List<Income>> getAllIncome() async {
    final db = await instance.database;
    final rows = await db.query('income', orderBy: 'dateMs DESC');
    return rows
        .map((row) => Income(
              id: row['id'] as int?,
              amount: (row['amount'] as num).toDouble(),
              source: row['source'] as String,
              reason: row['reason'] as String,
              color: Color(row['colorValue'] as int),
              date: DateTime.fromMillisecondsSinceEpoch(row['dateMs'] as int),
            ))
        .toList();
  }

  Future<int> deleteIncome(int id) async {
    final db = await instance.database;
    return db.delete('income', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clearAllIncome() async {
    final db = await instance.database;
    return db.delete('income');
  }

  // ─── CHART / AGGREGATION ────────────────────────────────────────────────────

  // Groups income rows by source for the dashboard pie chart, mirroring the
  // former FinancialData.incomeData getter.
  Future<List<Map<String, dynamic>>> getIncomeGroupedBySource() async {
    final all = await getAllIncome();
    final Map<String, double> totals = {};
    final Map<String, Color> colors = {};
    for (final item in all) {
      totals.update(item.source, (v) => v + item.amount,
          ifAbsent: () => item.amount);
      colors[item.source] = item.color;
    }
    return totals.entries
        .map((e) => {
              'source': e.key,
              'amount': e.value,
              'color': colors[e.key]!,
            })
        .toList();
  }

  // ─── USER AUTH ──────────────────────────────────────────────────────────────

  /// Inserts a new user. Row must contain 'email', 'password', 'username'.
  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return db.insert('users', row);
  }

  /// Returns the matching user row or null if credentials are wrong.
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Returns an existing row for [email], used to detect duplicate signups.
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
