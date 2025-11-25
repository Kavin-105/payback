import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyExpenseApp());
}

class MyExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Expense App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
