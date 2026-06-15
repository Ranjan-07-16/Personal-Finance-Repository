import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/user_data.dart';
import 'services/session_service.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'features/expenses/presentation/screens/expenses_screen.dart';
import 'screens/income_screen.dart';
import 'screens/account_center_screen.dart';
import 'screens/help_screen.dart';
import 'screens/account_status_screen.dart';
import 'screens/about_screen.dart';
import 'screens/add_account_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restore session so UserData is populated before the first frame.
  final session = await SessionService.getSession();
  if (session != null) {
    UserData.username = session['username']!;
    UserData.email = session['email']!;
  }

  runApp(ProviderScope(
    child: FinanceApp(startRoute: session != null ? '/dashboard' : '/'),
  ));
}

class FinanceApp extends StatelessWidget {
  final String startRoute;

  const FinanceApp({super.key, required this.startRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      initialRoute: startRoute,
      routes: {
        '/': (context) => const AuthScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/expenses_detail': (context) => const ExpensesScreen(),
        '/income_detail': (context) => const IncomeScreen(),
        '/account_center': (context) => const AccountCenterScreen(),
        '/help': (context) => const HelpScreen(),
        '/account_status': (context) => const AccountStatusScreen(),
        '/about': (context) => const AboutScreen(),
        '/add_account': (context) => const AddAccountScreen(),
      },
    );
  }
}
