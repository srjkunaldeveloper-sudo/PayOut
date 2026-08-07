import 'package:shared_preferences/shared_preferences.dart';
import 'package:payout/features/auth/services/auth_logger.dart';

class SecureStorageService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async => _prefs ??= await SharedPreferences.getInstance();

  static Future<void> saveToken(String token) async {
    final prefs = await _instance;
    await prefs.setString('access_token', token);
    AuthLogger.log('Saved access token to secure storage');
  }

  static Future<String?> readToken() async {
    final prefs = await _instance;
    return prefs.getString('access_token');
  }

  static Future<void> saveUserId(String id) async {
    final prefs = await _instance;
    await prefs.setString('user_id', id);
  }

  static Future<String?> readUserId() async {
    final prefs = await _instance;
    return prefs.getString('user_id');
  }

  static Future<void> saveUserPhone(String phone) async {
    final prefs = await _instance;
    await prefs.setString('user_phone', phone);
  }

  static Future<String?> readUserPhone() async {
    final prefs = await _instance;
    return prefs.getString('user_phone');
  }

  static Future<void> saveLoginTimestamp(String timestamp) async {
    final prefs = await _instance;
    await prefs.setString('login_timestamp', timestamp);
  }

  static Future<String?> readLoginTimestamp() async {
    final prefs = await _instance;
    return prefs.getString('login_timestamp');
  }

  static Future<void> saveMPIN(String mpin) async {
    final prefs = await _instance;
    await prefs.setString('mpin', mpin);
    AuthLogger.log('Saved security MPIN to secure storage');
  }

  static Future<String?> readMPIN() async {
    final prefs = await _instance;
    return prefs.getString('mpin');
  }

  static Future<void> clear() async {
    final prefs = await _instance;
    await prefs.clear();
    AuthLogger.log('Cleared all secure storage keys');
  }
}
