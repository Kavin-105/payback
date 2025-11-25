import 'package:flutter/material.dart';
import '../services/expense_service.dart';
import '../widgets/expense_form.dart';
import '../widgets/expense_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExpenseService _service = ExpenseService();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _service.loadExpenses();
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Expenses")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ExpenseForm(service: _service, onExpenseAdded: _refresh),
                ExpenseList(service: _service, onUpdate: _refresh),
              ],
            ),
    );
  }
}
