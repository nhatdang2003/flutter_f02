import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static const String TOKEN_KEY = 'access_token';
  static const String EMAIL_KEY = 'email';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_KEY, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN_KEY);
  }

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(EMAIL_KEY, email);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(EMAIL_KEY);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TOKEN_KEY);
    await prefs.remove(EMAIL_KEY);
  }
}
