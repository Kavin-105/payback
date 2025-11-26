import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class ExpenseService {
  static const String _expensesKey = 'expenses';

  Future<List<Expense>> getExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expensesString = prefs.getStringList(_expensesKey) ?? [];
      
      List<Expense> expenses = [];
      for (var jsonString in expensesString) {
        try {
          final map = json.decode(jsonString) as Map<String, dynamic>;
          expenses.add(Expense.fromMap(map));
        } catch (e) {
          print('Error parsing expense: $e');
        }
      }
      
      // Sort expenses by date (newest first)
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    } catch (e) {
      print('Error getting expenses: $e');
      return [];
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expenses = await getExpenses();
      
      expenses.add(expense);
      
      final expensesString = expenses.map((exp) {
        return json.encode(exp.toMap());
      }).toList();
      
      await prefs.setStringList(_expensesKey, expensesString);
      print('Expense saved successfully. Total expenses: ${expenses.length}');
    } catch (e) {
      print('Error saving expense: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expenses = await getExpenses();
      
      expenses.removeWhere((expense) => expense.id == id);
      
      final expensesString = expenses.map((exp) {
        return json.encode(exp.toMap());
      }).toList();
      
      await prefs.setStringList(_expensesKey, expensesString);
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }

  Future<void> clearAllExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_expensesKey);
    } catch (e) {
      print('Error clearing expenses: $e');
    }
  }
}