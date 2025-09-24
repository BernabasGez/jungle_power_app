import 'package:flutter/material.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bills = [
      {"month": "July 2025", "amount": 120.50, "status": "Paid"},
      {"month": "June 2025", "amount": 98.75, "status": "Pending"},
      {"month": "May 2025", "amount": 105.00, "status": "Paid"},
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: bills.length,
        itemBuilder: (context, index) {
          final bill = bills[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.green),
              title: Text(bill["month"] as String),
              subtitle: Text("Status: ${bill["status"]}"),
              trailing: Text("\$${bill["amount"]}"),
            ),
          );
        },
      ),
    );
  }
}
