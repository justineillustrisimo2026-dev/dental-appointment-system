import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../profile/profile_screen.dart';
import 'services_screen.dart';
import 'calendar_screen.dart';
import 'qr_scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String patientName, firstName, lastName, contactNo;
  const DashboardScreen({
    super.key,
    required this.patientName,
    required this.firstName,
    required this.lastName,
    required this.contactNo,
  });
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _idx = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> appointments = [];

  // ☀️ Starts App in Light Mode default!
  bool isDark = false;

  // ── UPDATED THEME: SLEEK BLACK SHADES FOR DARK MODE ──
  Color get bg => isDark
      ? const Color(0xFF0F172A)
      : const Color(0xFFF4F6F9); // Deep Slate Blue Background
  Color get card =>
      isDark ? const Color(0xFF1E293B) : Colors.white; // Elevated Blue Card
  Color get surface => isDark
      ? const Color(0xFF334155)
      : const Color(0xFFE2E8F0); // Active Blue Surface
  Color get text => isDark
      ? const Color(0xFFF8FAFC)
      : const Color(0xFF1E293B); // Icy White Text
  Color get textMuted => isDark
      ? const Color(0xFF94A3B8)
      : const Color(0xFF64748B); // Cool Blue-Grey Text
  Color get border => isDark
      ? const Color(0xFF475569)
      : const Color(0xFFE2E8F0); // Soft Blue Border

  final primary = const Color(0xFF4A6CF7);
  final accent = const Color(0xFF00D4FF);
  LinearGradient get grad => LinearGradient(colors: [primary, accent]);

  List<Map<String, dynamic>> get _upcoming =>
      appointments.where((a) => a['status'] == 'upcoming').toList();
  List<Map<String, dynamic>> get _completed =>
      appointments.where((a) => a['status'] == 'completed').toList();

  void _addAppt(Map<String, dynamic> a) {
    setState(() => appointments.add(a));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Appointment booked!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return Theme(
      data: ThemeData(brightness: isDark ? Brightness.dark : Brightness.light),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: bg,
        extendBodyBehindAppBar: true,
        appBar: _appBar(),
        endDrawer: _drawer(),
        body: IndexedStack(
          index: _idx,
          children: [
            _dashHome(),
            ServicesScreen(
              appointments: appointments,
              onBookAppointment: (a) {
                _addAppt(a);
                setState(() => _idx = 2);
              },
              patientName: widget.patientName,
              firstName: widget.firstName,
              lastName: widget.lastName,
            ),
            CalendarScreen(
              appointments: appointments,
              patientName: widget.patientName,
              firstName: widget.firstName,
              lastName: widget.lastName,
            ),
            ProfileScreen(
              patientName: widget.patientName,
              firstName: widget.firstName,
              lastName: widget.lastName,
              contactNo: widget.contactNo,
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ── APP BAR ──────────────────────────────────────
  PreferredSizeWidget _appBar() => PreferredSize(
    preferredSize: const Size.fromHeight(72),
    child: SafeArea(
      child: Container(
        color: bg.withOpacity(0.95),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: primary,
              child: Text(
                '${widget.firstName[0]}${widget.lastName[0]}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello,',
                    style: TextStyle(color: textMuted, fontSize: 12),
                  ),
                  Text(
                    '${widget.firstName} ${widget.lastName}',
                    style: TextStyle(
                      color: text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _iconBtn(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              () => setState(() => isDark = !isDark),
            ),
            const SizedBox(width: 8),
            _iconBtn(
              Icons.qr_code_scanner,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      QRScannerScreen(userAppointments: appointments),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _iconBtn(
              Icons.menu,
              () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Icon(icon, color: text, size: 20),
    ),
  );

  // ── HOME DASHBOARD ───────────────────────────────
  Widget _dashHome() => SingleChildScrollView(
    padding: const EdgeInsets.only(top: 100, bottom: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _hero(),
        const SizedBox(height: 24),
        _statsRow(),
        const SizedBox(height: 30),
        appointments.isEmpty
            ? Container(
                height: 250, // Strict height area to center the empty state
                alignment: Alignment.center,
                child: _emptyState(),
              )
            : Column(
                children: [
                  if (_upcoming.isNotEmpty)
                    _section(
                      'Upcoming',
                      _upcoming,
                      () => setState(() => _idx = 2),
                    ),
                  if (_completed.isNotEmpty)
                    _section(
                      'History',
                      _completed,
                      () => setState(() => _idx = 2),
                    ),
                ],
              ),
      ],
    ),
  );

  Widget _hero() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: grad,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [BoxShadow(color: primary.withOpacity(0.4), blurRadius: 20)],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Smile Art Dental',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.firstName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => setState(() => _idx = 1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primary,
                  elevation: 0,
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.maps_home_work_rounded, color: Colors.white, size: 54),
      ],
    ),
  );

  Widget _statsRow() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        _stat('${_upcoming.length}', 'Upcoming', Icons.upcoming),
        const SizedBox(width: 12),
        _stat('${_completed.length}', 'Done', Icons.check_circle),
        const SizedBox(width: 12),
        _stat('${appointments.length}', 'Total', Icons.bar_chart),
      ],
    ),
  );

  Widget _stat(String val, String label, IconData icon) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Icon(icon, color: primary),
          const SizedBox(height: 8),
          Text(
            val,
            style: TextStyle(
              color: text,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, style: TextStyle(color: textMuted, fontSize: 11)),
        ],
      ),
    ),
  );

  Widget _section(
    String title,
    List<Map<String, dynamic>> list,
    VoidCallback onViewAll,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              child: Text(
                'View All',
                style: TextStyle(color: primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ...list.take(2).map((a) => _apptCard(a)),
        const SizedBox(height: 10),
      ],
    ),
  );

  Widget _apptCard(Map<String, dynamic> a) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: border),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: primary.withOpacity(0.15),
          radius: 24,
          child: Text(
            a['time']?.split(':')[0] ?? '',
            style: TextStyle(color: primary, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                a['service'] ?? '',
                style: TextStyle(
                  color: text,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                a['doctor'] ?? '',
                style: TextStyle(color: textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _emptyState() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.event_busy, size: 60, color: textMuted.withOpacity(0.4)),
      const SizedBox(height: 16),
      Text(
        'No Appointments Yet',
        style: TextStyle(
          color: text,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Book your first dental service\nand keep your smile healthy!',
        textAlign: TextAlign.center,
        style: TextStyle(color: textMuted, fontSize: 13),
      ),
    ],
  );

  // ── FOOTER NAVIGATION ────────────────────────────
  Widget _buildBottomNav() => Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: border),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        backgroundColor: card,
        selectedItemColor: primary,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            activeIcon: Icon(Icons.medical_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    ),
  );

  // ── DRAWER ───────────────────────────────────────
  Widget _drawer() => Drawer(
    backgroundColor: card,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(gradient: grad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.firstName[0],
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.firstName} ${widget.lastName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.info, color: text),
          title: Text('About Clinic', style: TextStyle(color: text)),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: Icon(Icons.history, color: text),
          title: Text('History', style: TextStyle(color: text)),
          onTap: () {
            Navigator.pop(context);
            setState(() => _idx = 2);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ],
    ),
  );
}
