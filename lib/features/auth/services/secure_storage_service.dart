import 'package:payout/features/auth/services/auth_logger.dart';

class SecureStorageService {
  static final Map<String, String> _mockStorage = {};

  static Future<void> saveToken(String token) async {
    _mockStorage['access_token'] = token;
    AuthLogger.log('Saved access token to secure storage');
  }

  static Future<String?> readToken() async {
    return _mockStorage['access_token'];
  }

  static Future<void> saveMPIN(String mpin) async {
    _mockStorage['mpin'] = mpin;
    AuthLogger.log('Saved security MPIN to secure storage');
  }

  static Future<String?> readMPIN() async {
    return _mockStorage['mpin'];
  }

  static Future<void> clear() async {
    _mockStorage.clear();
    AuthLogger.log('Cleared all secure storage keys');
  }
}
