import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../profile/profile_screen.dart';
import 'services_screen.dart';
import 'calendar_screen.dart';
import 'history_screen.dart';
import 'qr_scanner_screen.dart';
import 'about_clinic_screen.dart';

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

  bool isDark = false;

  // ── ✨ LUXURY GOLD THEME ──
  final Color goldPrimary = const Color(0xFFD4AF37);
  final Color goldDark = const Color(0xFFA67C00);
  final Color goldLight = const Color(0xFFF9E4B7);

  Color get bg => isDark ? const Color(0xFF0F172A) : Colors.white;
  Color get card => isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
  Color get surface =>
      isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
  Color get text => isDark ? Colors.white : const Color(0xFF1E293B);
  Color get textMuted =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get border =>
      isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0);

  LinearGradient get goldGrad => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldPrimary, goldDark],
  );

  // ── 🏥 FULL SERVICES LIST ──
  final List<Map<String, dynamic>> _services = [
    {
      'n': 'Braces & Adjustments',
      'i': Icons.health_and_safety_rounded,
      'p': '₱5K Down / ₱1K-2K Adj.',
      'dur': '1-2 Years',
      'desc':
          'A long-term orthodontic solution to align crowded teeth and correct your bite for a perfect smile.',
    },
    {
      'n': 'Consultation',
      'i': Icons.chat_rounded,
      'p': '₱500',
      'dur': '30 mins',
      'desc':
          'A comprehensive oral examination to discuss your dental goals and create a personalized treatment plan.',
    },
    {
      'n': 'Panoramic X-Ray',
      'i': Icons.radar_rounded,
      'p': '₱1,000',
      'dur': '15 mins',
      'desc':
          'A detailed 2D dental X-ray that captures the entire mouth in a single image, including teeth and jaws.',
    },
    {
      'n': 'Oral Prophylaxis',
      'i': Icons.cleaning_services_rounded,
      'p': '₱850–1,200',
      'dur': '45 mins',
      'desc':
          'Professional teeth cleaning to remove stubborn tartar and plaque, preventing cavities and gum disease.',
    },
    {
      'n': 'Tooth Extraction',
      'i': Icons.healing_rounded,
      'p': '₱850–1,200',
      'dur': '30-45 mins',
      'desc':
          'Safe and painless removal of damaged or decayed teeth to protect the health of your surrounding teeth.',
    },
    {
      'n': 'Wisdom Tooth Removal',
      'i': Icons.medical_services_rounded,
      'p': '₱8K–13K',
      'dur': '60 mins',
      'desc':
          'Specialized surgical extraction of impacted or problematic third molars to prevent crowding and pain.',
    },
    {
      'n': 'Dental Filling (Pasta)',
      'i': Icons.build_rounded,
      'p': '₱850–1,200',
      'dur': '30 mins',
      'desc':
          'Restores the function of your teeth by filling cavities with durable, tooth-colored composite materials.',
    },
    {
      'n': 'Dentures (Pustiso)',
      'i': Icons.face_rounded,
      'p': 'From ₱1K',
      'dur': 'Multiple sittings',
      'desc':
          'Custom-made removable replacements for missing teeth and surrounding tissues to restore your confidence.',
    },
    {
      'n': 'Dental Bridges',
      'i': Icons.settings_input_component_rounded,
      'p': '₱1,000',
      'dur': '2-3 Sessions',
      'desc':
          'A fixed prosthetic solution that "bridges" the gap created by one or more missing teeth.',
    },
    {
      'n': 'Dental Jacket / Crown',
      'i': Icons.workspace_premium_rounded,
      'p': '₱1,000',
      'dur': '2 Sessions',
      'desc':
          'A custom-fitted cap that covers a damaged tooth to restore its original shape, size, and strength.',
    },
    {
      'n': 'Teeth Whitening',
      'i': Icons.auto_awesome_rounded,
      'p': '₱3K/sess.',
      'dur': '60 mins',
      'desc':
          'Professional bleaching treatment designed to safely remove deep stains for a brighter, whiter smile.',
    },
    {
      'n': 'Root Canal (RCT)',
      'i': Icons.psychology_rounded,
      'p': '₱8,000',
      'dur': '60-90 mins',
      'desc':
          'An essential procedure to save a badly decayed or infected tooth by treating the nerve and pulp.',
    },
  ];

  List<Map<String, dynamic>> get _upcoming =>
      appointments.where((a) => a['status'] == 'upcoming').toList();

  void _addAppt(Map<String, dynamic> a) {
    setState(() => appointments.add(a));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Appointment booked!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: goldDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: isDark ? Brightness.dark : Brightness.light),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: bg,
        extendBodyBehindAppBar: true,
        appBar: _appBar(),
        endDrawer: _drawer(),

        // ── ➕ PLUS BUTTON (Lower Right, Home Tab Only) ──
        floatingActionButton: _idx == 0
            ? FloatingActionButton(
                onPressed: () => setState(() => _idx = 1),
                backgroundColor: goldDark,
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,

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
              onReschedule: (idx, newDate, newTime) {
                setState(() {});
              }, // Ensures Home updates when calendar cancels
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

  PreferredSizeWidget _appBar() => PreferredSize(
    preferredSize: const Size.fromHeight(72),
    child: SafeArea(
      child: Container(
        color: bg.withOpacity(0.95), // Solid background for scrolling
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: goldPrimary,
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
              Icons.qr_code_scanner,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QRScannerScreen(
                    userAppointments: appointments,
                    isDarkMode: isDark,
                  ),
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
      child: Icon(icon, color: goldDark, size: 20),
    ),
  );

  Widget _dashHome() => SingleChildScrollView(
    padding: const EdgeInsets.only(top: 100, bottom: 40),
    physics: const BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _hero(),
        const SizedBox(height: 24),
        _statsRow(),
        const SizedBox(height: 30),

        // ── 📅 HOME APPOINTMENTS LOGIC ──
        // This automatically shows "No Appointments Yet" if list is empty
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Upcoming',
            style: TextStyle(
              color: text,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        appointments.isEmpty
            ? _emptyState()
            : Column(children: _upcoming.map((a) => _apptCard(a)).toList()),

        const SizedBox(height: 30),
        _servicesSection(),
        const SizedBox(height: 32),
        _tipsSection(),
      ],
    ),
  );

  Widget _servicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Our Services',
            style: TextStyle(
              color: text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 300, // Full description height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _services.length,
            itemBuilder: (ctx, i) {
              final srv = _services[i];
              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          srv['i'] as IconData,
                          color: goldPrimary,
                          size: 28,
                        ),
                        Text(
                          srv['dur'] as String,
                          style: TextStyle(
                            color: goldDark,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      srv['n'] as String,
                      style: TextStyle(
                        color: text,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // ✨ DESCRIPTION FULLY SHOWN
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          srv['desc'] as String,
                          style: TextStyle(
                            color: textMuted,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      srv['p'] as String,
                      style: TextStyle(
                        color: goldDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _apptCard(Map<String, dynamic> a) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: border),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: goldLight,
          radius: 24,
          child: Icon(Icons.calendar_today, color: goldDark),
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
                a['doctor'] ?? 'Confirmed Appointment',
                style: TextStyle(color: textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _emptyState() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(40),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: border),
    ),
    child: Center(
      child: Column(
        children: [
          Icon(Icons.event_note, size: 60, color: goldLight),
          const SizedBox(height: 10),
          Text(
            'No Appointments Yet',
            style: TextStyle(color: text, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );

  Widget _drawer() => Drawer(
    backgroundColor: card,
    child: Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(gradient: goldGrad),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    widget.firstName[0],
                    style: TextStyle(
                      color: goldDark,
                      fontWeight: FontWeight.bold,
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
        ),
        // ── 🌓 DARK MODE INSIDE BURGER ──
        ListTile(
          leading: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: goldDark,
          ),
          title: Text(
            isDark ? 'Light Mode' : 'Dark Mode',
            style: TextStyle(color: text),
          ),
          trailing: Switch(
            value: isDark,
            activeColor: goldPrimary,
            onChanged: (v) => setState(() => isDark = v),
          ),
        ),
        const Divider(),
        _drawerItem(
          Icons.info,
          'About Clinic',
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AboutClinicScreen(isDarkMode: isDark),
            ),
          ),
        ),
        _drawerItem(
          Icons.history,
          'History',
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HistoryScreen(
                appointments: appointments,
                patientName: widget.patientName,
                firstName: widget.firstName,
                isDarkMode: isDark,
                lastName: widget.lastName,
              ),
            ),
          ),
        ),
        const Spacer(),
        _drawerItem(
          Icons.logout,
          'Logout',
          () => Navigator.pushReplacementNamed(context, '/'),
          color: Colors.red,
        ),
        const SizedBox(height: 20),
      ],
    ),
  );

  Widget _hero() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: goldGrad,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: goldDark.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
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
                  foregroundColor: goldDark,
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
        _stat(
          '${appointments.length - _upcoming.length}',
          'Done',
          Icons.check_circle,
        ),
        const SizedBox(width: 12),
        _stat('${_services.length}', 'Services', Icons.stars),
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
          Icon(icon, color: goldPrimary),
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

  Widget _tipsSection() {
    final tips = [
      {
        't': 'The 2-Minute Rule',
        'd':
            'Brush for at least 2 minutes twice a day to ensure you reach all surfaces and remove harmful plaque.',
      },
      {
        't': 'Hydrate for Health',
        'd':
            'Drinking water after meals helps wash away food debris and keeps your saliva levels healthy.',
      },
      {
        't': 'Gentle is Better',
        'd':
            'Use a soft-bristled brush and gentle circular motions. Brushing too hard can wear down enamel.',
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Dental Care Tips',
            style: TextStyle(
              color: text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: tips
              .map(
                (tip) => Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: goldPrimary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: goldLight.withOpacity(0.5)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.lightbulb, color: goldDark, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip['t']!,
                              style: TextStyle(
                                color: text,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tip['d']!,
                              style: TextStyle(
                                color: textMuted,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

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
        selectedItemColor: goldDark,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    ),
  );

  Widget _drawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) => ListTile(
    leading: Icon(icon, color: color ?? goldDark),
    title: Text(title, style: TextStyle(color: color ?? text)),
    onTap: onTap,
  );
}
