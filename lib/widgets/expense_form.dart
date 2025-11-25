import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpenseForm extends StatefulWidget {
  final ExpenseService service;
  final VoidCallback onExpenseAdded;

  ExpenseForm({required this.service, required this.onExpenseAdded});

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _friendController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    final name = _friendController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    final desc = _descriptionController.text.trim();

    if (name.isNotEmpty && amount != null && desc.isNotEmpty) {
      widget.service.addExpense(Expense(
        friendName: name,
        amount: amount,
        description: desc,
        date: _selectedDate,
      ));
      widget.onExpenseAdded();
      _friendController.clear();
      _amountController.clear();
      _descriptionController.clear();
      setState(() => _selectedDate = DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _friendController,
              decoration: InputDecoration(labelText: "Friend's Name"),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            Row(
              children: [
                Text("Date: ${_selectedDate.toLocal().toString().split(' ')[0]}"),
                Spacer(),
                TextButton(onPressed: _pickDate, child: Text("Pick Date")),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _submit, child: Text("Add Expense")),
          ],
        ),
      ),
    );
  }
}
