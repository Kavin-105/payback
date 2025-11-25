import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../services/expense_service.dart';

class ExpenseList extends StatelessWidget {
  final ExpenseService service;
  final VoidCallback onUpdate;

  ExpenseList({required this.service, required this.onUpdate});

  Future<void> _verifyAndToggle(BuildContext context, int index) async {
    final auth = LocalAuthentication();

    try {
      // Check if biometric is available
      final canCheck = await auth.canCheckBiometrics;
      final isSupported = await auth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Biometric authentication not available")),
        );
        return;
      }

      // Perform authentication
      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Verify fingerprint to mark expense as returned',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        await service.toggleReturned(index);
        onUpdate();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Auth failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: service.expenses.isEmpty
          ? Center(child: Text("No expenses yet, add one!"))
          : ListView.builder(
              itemCount: service.expenses.length,
              itemBuilder: (context, index) {
                final exp = service.expenses[index];
                return ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.green),
                  title: Text(
                    exp.friendName,
                    style: TextStyle(
                      decoration: exp.isReturned
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    "${exp.description}\n₹ ${exp.amount.toStringAsFixed(2)} | ${exp.date.toLocal().toString().split(' ')[0]}",
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: Icon(Icons.check_circle,
                        color: exp.isReturned ? Colors.grey : Colors.red),
                    onPressed: () => _verifyAndToggle(context, index),
                  ),
                );
              },
            ),
    );
  }
}
