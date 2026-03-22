import 'package:flutter/material.dart';

class BookAppointment extends StatelessWidget {
  const BookAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Book Appointment',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          'Booking Screen Coming Soon',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
