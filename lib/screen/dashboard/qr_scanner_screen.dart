import 'package:flutter/material.dart';

class QRScannerScreen extends StatelessWidget {
  final List<Map<String, dynamic>>?
  userAppointments; // Optional user appointments

  const QRScannerScreen({
    super.key,
    this.userAppointments, // Pass the current user's appointments
  });

  @override
  Widget build(BuildContext context) {
    final bool hasAppointments =
        userAppointments != null && userAppointments!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'QR Scanner',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A6FA5)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scanner Preview
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3E50).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF4A6FA5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_scanner,
                        color: Color(0xFF4A6FA5),
                        size: 60,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    child: Container(
                      width: 140,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color(0xFF4A6FA5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Corner decorations
                  ..._buildCornerDecorations(),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Instructions Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF4A6FA5)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Scan the QR code at the front desk to confirm your appointment',
                      style: TextStyle(color: Color(0xFF2C3E50), fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Appointments Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Appointments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                if (hasAppointments)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A6FA5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${userAppointments!.length} total',
                      style: const TextStyle(
                        color: Color(0xFF4A6FA5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Appointment List or Empty State
            hasAppointments
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userAppointments!.length,
                    itemBuilder: (context, index) =>
                        _buildAppointmentItem(userAppointments![index]),
                  )
                : _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerDecorations() {
    return [
      Positioned(
        top: 20,
        left: 20,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: const Color(0xFF4A6FA5), width: 3),
              left: BorderSide(color: const Color(0xFF4A6FA5), width: 3),
            ),
          ),
        ),
      ),
      Positioned(
        top: 20,
        right: 20,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: const Color(0xFF4A6FA5), width: 3),
              right: BorderSide(color: const Color(0xFF4A6FA5), width: 3),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        left: 20,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: const Color(0xFF4A6FA5), width: 3),
              left: BorderSide(color: const Color(0xFF4A6FA5), width: 3),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: const Color(0xFF4A6FA5), width: 3),
              right: BorderSide(color: const Color(0xFF4A6FA5), width: 3),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildAppointmentItem(Map<String, dynamic> appt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4A6FA5).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Color(0xFF4A6FA5),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appt['service'] ?? 'Appointment',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'with ${appt['doctor'] ?? 'Doctor'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A6FA5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  appt['time'] ?? '--:--',
                  style: const TextStyle(
                    color: Color(0xFF4A6FA5),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Upcoming',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => Center(
    child: Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF4A6FA5).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.qr_code_scanner,
            color: Color(0xFF4A6FA5),
            size: 50,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'No Appointments Yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Book a service to see your appointments here',
          style: TextStyle(color: Color(0xFF7F8C8D)),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
