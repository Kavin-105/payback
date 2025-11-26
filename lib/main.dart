import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_expense_screen.dart';

void main() {
  runApp(const PaybackApp());
}

class PaybackApp extends StatelessWidget {
  const PaybackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PAYBACK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-expense': (context) => const AddExpenseScreen(),
      },
    );
  }
}