import 'package:flutter/material.dart';

import '../../../../db/db_helper.dart';
import '../domain/expense.dart';
import '../domain/expense_repository.dart';

/// SQLite-backed implementation of [ExpenseRepository].
/// All knowledge of the database schema lives here.
class SqliteExpenseRepository implements ExpenseRepository {
  const SqliteExpenseRepository();

  @override
  Future<List<Expense>> getAllExpenses() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('expenses', orderBy: 'dateMs DESC');
    return rows
        .map((row) => Expense(
              id: row['id'] as int?,
              amount: (row['amount'] as num).toDouble(),
              category: row['category'] as String,
              reason: row['reason'] as String,
              color: Color(row['colorValue'] as int),
              date: DateTime.fromMillisecondsSinceEpoch(row['dateMs'] as int),
            ))
        .toList();
  }

  @override
  Future<int> insertExpense(Expense expense) async {
    final db = await DatabaseHelper.instance.database;
    return db.insert('expenses', {
      'amount': expense.amount,
      'category': expense.category,
      'reason': expense.reason,
      'colorValue': expense.color.value,
      'dateMs': expense.date.millisecondsSinceEpoch,
    });
  }

  @override
  Future<int> deleteExpense(int id) async {
    final db = await DatabaseHelper.instance.database;
    return db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> clearAllExpenses() async {
    final db = await DatabaseHelper.instance.database;
    return db.delete('expenses');
  }
}
