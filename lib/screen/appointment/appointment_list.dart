import 'package:flutter/material.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Appointments',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          'Appointments List Coming Soon',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
