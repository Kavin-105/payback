import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class ExpenseService {
  final List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  static const String _storageKey = "expenses";

  Future<void> loadExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList(_storageKey) ?? [];
      _expenses.clear();
      _expenses.addAll(data.map((e) => Expense.fromJson(jsonDecode(e))));
    } catch (e) {
      // if something goes wrong, just start with empty list
      _expenses.clear();
    }
  }

  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    await _saveExpenses();
  }

  Future<void> toggleReturned(int index) async {
    _expenses[index].isReturned = !_expenses[index].isReturned;
    await _saveExpenses();
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _expenses.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_storageKey, data);
  }
}
