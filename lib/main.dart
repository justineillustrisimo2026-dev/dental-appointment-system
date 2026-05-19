import 'dart:io'; // 👈 Required for HttpOverrides
import 'package:flutter/material.dart';
import 'package:dentalclinicsystem/screen/auth/get_started_screen.dart';

// ── HTTPS Certificate Override for Local Development ──
class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  // ── Inject the override before the app initializes ──
  HttpOverrides.global = DevHttpOverrides();

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
      home: const GetStartedScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
