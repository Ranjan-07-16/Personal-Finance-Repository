import 'package:flutter/material.dart';

// --- MOCK DATA AND UTILITIES ---
class UserData {
  static String username = "FinanceGuru";
  static String email = "guru@finance.com";
  static String profilePicUrl = "https://placehold.co/100x100/4c4c4c/ffffff?text=FG";
}

class FinancialData {
  static const List<Map<String, dynamic>> expenseData = [
    {'category': 'Housing', 'amount': 1500.0, 'color': Colors.red},
    {'category': 'Food', 'amount': 500.0, 'color': Colors.orange},
    {'category': 'Savings', 'amount': 800.0, 'color': Colors.blue},
    {'category': 'Entertainment', 'amount': 200.0, 'color': Colors.purple},
  ];

  static const List<Map<String, dynamic>> incomeData = [
    {'source': 'Salary', 'amount': 5000.0, 'color': Colors.green},
    {'source': 'Freelance', 'amount': 1500.0, 'color': Colors.lightGreen},
    {'source': 'Investments', 'amount': 500.0, 'color': Colors.teal},
  ];
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
        '/expenses_detail': (context) => const DetailScreen(title: "My Expenses Detail"),
        '/income_detail': (context) => const DetailScreen(title: "My Income Detail"),
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  void _authenticate() {
    // Mock authentication logic: In a real app, this would call Firebase Auth or a backend API.
    // For this demonstration, we simulate success and navigate immediately.
    final String action = _isLogin ? 'Logged in' : 'Signed up';
    print('$action with ${_emailController.text}');

    // Navigate to Dashboard
    Navigator.of(context).pushReplacementNamed('/dashboard');
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
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _authenticate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                tag: 'profilePic', // Tag for hero animation
                child: CircleAvatar(
                  backgroundImage: NetworkImage(UserData.profilePicUrl),
                  radius: 20,
                  backgroundColor: Colors.white,
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
                      data: FinancialData.expenseData,
                      total: FinancialData.expenseData.fold(0.0, (sum, item) => sum + item['amount']),
                    ),
                  ),
                  // 4. My Income Pie Chart
                  _ChartTile(
                    title: "Income Sources",
                    chart: SimplePieChart(
                      data: FinancialData.incomeData,
                      total: FinancialData.incomeData.fold(0.0, (sum, item) => sum + item['amount']),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomPaint(
        painter: PieChartPainter(data: data, total: total),
        child: Container(),
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
    double startAngle = -90.0; // Start from the top

    for (var item in data) {
      final amount = item['amount'] as double;
      final color = item['color'] as Color;
      final sweepAngle = (amount / total) * 360.0; // Angle in degrees

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Draw the arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _degreesToRadians(startAngle),
        _degreesToRadians(sweepAngle),
        true, // draw a closed pie piece
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
    setState(() {
      UserData.username = _usernameController.text;
      _isEditing = false;
    });
    // In a real app: save to backend/database
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
                tag: 'profilePic', // Tag for hero animation
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.indigo,
                  backgroundImage: NetworkImage(UserData.profilePicUrl),
                ),
              ),
              const SizedBox(height: 20),
              // Username Field
              _isEditing
                  ? TextField(
                      controller: _usernameController,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
              // Edit/Save Button
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Placeholder for other settings
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.indigo),
                title: const Text('App Settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate back to AuthScreen
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 4. DETAIL SCREENS (Placeholders) ---

class DetailScreen extends StatelessWidget {
  final String title;
  const DetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              title.contains("Expenses") ? Icons.wallet : Icons.trending_up,
              size: 80,
              color: title.contains("Expenses") ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              'Detail view for $title',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text('Here you would manage, add, or view transaction history.'),
          ],
        ),
      ),
    );
  }
}
