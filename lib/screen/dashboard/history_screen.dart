import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;
  final String patientName, firstName, lastName;
  final bool isDarkMode;

  const HistoryScreen({
    super.key,
    required this.appointments,
    required this.patientName,
    required this.firstName,
    required this.lastName,
    this.isDarkMode = false,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      setState(() => isDark = widget.isDarkMode);
    }
  }

  // ── PALETTE FROM LOGIN & DASHBOARD ──
  static const Color _cardWhite = Color(0xFFFFFFFF);
  static const Color _inputCream = Color(0xFFFAF6EE);
  static const Color _goldDeep = Color(0xFFB88A44);
  static const Color _goldMid = Color(0xFFD4AF37);
  static const Color _goldShine = Color(0xFFF0D86C);
  static const Color _goldPrimary = Color(0xFFB59410);
  static const Color _textDark = Color(0xFF2C2410);
  static const Color _textMuted = Color(0xFF8A7A5A);

  // Dynamic Theme Getters
  Color get bg => isDark ? const Color(0xFF1A160F) : Colors.white;
  Color get cardBg => isDark ? const Color(0xFF262016) : _cardWhite;
  Color get innerSurface => isDark ? const Color(0xFF332B1E) : _inputCream;
  Color get ink => isDark ? _inputCream : _textDark;
  Color get inkMuted => isDark ? const Color(0xFFA6967A) : _textMuted;
  Color get bdr =>
      isDark ? const Color(0xFF403626) : _goldMid.withOpacity(0.28);

  Color get successGreen =>
      isDark ? const Color(0xFF10B981) : const Color(0xFF059669);

  LinearGradient get goldGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_goldDeep, _goldMid, _goldShine, _goldMid],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  List<Map<String, dynamic>> get _completedAppointments => widget.appointments
      .where((a) => a['status'] == 'completed')
      .toList()
      .reversed
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _goldPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Appointment History',
          style: GoogleFonts.dmSans(
            color: ink,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        // Dark mode button removed. Theme state is controlled via Dashboard/Profile.
      ),
      body: _completedAppointments.isEmpty
          ? _emptyState()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 18,
                        decoration: BoxDecoration(
                          gradient: goldGradient,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Past Appointments',
                        style: GoogleFonts.dmSans(
                          color: ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._completedAppointments.map((a) => _historyCard(a)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _emptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: innerSurface,
            shape: BoxShape.circle,
            border: Border.all(color: bdr),
          ),
          child: Icon(
            Icons.history_rounded,
            size: 36,
            color: inkMuted.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'No History Yet',
          style: GoogleFonts.dmSans(
            color: ink,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your completed appointments\nwill securely appear here.',
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            color: inkMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    ),
  );

  Widget _historyCard(Map<String, dynamic> a) {
    final DateTime? date = a['date'] as DateTime?;
    final String dateStr = date != null
        ? DateFormat('MMM d, yyyy').format(date)
        : 'N/A';

    // Formatting time to AM/PM
    String timeStr = a['time'] ?? 'N/A';
    if (timeStr.contains(':')) {
      try {
        final parts = timeStr.split(':');
        int h = int.parse(parts[0]);
        final m = parts[1];
        final p = h >= 12 ? 'PM' : 'AM';
        if (h > 12) h -= 12;
        if (h == 0) h = 12;
        timeStr = '${h.toString().padLeft(2, '0')}:$m $p';
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bdr),
        boxShadow: [
          BoxShadow(
            color: _goldDeep.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: innerSurface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    color: _goldPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a['service'] ?? 'Service',
                        style: GoogleFonts.dmSans(
                          color: ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        a['doctor'] ?? 'Doctor',
                        style: GoogleFonts.dmSans(
                          color: _goldPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: successGreen.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: successGreen,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Completed',
                        style: GoogleFonts.dmSans(
                          color: successGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: innerSurface,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(23),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: inkMuted),
                const SizedBox(width: 6),
                Text(
                  dateStr,
                  style: GoogleFonts.dmSans(
                    color: ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time_rounded, size: 14, color: inkMuted),
                const SizedBox(width: 6),
                Text(
                  timeStr,
                  style: GoogleFonts.dmSans(
                    color: ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (a['price'] != null) ...[
                  const Spacer(),
                  Text(
                    a['price'] as String,
                    style: GoogleFonts.dmSans(
                      color: _goldPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
