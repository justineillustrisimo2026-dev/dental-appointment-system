import 'package:flutter/material.dart';
import 'package:dentalclinicsystem/screen/auth/get_started_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      // ── The app now starts with the Get Started Screen ──
      home: const GetStartedScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
