import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? userAppointments;
  final bool isDarkMode;
  const QRScannerScreen({
    super.key,
    this.userAppointments,
    this.isDarkMode = false,
  });

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late bool _isDark;
  final MobileScannerController controller = MobileScannerController();
  bool _hasScanned = false; // Prevents multiple scans at once

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkMode;
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  // ── THEME COLORS ──
  Color get bg => _isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
  Color get card => _isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get text => _isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
  Color get textMuted =>
      _isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get border =>
      _isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0);
  Color get gold => const Color(0xFFB59410);
  Color get primary => const Color(0xFF1E293B);

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() => _hasScanned = true);
        _processCheckIn(barcode.rawValue!);
        break;
      }
    }
  }

  void _processCheckIn(String code) {
    // Logic: Compare scanned code with appointment IDs
    final appointment = widget.userAppointments?.firstWhere(
      (a) => a['id'].toString() == code,
      orElse: () => {},
    );

    if (appointment != null && appointment.isNotEmpty) {
      _showResultSheet(true, appointment['service'] ?? 'Appointment');
    } else {
      _showResultSheet(false, 'Invalid Clinic QR Code');
    }
  }

  void _showResultSheet(bool success, String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              color: success ? Colors.green : Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              success ? 'Check-in Successful' : 'Check-in Failed',
              style: TextStyle(
                color: text,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(message, style: TextStyle(color: textMuted)),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() => _hasScanned = false);
              },
              child: const Text(
                'DISMISS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'CHECK-IN SCANNER',
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // ── CAMERA VIEW ──
            Container(
              height: 320,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: gold.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MobileScanner(controller: controller, onDetect: _onDetect),
                  // Viewfinder area
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  // Animated Laser
                  AnimatedBuilder(
                    animation: _anim,
                    builder: (_, __) => Positioned(
                      top: 60 + (_anim.value * 200),
                      child: Container(
                        width: 200,
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              gold,
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gold.withOpacity(0.8),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ..._buildCorners(),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _infoCard(),
            const SizedBox(height: 40),
            _scheduleHeader(),
            const SizedBox(height: 16),
            _buildApptList(),
          ],
        ),
      ),
    );
  }

  // --- Helper UI Methods (Corners, InfoCard, List) ---
  List<Widget> _buildCorners() {
    final d = BorderSide(color: gold, width: 4);
    return [
      Positioned(
        top: 50,
        left: 50,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border(top: d, left: d),
          ),
        ),
      ),
      Positioned(
        top: 50,
        right: 50,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border(top: d, right: d),
          ),
        ),
      ),
      Positioned(
        bottom: 50,
        left: 50,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border(bottom: d, left: d),
          ),
        ),
      ),
      Positioned(
        bottom: 50,
        right: 50,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border(bottom: d, right: d),
          ),
        ),
      ),
    ];
  }

  Widget _infoCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: gold.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: gold.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        Icon(Icons.qr_code_scanner_rounded, color: gold),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Position the clinic QR code within the frame to confirm arrival.',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );

  Widget _scheduleHeader() => Row(
    children: [
      Container(
        width: 4,
        height: 20,
        decoration: BoxDecoration(
          color: gold,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        'Your Schedule',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    ],
  );

  Widget _buildApptList() {
    final appts = widget.userAppointments ?? [];
    if (appts.isEmpty) return const Text("No appointments scheduled.");
    return Column(children: appts.map((a) => _apptCard(a)).toList());
  }

  Widget _apptCard(Map<String, dynamic> a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: gold.withOpacity(0.1),
          child: Icon(Icons.calendar_today, color: gold, size: 20),
        ),
        title: Text(
          a['service'] ?? 'Service',
          style: TextStyle(color: text, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(a['time'] ?? 'Time', style: TextStyle(color: textMuted)),
        trailing: Icon(Icons.chevron_right, color: textMuted),
      ),
    );
  }
}
