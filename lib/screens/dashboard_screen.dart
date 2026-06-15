import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_data.dart';
import '../features/expenses/presentation/providers/expense_providers.dart';
import '../providers/auth_providers.dart';
import '../providers/financial_providers.dart';
import '../widgets/dashboard_tile.dart';
import '../widgets/chart_tile.dart';
import '../widgets/simple_pie_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final expensesChartData = ref.watch(expensesChartDataProvider);
    final incomeChartData = ref.watch(incomeChartDataProvider);
    final totalExpenses = ref.watch(totalExpensesProvider);
    final totalIncome = ref.watch(totalIncomeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('/profile'),
              child: Hero(
                tag: 'profilePic',
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(UserData.defaultProfileIcon,
                      color: Colors.indigo, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, ${user.username}!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: <Widget>[
                  DashboardTile(
                    title: "My Expenses",
                    icon: Icons.money_off,
                    color: Colors.red.shade400,
                    onTap: () =>
                        Navigator.of(context).pushNamed('/expenses_detail'),
                  ),
                  DashboardTile(
                    title: "My Income",
                    icon: Icons.attach_money,
                    color: Colors.green.shade400,
                    onTap: () =>
                        Navigator.of(context).pushNamed('/income_detail'),
                  ),
                  ChartTile(
                    title: "Expenses Breakdown",
                    chart: SimplePieChart(
                      data: expensesChartData,
                      total: totalExpenses,
                    ),
                  ),
                  ChartTile(
                    title: "Income Sources",
                    chart: SimplePieChart(
                      data: incomeChartData,
                      total: totalIncome,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
