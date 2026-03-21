import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'package:pocket_pact/screens/dashboard_screen.dart';
import 'package:pocket_pact/screens/create_pact_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PocketPact',
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(), // Changed from CreatePactScreen to test launch.
    );
  }
}
