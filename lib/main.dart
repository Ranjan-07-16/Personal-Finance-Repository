import 'package:flutter/material.dart';

// --- DATA MODELS (Simplified for in-memory use) ---

class Expense {
  final double amount;
  final String category;
  final String reason;
  final Color color;
  final DateTime date;

  Expense({
    required this.amount,
    required this.category,
    required this.reason,
    required this.color,
    required this.date,
  });
}

class Income {
  final double amount;
  final String source;
  final String reason;
  final Color color;
  final DateTime date;

  Income({
    required this.amount,
    required this.source,
    required this.reason,
    required this.color,
    required this.date,
  });
}

// --- MOCK DATA AND UTILITIES (In-Memory Storage) ---

class UserData {
  static String username = "DartPad User";
  static String email = "dartpad@finance.com";
  // BUG FIX 2: Changed to use a solid color/icon placeholder instead of a placeholder URL
  static const IconData defaultProfileIcon = Icons.person; 
}

class FinancialData {
  // Define categories and colors for selection
  static const Map<String, Color> expenseCategories = {
    'Food': Colors.orange,
    'Housing': Colors.red,
    'Entertainment': Colors.purple,
    'Clothing': Colors.blue,
    'Transport': Colors.teal,
    'Custom': Colors.grey, 
  };
  
  // BUG FIX 1: Cleared the initial mock data lists
  static List<Expense> allExpenses = [];
  static List<Income> allIncome = [];
  
  // Dynamic calculation of total expenses
  static double get totalExpenses => allExpenses.fold(0.0, (sum, item) => sum + item.amount);
  static double get totalIncome => allIncome.fold(0.0, (sum, item) => sum + item.amount);

  // Income Sources
  static const Map<String, Color> incomeSources = {
    'Salary': Colors.green,
    'Freelance': Colors.lightGreen,
    'Investments': Colors.teal,
    'Bonus': Colors.blueAccent,
    'Gift': Colors.amber,
    'Custom': Colors.grey,
  };

  // Dynamic grouping for the income Pie Chart
  static List<Map<String, dynamic>> get incomeData {
    final Map<String, double> groupedIncome = {};
    for (var income in allIncome) {
      groupedIncome.update(income.source, (value) => value + income.amount, ifAbsent: () => income.amount);
    }

    return groupedIncome.entries.map((entry) {
      return {
        'source': entry.key,
        'amount': entry.value,
        'color': incomeSources[entry.key] ?? Colors.green,
      };
    }).toList();
  }
}

// --- MAIN APPLICATION SETUP ---

void main() {
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

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
      initialRoute: '/',
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

// --- 1. AUTHENTICATION SCREEN ---

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController(text: UserData.email);
  final TextEditingController _passwordController = TextEditingController(text: '123456');
  final TextEditingController _usernameController = TextEditingController(text: UserData.username);
  bool _isLogin = true;

  void _authenticate() {
    // Update in-memory static data
    UserData.username = _usernameController.text;
    UserData.email = _emailController.text;

    // Navigate to Dashboard
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Welcome Back!' : 'Create Account'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                _isLogin ? 'Login' : 'Sign Up',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              if (!_isLogin) ...[
                TextField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _authenticate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _isLogin ? 'Login' : 'Sign Up',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(
                  _isLogin
                      ? 'New user? Create an account'
                      : 'Already have an account? Login',
                  style: TextStyle(color: Colors.indigo.shade400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 2. DASHBOARD SCREEN ---

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Helper to force a dashboard refresh
  static void reloadDashboard(BuildContext context) {
    // Simply pop and push to force a full rebuild with new in-memory data
    Navigator.of(context).pop(); 
    Navigator.of(context).pushNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/profile');
              },
              child: Hero(
                tag: 'profilePic',
                // BUG FIX 2: Use an Icon instead of a NetworkImage/URL
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(UserData.defaultProfileIcon, color: Colors.indigo, size: 28),
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
              "Welcome, ${UserData.username}!",
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
                  // 1. My Expenses Text Tile
                  _DashboardTile(
                    title: "My Expenses",
                    icon: Icons.money_off,
                    color: Colors.red.shade400,
                    onTap: () => Navigator.of(context).pushNamed('/expenses_detail'),
                  ),
                  // 2. My Income Text Tile
                  _DashboardTile(
                    title: "My Income",
                    icon: Icons.attach_money,
                    color: Colors.green.shade400,
                    onTap: () => Navigator.of(context).pushNamed('/income_detail'),
                  ),
                  // 3. My Expenses Pie Chart 
                  _ChartTile(
                    title: "Expenses Breakdown",
                    chart: SimplePieChart(
                      data: FinancialData.allExpenses.map((e) => {'category': e.category, 'amount': e.amount, 'color': e.color}).toList(),
                      total: FinancialData.totalExpenses,
                    ),
                  ),
                  // 4. My Income Pie Chart
                  _ChartTile(
                    title: "Income Sources",
                    chart: SimplePieChart(
                      data: FinancialData.incomeData,
                      total: FinancialData.totalIncome,
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

// Widget for the clickable tiles (Row 1)
class _DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for the chart tiles (Row 2)
class _ChartTile extends StatelessWidget {
  final String title;
  final Widget chart;

  const _ChartTile({required this.title, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }
}

// --- PIE CHART VISUAL REPRESENTATION (CustomPaint) ---

class SimplePieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final double total;

  const SimplePieChart({super.key, required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    // FIX: Using AspectRatio (1:1) to constrain the size and prevent overflow
    return AspectRatio(
      aspectRatio: 1.0, 
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomPaint(
          painter: PieChartPainter(data: data, total: total),
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double total;

  PieChartPainter({required this.data, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    double startAngle = -90.0; 

    if (total == 0) {
      // Draw a grey circle if there is no data
       final paint = Paint()
        ..color = Colors.grey.shade300
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, paint);
      return;
    }

    for (var item in data) {
      final amount = item['amount'] as double;
      final color = item['color'] as Color;
      final sweepAngle = (amount / total) * 360.0;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _degreesToRadians(startAngle),
        _degreesToRadians(sweepAngle),
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180.0);
  }

  @override
  bool shouldRepaint(covariant PieChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

// --- 3. PROFILE SCREEN ---

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _usernameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: UserData.username);
  }

  void _saveProfile() {
    // Update local state and in-memory static data
    setState(() {
      UserData.username = _usernameController.text;
      _isEditing = false;
    });
    
    // Inform user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'profilePic',
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.indigo,
                  child: Icon(UserData.defaultProfileIcon, color: Colors.white, size: 70),
                ),
              ),
              const SizedBox(height: 20),
              _isEditing
                  ? TextField(
                    controller: _usernameController,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  )
                  : Text(
                    UserData.username,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
              const SizedBox(height: 8),
              Text(
                UserData.email,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  if (_isEditing) {
                    _saveProfile();
                  } else {
                    setState(() {
                      _isEditing = true;
                    });
                  }
                },
                icon: Icon(_isEditing ? Icons.save : Icons.edit),
                label: Text(_isEditing ? 'Save Profile' : 'Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditing ? Colors.green : Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              
              Column(
                children: [
                  // 1. Account Centre
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.indigo),
                    title: const Text('Account Centre'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.of(context).pushNamed('/account_center'),
                  ),
                  const Divider(),

                  // 2. Settings (Existing)
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.indigo),
                    title: const Text('App Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  const Divider(),
                  
                  // 3. Help
                  ListTile(
                    leading: const Icon(Icons.contact_support_outlined, color: Colors.indigo),
                    title: const Text('Help'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.of(context).pushNamed('/help'),
                  ),
                  const Divider(),
                  
                  // 4. Account Status
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined, color: Colors.indigo),
                    title: const Text('Account Status'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.of(context).pushNamed('/account_status'),
                  ),
                  const Divider(),
                  
                  // 5. About
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.indigo),
                    title: const Text('About'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.of(context).pushNamed('/about'),
                  ),
                  const Divider(),
                  
                  // 6. Add Account
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline, color: Colors.indigo),
                    title: const Text('Add Account'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.of(context).pushNamed('/add_account'),
                  ),
                  const Divider(),

                  // 7. Log out (Existing)
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- NEW SCREENS ---

// 1. Account Centre Page
class AccountCenterScreen extends StatelessWidget {
  const AccountCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Centre'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Manage your connected experiences and account settings",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.indigo,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // Account Block
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Primary Account',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,
                        child: Icon(UserData.defaultProfileIcon, color: Colors.indigo, size: 24),
                      ),
                      title: Text(UserData.username),
                      subtitle: Text(UserData.email),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {},
                    ),
                    const Divider(),
                    const Text('Linked Experiences coming soon...', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. Help Page
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _HelpCard(
              icon: Icons.question_answer_outlined,
              title: "FAQ's",
              subtitle: "Find answers to frequently asked questions.",
              onTap: () {},
              color: Colors.green.shade400,
            ),
            _HelpCard(
              icon: Icons.support_agent_outlined,
              title: "Help Centre",
              subtitle: "Contact our support team for personalized assistance.",
              onTap: () {},
              color: Colors.blue.shade400,
            ),
            _HelpCard(
              icon: Icons.rate_review_outlined,
              title: "Tell us how we're doing",
              subtitle: "Provide feedback on your experience.",
              onTap: () {},
              color: Colors.orange.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable card widget for HelpScreen
class _HelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const _HelpCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 25,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}


// 3. Account Status Page
class AccountStatusScreen extends StatelessWidget {
  const AccountStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Status'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Hero(
                  tag: 'profilePic',
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.indigo,
                    child: Icon(UserData.defaultProfileIcon, color: Colors.white, size: 80),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                UserData.username,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Status: Active',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Your account is in good standing and all features are available.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. About Page
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Finance Tracker App',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Version 1.0.0 (DartPad Edition)',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
            const Divider(height: 30),
            
            Text(
              'Our Mission',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              // Placeholder text
              'The Finance Tracker App is designed to provide you with a simple, secure, and intuitive way to manage your daily income and expenses. Our mission is to empower individuals to take control of their financial well-being through clear data visualization and historical tracking.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            
            Text(
              'Technology Used',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              // Placeholder text
              'This application is built entirely using the Flutter framework, ensuring a consistent experience across mobile platforms. In this DartPad version, all data is stored temporarily in memory and will reset upon page refresh.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 40),

            Center(
              child: Text(
                '© 2025 Finance Tracker Team',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 5. Add Account Page (Shows a Dialog immediately)
class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to show the dialog after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAddAccountDialog(context);
    });
  }

  Future<void> _showAddAccountDialog(BuildContext context) async {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add New Account'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'This feature requires external storage (Simulated).',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(); // Go back to profile screen
              },
            ),
            FilledButton(
              onPressed: () {
                // Simulate account creation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Account for ${usernameController.text} added (Simulated).')),
                );
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(); // Go back to profile screen
              },
              child: const Text('Create Account'),
            ),
          ],
        );
      },
    );
  }

  // The build method just renders an empty screen before the dialog pops up
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: const Center(
        child: Text('Loading account form...'),
      ),
    );
  }
}


// --- 4. EXPENSES SCREEN ---

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  Map<String, dynamic>? _newExpenseData;

  void _refreshData() {
    // Simply call setState to rebuild the list
    setState(() {}); 
    DashboardScreen.reloadDashboard(context); // Also refresh the dashboard totals
  }

  // BUG FIX 3: Removed the navigation command inside _addExpense
  void _addExpense() {
    if (_newExpenseData != null && _newExpenseData!['amount'] > 0) {
      final newExpense = Expense(
        amount: _newExpenseData!['amount'],
        category: _newExpenseData!['category'],
        reason: _newExpenseData!['reason'],
        color: _newExpenseData!['color'],
        date: DateTime.now(),
      );
      
      FinancialData.allExpenses.insert(0, newExpense); // Add to in-memory list
      _refreshData(); // Triggers rebuild and updates dashboard charts

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added! (In-memory)')),
      );
      // NO NAVIGATION HERE: Stays on ExpensesScreen
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category and enter an amount.')),
        );
    }
  }

  void _clearExpenses() {
    FinancialData.allExpenses.clear();
    _refreshData();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All expenses cleared from in-memory history!')),
    );
  }

  Future<void> _showAddExpenseDialog() async {
    double? expenseAmount;
    String? selectedCategory;
    TextEditingController amountController = TextEditingController();
    TextEditingController reasonController = TextEditingController();
    
    _newExpenseData = null;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              title: const Text('Add New Expense'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount (\$)',
                        prefixIcon: Icon(Icons.monetization_on),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          expenseAmount = double.tryParse(value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ...FinancialData.expenseCategories.keys.map((category) {
                      final color = FinancialData.expenseCategories[category]!;
                      return ListTile(
                        leading: Icon(
                          selectedCategory == category ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: color,
                        ),
                        title: Text(category),
                        onTap: () {
                          setModalState(() {
                            selectedCategory = category;
                          });
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    TextField(
                      controller: reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Custom Message/Reason',
                        prefixIcon: Icon(Icons.chat_bubble_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FilledButton(
                  onPressed: selectedCategory != null && expenseAmount != null && expenseAmount! > 0
                      ? () {
                          _newExpenseData = {
                            'amount': expenseAmount!,
                            'category': selectedCategory!,
                            'reason': reasonController.text.isEmpty ? selectedCategory! : reasonController.text,
                            'color': FinancialData.expenseCategories[selectedCategory!]!,
                          };
                          Navigator.of(context).pop();
                          _addExpense();
                        }
                      : null,
                  child: const Text('Add Expense'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'Total: \$${FinancialData.totalExpenses.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear All Expenses (In-memory)',
            onPressed: FinancialData.allExpenses.isNotEmpty
                ? _clearExpenses
                : null,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FinancialData.allExpenses.isEmpty
            ? const Center(child: Text('No expenses recorded. Tap + to add one!'))
            : ListView.builder(
                itemCount: FinancialData.allExpenses.length,
                itemBuilder: (context, index) {
                  final expense = FinancialData.allExpenses[index];
                  return _ExpenseBlock(expense: expense);
                },
              ),
      ),
    );
  }
}

// Widget for the column blocks (Expense Block)
class _ExpenseBlock extends StatelessWidget {
  final Expense expense;

  const _ExpenseBlock({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: expense.color.withOpacity(0.5), width: 2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          backgroundColor: expense.color,
          radius: 25,
          child: Text(
            '\$',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '-\$${expense.amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
          ),
        ),
        subtitle: Text(
          expense.reason,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              expense.category,
              style: TextStyle(color: expense.color, fontWeight: FontWeight.bold),
            ),
            Text(
              '${expense.date.month}/${expense.date.day}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

// --- 5. INCOME SCREEN ---

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  Map<String, dynamic>? _newIncomeData;

  void _refreshData() {
    // Simply call setState to rebuild the list
    setState(() {}); 
    DashboardScreen.reloadDashboard(context); // Also refresh the dashboard totals
  }

  // BUG FIX 3: Removed the navigation command inside _addIncome
  void _addIncome() {
    if (_newIncomeData != null && _newIncomeData!['amount'] > 0) {
      final newIncome = Income(
        amount: _newIncomeData!['amount'],
        source: _newIncomeData!['source'],
        reason: _newIncomeData!['reason'],
        color: _newIncomeData!['color'],
        date: DateTime.now(),
      );

      FinancialData.allIncome.insert(0, newIncome); // Add to in-memory list
      _refreshData(); // Triggers rebuild and updates dashboard charts

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Income added! (In-memory)')),
      );
      // NO NAVIGATION HERE: Stays on IncomeScreen
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a source and enter an amount.')),
        );
    }
  }

  void _clearIncome() {
    FinancialData.allIncome.clear();
    _refreshData();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All income cleared from in-memory history!')),
    );
  }

  Future<void> _showAddIncomeDialog() async {
    double? incomeAmount;
    String? selectedSource;
    TextEditingController amountController = TextEditingController();
    TextEditingController reasonController = TextEditingController();
    
    _newIncomeData = null;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              title: const Text('Add New Income'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Amount Input
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount (\$)',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          incomeAmount = double.tryParse(value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Source Selection List
                    ...FinancialData.incomeSources.keys.map((source) {
                      final color = FinancialData.incomeSources[source]!;
                      return ListTile(
                        leading: Icon(
                          selectedSource == source ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: color,
                        ),
                        title: Text(source),
                        onTap: () {
                          setModalState(() {
                            selectedSource = source;
                          });
                        },
                      );
                    }).toList(),
                    // Custom Message Input (Reason)
                    const SizedBox(height: 16),
                    TextField(
                      controller: reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Custom Message/Reason',
                        prefixIcon: Icon(Icons.chat_bubble_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FilledButton(
                  onPressed: selectedSource != null && incomeAmount != null && incomeAmount! > 0
                      ? () {
                          _newIncomeData = {
                            'amount': incomeAmount!,
                            'source': selectedSource!,
                            'reason': reasonController.text.isEmpty ? selectedSource! : reasonController.text,
                            'color': FinancialData.incomeSources[selectedSource!]!,
                          };
                          Navigator.of(context).pop(); 
                          _addIncome();
                        }
                      : null, 
                  child: const Text('Add Income'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Income'),
        // Dynamic summary and CLEAR BUTTON
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'Total: \$${FinancialData.totalIncome.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // CLEAR BUTTON IMPLEMENTATION
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear All Income (In-memory)',
            onPressed: FinancialData.allIncome.isNotEmpty
                ? _clearIncome // Enabled if list is not empty
                : null, // Disabled if list is empty
          ),
        ],
      ),
      // Floating Action Button is automatically fixed to the bottom
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddIncomeDialog,
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FinancialData.allIncome.isEmpty
            ? const Center(child: Text('No income recorded. Tap + to add one!'))
            : ListView.builder(
                itemCount: FinancialData.allIncome.length,
                itemBuilder: (context, index) {
                  final income = FinancialData.allIncome[index];
                  return _IncomeBlock(income: income);
                },
              ),
      ),
    );
  }
}

// Widget for the income column blocks (Income Block)
class _IncomeBlock extends StatelessWidget {
  final Income income;

  const _IncomeBlock({required this.income});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: income.color.withOpacity(0.5), width: 2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          backgroundColor: income.color,
          radius: 25,
          child: const Icon(
            Icons.trending_up,
            color: Colors.white,
          ),
        ),
        title: Text(
          '+\$${income.amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        subtitle: Text(
          income.reason,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              income.source,
              style: TextStyle(color: income.color, fontWeight: FontWeight.bold),
            ),
            Text(
              '${income.date.month}/${income.date.day}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
