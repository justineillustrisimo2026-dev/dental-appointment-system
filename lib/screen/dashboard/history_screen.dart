import 'package:flutter/material.dart';

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

  // ── THEME COLORS ──
  Color get bg => isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F6F9);
  Color get card => isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get surface =>
      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  Color get text => isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
  Color get textMuted =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get border =>
      isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0);

  final primary = const Color(0xFF4A6CF7);
  final accent = const Color(0xFF00D4FF);
  final success = const Color(0xFF10B981);

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
          icon: Icon(Icons.arrow_back_rounded, color: text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Appointment History',
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: text,
            ),
            onPressed: () => setState(() => isDark = !isDark),
          ),
        ],
      ),
      body: _completedAppointments.isEmpty
          ? _emptyState()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Past Appointments',
                    style: TextStyle(
                      color: text,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._completedAppointments.map((a) => _historyCard(a)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _emptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.history, size: 80, color: textMuted.withOpacity(0.3)),
        const SizedBox(height: 20),
        Text(
          'No History Yet',
          style: TextStyle(
            color: text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your completed appointments\nwill appear here',
          textAlign: TextAlign.center,
          style: TextStyle(color: textMuted, fontSize: 14, height: 1.4),
        ),
      ],
    ),
  );

  Widget _historyCard(Map<String, dynamic> a) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: border),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a['service'] ?? 'Service',
                    style: TextStyle(
                      color: text,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    a['doctor'] ?? 'Doctor',
                    style: TextStyle(color: textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Completed',
                style: TextStyle(
                  color: success,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 14, color: primary),
            const SizedBox(width: 6),
            Text(
              a['date'] != null
                  ? '${a['date'].day}/${a['date'].month}/${a['date'].year}'
                  : 'N/A',
              style: TextStyle(color: textMuted, fontSize: 12),
            ),
            const SizedBox(width: 16),
            Icon(Icons.access_time, size: 14, color: primary),
            const SizedBox(width: 6),
            Text(
              a['time'] ?? 'N/A',
              style: TextStyle(color: textMuted, fontSize: 12),
            ),
          ],
        ),
        if (a['duration'] != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.hourglass_top, size: 14, color: primary),
              const SizedBox(width: 6),
              Text(
                'Duration: ${a['duration']}',
                style: TextStyle(color: textMuted, fontSize: 12),
              ),
            ],
          ),
        ],
        if (a['description'] != null) ...[
          const SizedBox(height: 10),
          Text(
            a['description'],
            style: TextStyle(color: textMuted, fontSize: 13, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    ),
  );
}
