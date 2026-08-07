import 'package:payout/features/auth/models/auth_models.dart';
import 'package:payout/features/auth/services/secure_storage_service.dart';
import 'package:payout/features/auth/services/auth_logger.dart';

class SessionManager {
  static final SessionManager instance = SessionManager._internal();
  SessionManager._internal();

  String? _accessToken;
  String? _refreshToken;
  UserModel? _currentUser;
  bool _rememberLogin = true;

  String? get accessToken => _accessToken;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _accessToken != null;

  Future<void> initSession(String access, String refresh, UserModel user) async {
    _accessToken = access;
    _refreshToken = refresh;
    _currentUser = user;

    if (_rememberLogin) {
      await SecureStorageService.saveToken(access);
    }
    AuthLogger.log('Session initialised for: ${user.name}');
  }

  Future<void> autoLogin() async {
    final savedToken = await SecureStorageService.readToken();
    if (savedToken != null) {
      _accessToken = savedToken;
      _currentUser = const UserModel(
        id: 'USR-789',
        name: 'Rahul Sharma',
        phone: '+91 9876543210',
      );
      AuthLogger.log('Auto login successful for Rahul Sharma');
    }
  }

  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _currentUser = null;
    await SecureStorageService.clear();
    AuthLogger.logLogout();
  }
}
