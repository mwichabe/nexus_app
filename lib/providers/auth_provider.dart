import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

enum AuthState { unauthenticated, authenticating, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final LocalAuthentication _localAuth = LocalAuthentication();

  AuthState _state = AuthState.unauthenticated;
  String _errorMessage = '';
  bool _biometricsAvailable = false;
  int _pinAttempts = 0;
  static const int _maxAttempts = 5;
  static const String _correctPin = '1234'; // Demo PIN

  AuthState get state => _state;
  String get errorMessage => _errorMessage;
  bool get biometricsAvailable => _biometricsAvailable;
  bool get isAuthenticated => _state == AuthState.authenticated;
  int get remainingAttempts => _maxAttempts - _pinAttempts;

  AuthProvider() {
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      _biometricsAvailable = await _localAuth.canCheckBiometrics;
      notifyListeners();
    } catch (_) {
      _biometricsAvailable = false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    _state = AuthState.authenticating;
    notifyListeners();

    try {
      final bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Nexus',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        _state = AuthState.authenticated;
        _pinAttempts = 0;
        notifyListeners();
        return true;
      } else {
        _state = AuthState.unauthenticated;
        notifyListeners();
        return false;
      }
    } on PlatformException catch (e) {
      _state = AuthState.error;
      _errorMessage = e.message ?? 'Biometric authentication failed';
      notifyListeners();
      return false;
    }
  }

  Future<bool> authenticateWithPin(String pin) async {
    _state = AuthState.authenticating;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    if (pin == _correctPin) {
      _state = AuthState.authenticated;
      _pinAttempts = 0;
      _errorMessage = '';
      notifyListeners();
      return true;
    } else {
      _pinAttempts++;
      if (_pinAttempts >= _maxAttempts) {
        _state = AuthState.error;
        _errorMessage = 'Too many attempts. Please try again later.';
      } else {
        _state = AuthState.unauthenticated;
        _errorMessage = 'Incorrect PIN. $remainingAttempts attempts remaining.';
      }
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _state = AuthState.unauthenticated;
    _errorMessage = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    if (_state == AuthState.error) {
      _state = AuthState.unauthenticated;
      _pinAttempts = 0;
    }
    notifyListeners();
  }
}
