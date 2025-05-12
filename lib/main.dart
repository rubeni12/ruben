import 'package:flutter/material.dart';
import 'package:ruben/welcome.dart';
import 'admin_panel/dashboard.dart';
import 'login.dart'; // Ensure you have a LoginPage widget
import 'sign_up.dart'; // Ensure you have a SignupPage widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: MyHomePage(),
      home: AdminDashboard(),
    );
  }
}

