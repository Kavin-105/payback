import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  final _storage = const FlutterSecureStorage();
  static const String _pinKey = 'user_pin';

  /// Set a new PIN
  Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  /// Check if PIN is already set
  Future<bool> isPinSet() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null;
  }

  /// Verify PIN
  Future<bool> verifyPin(String inputPin) async {
    final storedPin = await _storage.read(key: _pinKey);
    return storedPin != null && storedPin == inputPin;
  }

  /// Reset PIN
  Future<void> resetPin() async {
    await _storage.delete(key: _pinKey);
  }
}
