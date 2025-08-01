import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _roleKey = 'role';
  static const String _isSeeOnboardingKey = 'isSeeOnboarding';

  static SharedPreferences? _preferences;

  static String? _token;
  static String? _role;

  /// Initialize SharedPreferences (call during app startup)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences?.getString(_tokenKey);
    _role = _preferences?.getString(_roleKey);
  }

  static bool hasToken() {
    return _preferences?.containsKey(_tokenKey) ?? false;
  }

  static Future<void> saveToken(String token, String role) async {
    try {
      if (_preferences == null) {
        log("SharedPreferences not initialized, calling init()");
        await init();
      }
      await _preferences!.setString(_tokenKey, token);
      await _preferences!.setString(_roleKey, role);
      _token = token;
      _role = role;
      log("✅ Token and Role saved");
    } catch (e) {
      log('❌ Error saving token and role: $e');
    }
  }

  static Future<void> setOnboardingSeen(bool seen) async {
    try {
      if (_preferences == null) await init();
      await _preferences!.setBool(_isSeeOnboardingKey, seen);
      log('Onboarding flag saved: $seen');
    } catch (e) {
      log('Error saving onboarding flag: $e');
    }
  }

  static bool hasSeenOnboarding() {
    return _preferences?.getBool(_isSeeOnboardingKey) ?? false;
  }

  static Future<void> logoutUser() async {
    try {
      if (_preferences == null) await init();
      await _preferences!.remove(_tokenKey);
      await _preferences!.remove(_roleKey);
      _token = null;
      _role = null;
      log("+++++ Logout complete");
      await goToLogin();
    } catch (e) {
      log('Error during logout: $e');
    }
  }

  static Future<void> goToLogin() async {
    // Example navigation logic here
    // Get.offAll(() => OnBoardingScreen());
  }

  static String? get token => _token;
  static String? get role => _role;
}
