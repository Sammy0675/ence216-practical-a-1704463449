import 'package:flutter/material.dart';
import 'theme.dart';
import 'pages/order_page.dart';

void main() {
  runApp(const MusiciansCornerApp());
}

class MusiciansCornerApp extends StatelessWidget {
  const MusiciansCornerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musicians’ Corner',
      theme: appTheme,
      home: const OrderPage(),
    );
  }
}
