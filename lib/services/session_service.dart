import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _keyUsername = 'session_username';
  static const _keyEmail = 'session_email';

  static Future<void> saveSession(String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyEmail, email);
  }

  static Future<Map<String, String>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_keyUsername);
    final email = prefs.getString(_keyEmail);
    if (username != null && email != null) {
      return {'username': username, 'email': email};
    }
    return null;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyEmail);
  }
}
