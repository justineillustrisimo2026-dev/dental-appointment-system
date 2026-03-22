import 'package:flutter/material.dart';
import 'screen/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smile Art Dental',
      theme: ThemeData(
        primaryColor: const Color(0xFF0A1A2F),
        scaffoldBackgroundColor: const Color(0xFF0A1A2F),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
