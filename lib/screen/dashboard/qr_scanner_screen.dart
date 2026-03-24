import 'package:flutter/material.dart';

class QRScannerScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? userAppointments;
  const QRScannerScreen({super.key, this.userAppointments});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  // ── ☀️ DYNAMIC THEMED (Matches Dashboard & Profile perfectly) ──
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  // ── PREMIUM SLATE BLUE DARK MODE ──
  Color get bg => isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F6F9);
  Color get card => isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get surface =>
      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  Color get text => isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
  Color get textMuted =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get border =>
      isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0);

  Color get primary => const Color(0xFF4A6CF7);
  Color get accent => const Color(0xFF00D4FF);
  Color get success => const Color(0xFF10B981);

  @override
  void initState() {
    super.initState();
    // Smooth scanning laser animation!
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appts = widget.userAppointments ?? [];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'QR Scanner',
          style: TextStyle(color: text, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── ANIMATED SCANNER PREVIEW ──
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: border),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.05),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Faint Background Box
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),

                    // Static Icon
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      color: primary.withOpacity(0.2),
                      size: 100,
                    ),

                    // Animated Laser Line
                    AnimatedBuilder(
                      animation: _anim,
                      builder: (_, __) => Positioned(
                        top:
                            50 + (_anim.value * 160), // Laser drops down bounds
                        child: Container(
                          width: 160,
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                accent,
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accent,
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Corner Decorations
                    ..._buildCorners(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── INFO CARD ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: primary),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Scan the QR code at the clinic front desk to confirm your arrival instantly.',
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ── APPOINTMENTS HEADER ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Appointments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: text,
                    letterSpacing: -0.5,
                  ),
                ),
                if (appts.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${appts.length} Total',
                      style: TextStyle(
                        color: textMuted,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // ── APPOINTMENT LIST / EMPTY STATE ──
            appts.isEmpty
                ? _emptyState()
                : Column(children: appts.map((a) => _apptCard(a)).toList()),
          ],
        ),
      ),
    );
  }

  // ── HELPER: SCANNER CORNERS ──
  List<Widget> _buildCorners() {
    final d = BorderSide(color: primary, width: 4);
    return [
      Positioned(
        top: 20,
        left: 20,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            border: Border(top: d, left: d),
          ),
        ),
      ),
      Positioned(
        top: 20,
        right: 20,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            border: Border(top: d, right: d),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        left: 20,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            border: Border(bottom: d, left: d),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            border: Border(bottom: d, right: d),
          ),
        ),
      ),
    ];
  }

  // ── HELPER: APPOINTMENT CARD ──
  Widget _apptCard(Map<dynamic, dynamic> a) {
    final status = a['status'] ?? 'upcoming';
    final isUp = status == 'upcoming';
    final col = isUp ? primary : success;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: col.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.calendar_today_rounded, color: col, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a['service'] ?? 'Appointment',
                  style: TextStyle(
                    color: text,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'with ${a['doctor'] ?? 'Doctor'}',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  a['time'] ?? '--:--',
                  style: TextStyle(
                    color: text,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: col.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isUp ? 'Upcoming' : 'Completed',
                  style: TextStyle(
                    color: col,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── HELPER: EMPTY STATE ──
  Widget _emptyState() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: border),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: surface, shape: BoxShape.circle),
          child: Icon(Icons.event_busy_rounded, color: textMuted, size: 36),
        ),
        const SizedBox(height: 20),
        Text(
          'No Appointments',
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Book a service first to see it here for QR check-in.',
          textAlign: TextAlign.center,
          style: TextStyle(color: textMuted, fontSize: 13, height: 1.4),
        ),
      ],
    ),
  );
}
