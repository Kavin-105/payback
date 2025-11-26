import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _pinKey = 'app_pin';
  static const String _isPinSetKey = 'is_pin_set';

  Future<bool> isPinSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isPinSetKey) ?? false;
  }

  Future<bool> setPin(String pin) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pinKey, pin);
      await prefs.setBool(_isPinSetKey, true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyPin(String pin) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedPin = prefs.getString(_pinKey);
      return storedPin == pin;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePin(String oldPin, String newPin) async {
    if (await verifyPin(oldPin)) {
      return await setPin(newPin);
    }
    return false;
  }

  Future<void> resetPin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinKey);
    await prefs.remove(_isPinSetKey);
  }
}