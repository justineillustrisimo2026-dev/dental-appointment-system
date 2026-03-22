import 'package:flutter/material.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('QR Scanner', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text(
          'QR Scanner Coming Soon',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
