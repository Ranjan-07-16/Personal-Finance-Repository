import 'package:flutter/material.dart';

class Income {
  final int? id;
  final double amount;
  final String source;
  final String reason;
  final Color color;
  final DateTime date;

  Income({
    this.id,
    required this.amount,
    required this.source,
    required this.reason,
    required this.color,
    required this.date,
  });
}
