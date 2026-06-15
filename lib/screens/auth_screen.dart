import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/db_helper.dart';
import '../providers/auth_providers.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  // ─── Validation ─────────────────────────────────────────────────────────────

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Returns an error string, or null if all fields are valid.
  String? _validate() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final username = _usernameController.text.trim();

    if (!_isLogin && username.isEmpty) {
      return 'Please enter a username.';
    }
    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }
    if (password.isEmpty) {
      return 'Please enter a password.';
    }
    if (!_isLogin && password.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  // ─── Auth logic ─────────────────────────────────────────────────────────────

  Future<void> _authenticate() async {
    final validationError = _validate();
    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLogin) {
        await _login();
      } else {
        await _signUp();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final row = await DatabaseHelper.instance.login(email, password);
    if (row == null) {
      if (mounted) {
        setState(() => _errorMessage = 'Invalid email or password.');
      }
      return;
    }

    // Restore the stored username; fall back to the email prefix for accounts
    // that pre-date the username column.
    final storedUsername = (row['username'] as String?) ?? '';
    final username =
        storedUsername.isNotEmpty ? storedUsername : email.split('@').first;

    await ref.read(userProvider.notifier).setUser(username, email);

    if (mounted) Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final username = _usernameController.text.trim();

    final existing = await DatabaseHelper.instance.getUserByEmail(email);
    if (existing != null) {
      if (mounted) {
        setState(
            () => _errorMessage = 'An account with this email already exists.');
      }
      return;
    }

    await DatabaseHelper.instance.insertUser({
      'email': email,
      'password': password,
      'username': username,
    });

    await ref.read(userProvider.notifier).setUser(username, email);

    if (mounted) Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  // ─── UI ─────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
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

              // Username — signup only
              if (!_isLogin) ...[
                TextField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _authenticate(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  helperText: _isLogin ? null : 'Minimum 6 characters',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

              // Inline error message
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.red.shade700, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                              color: Colors.red.shade700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _authenticate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.indigo.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _isLogin ? 'Login' : 'Sign Up',
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: _isLoading
                    ? null
                    : () => setState(() {
                          _isLogin = !_isLogin;
                          _errorMessage = null;
                        }),
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
