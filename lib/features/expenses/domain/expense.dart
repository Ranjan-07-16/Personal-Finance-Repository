import 'package:flutter/material.dart';

class Expense {
  final int? id;
  final double amount;
  final String category;
  final String reason;
  final Color color;
  final DateTime date;

  const Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.reason,
    required this.color,
    required this.date,
  });
}
