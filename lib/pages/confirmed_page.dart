import 'package:flutter/material.dart';

class ConfirmedPage extends StatelessWidget {
  final double total;

  const ConfirmedPage({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmed')),
      body: Center(
        child: Text(
          'Thank you! Your order total is ₵${total.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
