import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _pinController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isSettingPin = false;
  bool _isConfirmingPin = false;
  String _tempPin = '';

  @override
  void initState() {
    super.initState();
    _checkPinStatus();
  }

  void _checkPinStatus() async {
    final isPinSet = await _authService.isPinSet();
    setState(() {
      _isSettingPin = !isPinSet;
    });
  }

  void _handlePinSubmit() async {
    if (_isSettingPin) {
      if (!_isConfirmingPin) {
        setState(() {
          _tempPin = _pinController.text;
          _isConfirmingPin = true;
          _pinController.clear();
        });
      } else {
        if (_pinController.text == _tempPin) {
          await _authService.setPin(_pinController.text);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showError('PINs do not match. Please try again.');
          setState(() {
            _isConfirmingPin = false;
            _tempPin = '';
            _pinController.clear();
          });
        }
      }
    } else {
      final isValid = await _authService.verifyPin(_pinController.text);
      if (isValid) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showError('Invalid PIN. Please try again.');
        _pinController.clear();
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _forgotPin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset PIN'),
        content: const Text('This will reset the app and delete all your expenses. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _authService.resetPin();
              Navigator.pop(context);
              setState(() {
                _isSettingPin = true;
                _isConfirmingPin = false;
                _pinController.clear();
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PAYBACK'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isSettingPin 
                ? (_isConfirmingPin ? 'Confirm PIN' : 'Set PIN')
                : 'Enter PIN',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 10),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: '',
                hintText: '****',
              ),
              onChanged: (value) {
                if (value.length == 4) {
                  _handlePinSubmit();
                }
              },
            ),
            const SizedBox(height: 20),
            if (!_isSettingPin)
              TextButton(
                onPressed: _forgotPin,
                child: const Text('Forgot PIN?'),
              ),
          ],
        ),
      ),
    );
  }
}