import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/db_helper.dart';
import '../models/income.dart';

/// All income entries from SQLite, newest first.
final incomeProvider = FutureProvider<List<Income>>((ref) async {
  return DatabaseHelper.instance.getAllIncome();
});

/// Income grouped by source for the pie chart.
final incomeChartDataProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final income = ref.watch(incomeProvider).valueOrNull ?? [];
  final Map<String, double> totals = {};
  final Map<String, Color> colors = {};
  for (final item in income) {
    totals.update(item.source, (v) => v + item.amount,
        ifAbsent: () => item.amount);
    colors[item.source] = item.color;
  }
  return totals.entries
      .map((e) => <String, dynamic>{
            'source': e.key,
            'amount': e.value,
            'color': colors[e.key]!,
          })
      .toList();
});

/// Running total of all income.
final totalIncomeProvider = Provider<double>((ref) {
  final chartData = ref.watch(incomeChartDataProvider);
  return chartData.fold(0.0, (sum, e) => sum + (e['amount'] as double));
});
