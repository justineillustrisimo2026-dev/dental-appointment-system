// ignore_for_file: unnecessary_underscores, deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../profile/profile_screen.dart';
import 'services_screen.dart';
import 'calendar_screen.dart';
import 'history_screen.dart';
import 'about_clinic_screen.dart';
import 'dentist_profile_screen.dart';
import 'service_details_screen.dart';
import 'staff_profile_screen.dart';
import '../auth/login_screen.dart';

// ── MAIN DASHBOARD SCREEN: Hosts the home feed, services, calendar, and profile sections. ──
import 'app_theme.dart';
import 'mock_data.dart';

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

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _idx = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollCtrl = ScrollController();

  final GlobalKey<ServicesScreenState> _servicesKey =
      GlobalKey<ServicesScreenState>();

  List<Map<String, dynamic>> appointments = [];
  bool isDark = false;
  bool _showFab = false;

  // Controls the search bar state in the App Bar
  bool _isSearchActive = false;

  // ── APP-WIDE PROFILE IMAGE STATE (FOOLPROOF MEMORY BYTES) ──
  Uint8List? _profileImageBytes;

  late AnimationController _heroAnim;
  late AnimationController _fabAnim;
  int _notifCount = 0;

  late PageController _bannerPageCtrl;
  int _currentBanner = 0;
  Timer? _carouselTimer;

  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _searchQuery = "";

  // ── DYNAMIC THEME GETTERS ──
  Color get bg => AppTheme.bg(isDark);
  Color get cardBg => AppTheme.cardBg(isDark);
  Color get surface => AppTheme.surface(isDark);
  Color get innerSurface => AppTheme.innerSurface(isDark);
  Color get txt => AppTheme.txt(isDark);
  Color get txtMuted => AppTheme.txtMuted(isDark);
  Color get bdr => AppTheme.bdr(isDark);
  LinearGradient get goldGradient => AppTheme.goldGradient;
  List<BoxShadow> get profileShadow => AppTheme.profileShadow(isDark);

  // ── INITIALIZATION AND DISPOSAL OF CONTROLLERS, FOCUS NODES, AND TIMERS ──
  @override
  void initState() {
    super.initState();
    _heroAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scrollCtrl.addListener(() {
      final show = _scrollCtrl.offset > 300;
      if (show != _showFab) {
        setState(() => _showFab = show);
        show ? _fabAnim.forward() : _fabAnim.reverse();
      }
    });

    _searchFocus.addListener(() {
      setState(() {});
    });

    _bannerPageCtrl = PageController(initialPage: 0);
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_bannerPageCtrl.hasClients && !_searchFocus.hasFocus) {
        int next = _currentBanner + 1;
        if (next > 3) next = 0;
        _bannerPageCtrl.animateToPage(
          next,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _heroAnim.dispose();
    _fabAnim.dispose();
    _scrollCtrl.dispose();
    _bannerPageCtrl.dispose();
    _carouselTimer?.cancel();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ── APPOINTMENT HANDLER: Adds a new booking to the state. ──
  void _addAppt(Map<String, dynamic> a) {
    setState(() => appointments.add(a));
    HapticFeedback.mediumImpact();
  }

  // ── GREETING HELPERS: Dynamic text based on current time. ──
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getSubText() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Ready to shine today?';
    if (hour < 17) return 'Hope your day is going well.';
    return 'Time to wind down.';
  }

  // ── MAIN BUILD METHOD ──
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
        body: IndexedStack(
          index: _idx,
          children: [
            _home(),
            ServicesScreen(
              key: _servicesKey,
              appointments: appointments,
              onBookAppointment: (a) => _addAppt(a),
              patientName: widget.patientName,
              firstName: widget.firstName,
              lastName: widget.lastName,
              contactNo: widget.contactNo,
              isDarkMode: isDark,
            ),
            CalendarScreen(
              appointments: appointments,
              patientName: widget.patientName,
              firstName: widget.firstName,
              lastName: widget.lastName,
              onReschedule: (_, __, ___) => setState(() {}),
            ),
            ProfileScreen(
              patientName: widget.patientName,
              firstName: widget.firstName,
              lastName: widget.lastName,
              contactNo: widget.contactNo,
              profileImageBytes: _profileImageBytes, // Passes memory image down
              onImageChanged: (imageBytes) {
                // Instantly updates the dashboard when photo is picked
                setState(() {
                  _profileImageBytes = imageBytes;
                });
              },
              onThemeChanged: (val) {
                setState(() {
                  isDark = val;
                });
              },
            ),
          ],
        ),
        bottomNavigationBar: _bottomNav(),
      ),
    );
  }

  // ── APP BAR: Top navigation header with profile, search toggle, and notifications. ──
  PreferredSizeWidget _appBar() => PreferredSize(
    preferredSize: const Size.fromHeight(70),
    child: SafeArea(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey<bool>(_isSearchActive),
          height: 70,
          color: bg.withOpacity(0.97),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _isSearchActive
              ? _buildActiveSearchBar()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _avatar(
                      '${widget.firstName.isNotEmpty ? widget.firstName[0] : ''}${widget.lastName.isNotEmpty ? widget.lastName[0] : ''}',
                      24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Smile Dental Clinic',
                            style: GoogleFonts.dmSans(
                              color: txtMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.firstName,
                            style: GoogleFonts.dmSans(
                              color: txt,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _iconBtn(Icons.search_rounded, () {
                      setState(() {
                        _isSearchActive = true;
                      });
                      _searchFocus.requestFocus();
                    }),
                    const SizedBox(width: 8),
                    _notifButton(),
                    const SizedBox(width: 8),
                    _iconBtn(
                      Icons.menu_rounded,
                      () => _scaffoldKey.currentState?.openEndDrawer(),
                    ),
                  ],
                ),
        ),
      ),
    ),
  );

  // ── AVATAR: Dynamically renders the Memory Image or Initials ──
  Widget _avatar(String initials, double r) => Container(
    width: r * 2,
    height: r * 2,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: innerSurface,
      border: Border.all(color: AppTheme.goldMid.withOpacity(0.4), width: 2),
      boxShadow: [
        BoxShadow(
          color: AppTheme.goldDeep.withOpacity(0.22),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipOval(
      child: _profileImageBytes != null
          ? Image.memory(
              _profileImageBytes!,
              fit: BoxFit.cover,
              width: r * 2,
              height: r * 2,
            )
          : Container(
              decoration: BoxDecoration(gradient: goldGradient),
              child: Center(
                child: Text(
                  initials,
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: r * 0.65,
                  ),
                ),
              ),
            ),
    ),
  );

  // ── ICON BUTTON: Reusable square button for app bar actions. ──
  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: () {
      HapticFeedback.lightImpact();
      onTap();
    },
    child: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bdr),
      ),
      child: Icon(icon, color: AppTheme.goldPrimary, size: 20),
    ),
  );

  // ── NOTIFICATION BUTTON: Bell icon with dynamic unread count badge. ──
  Widget _notifButton() => Stack(
    children: [
      _iconBtn(Icons.notifications_outlined, _showNotifs),
      if (_notifCount > 0)
        Positioned(
          right: 6,
          top: 6,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.redAccent.shade200,
              shape: BoxShape.circle,
              border: Border.all(color: bg, width: 1.5),
            ),
            child: Center(
              child: Text(
                '$_notifCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
    ],
  );

  // ── HOME FEED ──
  Widget _home() => RefreshIndicator(
    onRefresh: () async {
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() {});
    },
    color: AppTheme.goldPrimary,
    child: SingleChildScrollView(
      controller: _scrollCtrl,
      padding: const EdgeInsets.only(top: 86, bottom: 110),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: _heroAnim, curve: Curves.easeOut),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_searchQuery.isNotEmpty)
              _searchResults()
            else ...[
              const SizedBox(height: 16),
              _heroCarousel(),
              const SizedBox(height: 22),
              _statsRow(),
              const SizedBox(height: 26),
              _upcomingSection(),
              const SizedBox(height: 28),
              _servicesSection(),
              const SizedBox(height: 28),
              _specialistsSection(),
              const SizedBox(height: 28),
              _staffSection(),
              const SizedBox(height: 28),
              _tipsSection(),
            ],
          ],
        ),
      ),
    ),
  );

  // ── SEARCH BAR ──
  Widget _buildActiveSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _searchFocus.hasFocus ? AppTheme.goldPrimary : bdr,
                width: _searchFocus.hasFocus ? 1.5 : 1,
              ),
              boxShadow: profileShadow,
            ),
            child: TextField(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              onChanged: (val) =>
                  setState(() => _searchQuery = val.toLowerCase()),
              style: GoogleFonts.dmSans(
                color: txt,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Search services, dentists, staff...',
                hintStyle: GoogleFonts.dmSans(color: txtMuted, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppTheme.goldPrimary,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _iconBtn(Icons.close_rounded, () {
          setState(() {
            _isSearchActive = false;
            _searchQuery = "";
            _searchCtrl.clear();
            _searchFocus.unfocus();
          });
        }),
      ],
    );
  }

  // ── SEARCH RESULTS SECTION ──
  Widget _searchResults() {
    final filteredServices = MockData.services.where((s) {
      return s['n'].toString().toLowerCase().contains(_searchQuery) ||
          s['desc'].toString().toLowerCase().contains(_searchQuery);
    }).toList();

    final filteredDentists = MockData.dentists.where((d) {
      return d['name']!.toLowerCase().contains(_searchQuery) ||
          d['spec']!.toLowerCase().contains(_searchQuery);
    }).toList();

    final filteredStaff = MockData.staff.where((s) {
      return s['name']!.toLowerCase().contains(_searchQuery) ||
          s['role']!.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredServices.isEmpty &&
        filteredDentists.isEmpty &&
        filteredStaff.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: txtMuted.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No results found for "$_searchQuery"',
                style: GoogleFonts.dmSans(color: txtMuted, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          if (filteredServices.isNotEmpty) ...[
            _secTitle('Services'),
            const SizedBox(height: 12),
            ...filteredServices.map(
              (s) => _searchResultItem(
                title: s['n'] as String,
                subtitle: s['dur'] as String,
                icon: Icons.medical_services_outlined,
                onTap: () async {
                  _searchFocus.unfocus();
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ServiceDetailsScreen(service: s, isDarkMode: isDark),
                    ),
                  );
                  if (result != null && result is String) {
                    _servicesKey.currentState?.setInitialService(result);
                    setState(() {
                      _searchQuery = "";
                      _searchCtrl.clear();
                      _isSearchActive = false;
                      _idx = 1;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (filteredDentists.isNotEmpty) ...[
            _secTitle('Specialists'),
            const SizedBox(height: 12),
            ...filteredDentists.map(
              (d) => _searchResultItem(
                title: d['name']!,
                subtitle: d['spec']!,
                icon: Icons.person_rounded,
                onTap: () {
                  _searchFocus.unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DentistProfileScreen(dentist: d, isDarkMode: isDark),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (filteredStaff.isNotEmpty) ...[
            _secTitle('Care Team'),
            const SizedBox(height: 12),
            ...filteredStaff.map(
              (s) => _searchResultItem(
                title: s['name']!,
                subtitle: s['role']!,
                icon: Icons.badge_rounded,
                onTap: () {
                  _searchFocus.unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          StaffProfileScreen(staff: s, isDarkMode: isDark),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _searchResultItem({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap != null
          ? () {
              HapticFeedback.lightImpact();
              onTap();
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: bdr),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.goldPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.goldPrimary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      color: txt,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      color: txtMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.goldPrimary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  // ── HERO CAROUSEL WITH AUTO-SLIDE AND INDICATORS ──
  Widget _heroCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _bannerPageCtrl,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (idx) => setState(() => _currentBanner = idx),
            itemCount: 4,
            itemBuilder: (context, index) => _buildBannerCard(index),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final active = _currentBanner == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active
                    ? AppTheme.goldPrimary
                    : (isDark ? Colors.white24 : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBannerCard(int index) {
    String title = "";
    String sub = "";
    String btnTxt = "";
    String targetServiceId = "";
    String imagePath = 'assets/Dr_krischelle.png';

    if (index == 0) {
      title = '${_getGreeting()},\n${widget.firstName}!';
      sub = _getSubText();
      btnTxt = 'Book Appointment';
      imagePath = 'assets/Dr_krischelle.png';
    } else if (index == 1) {
      title = 'Flash a\nBrighter Smile';
      sub = 'Get 20% off on all teeth bleaching services this month.';
      btnTxt = 'Claim Offer';
      targetServiceId = 'bleaching';
      imagePath = 'assets/smile1.png';
    } else if (index == 2) {
      title = 'Achieve\nPerfect Alignment';
      sub = 'Explore our modern braces options for a confident look.';
      btnTxt = 'Learn More';
      targetServiceId = 'braces';
      imagePath = 'assets/smile2.png';
    } else {
      title = 'Time for your\nCheckup?';
      sub = 'Prevent cavities before they start. Schedule a cleaning today.';
      btnTxt = 'Schedule Now';
      targetServiceId = 'cleaning';
      imagePath = 'assets/smile3.png';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: goldGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: profileShadow,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  sub,
                  style: GoogleFonts.dmSans(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (index == 0) {
                      setState(() => _idx = 1);
                    } else {
                      _servicesKey.currentState?.setInitialService(
                        targetServiceId,
                      );
                      setState(() => _idx = 1);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.goldDeep.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      btnTxt,
                      style: GoogleFonts.dmSans(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width * 0.45,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(30),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.white24,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white54),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── STATS ROW SHOWING PENDING, UPCOMING, AND COMPLETED APPOINTMENTS ──
  Widget _statsRow() {
    final pending = appointments.where((a) => a['status'] == 'pending').length;
    final upcoming = appointments
        .where((a) => a['status'] == 'upcoming')
        .length;
    final completed = appointments
        .where((a) => a['status'] == 'completed')
        .length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _statCard(
            '$pending',
            'Pending',
            Icons.schedule_rounded,
            isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706),
          ),
          const SizedBox(width: 8),
          _statCard(
            '$upcoming',
            'Upcoming',
            Icons.hourglass_top_rounded,
            AppTheme.goldPrimary,
          ),
          const SizedBox(width: 8),
          _statCard(
            '$completed',
            'Completed',
            Icons.check_circle_rounded,
            isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String val, String label, IconData icon, Color color) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: bdr),
            boxShadow: profileShadow,
          ),
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 12),
              ),
              const SizedBox(height: 6),
              Text(
                val,
                style: GoogleFonts.dmSans(
                  color: txt,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  color: txtMuted,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );

  // ── NEXT VISIT SECTION ──
  Widget _upcomingSection() {
    final upcomingAndPending = appointments
        .where((a) => a['status'] == 'upcoming' || a['status'] == 'pending')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _secTitle('Next Visit'),
              if (upcomingAndPending.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() => _idx = 2),
                  child: Text(
                    'See All',
                    style: GoogleFonts.dmSans(
                      color: AppTheme.goldPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (upcomingAndPending.isEmpty)
          _emptyAppt()
        else
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20, right: 4),
              itemCount: upcomingAndPending.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: _apptCard(
                      upcomingAndPending[index],
                      isCardInList: true,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _apptCard(Map<String, dynamic> a, {bool isCardInList = false}) {
    final DateTime? date = a['date'] as DateTime?;
    final String dateStr = date != null
        ? DateFormat('EEEE, MMMM d, yyyy').format(date)
        : 'TBD';
    String timeStr = a['time'] ?? 'TBD';
    String status = a['status'] ?? 'pending';
    bool isPending = status == 'pending';
    String duration = a['duration'] ?? '—';

    return Container(
      margin: isCardInList
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bdr),
        boxShadow: profileShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isPending
                      ? Colors.orange.shade100.withOpacity(isDark ? 0.1 : 0.4)
                      : Colors.green.shade100.withOpacity(isDark ? 0.1 : 0.4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isPending
                        ? Colors.orange.shade300
                        : Colors.green.shade300,
                  ),
                ),
                child: Text(
                  isPending ? 'Pending Approval' : 'Confirmed',
                  style: GoogleFonts.dmSans(
                    color: isPending
                        ? (isDark
                              ? Colors.orange.shade300
                              : Colors.orange.shade800)
                        : (isDark
                              ? Colors.green.shade300
                              : Colors.green.shade800),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: innerSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.goldPrimary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  a['price'] ?? '—',
                  style: GoogleFonts.dmSans(
                    color: AppTheme.goldPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: innerSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.goldPrimary.withOpacity(0.2),
                  ),
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: AppTheme.goldPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['service'] ?? 'Appointment',
                      style: GoogleFonts.dmSans(
                        color: txt,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a['doctor'] ?? 'Dentist',
                      style: GoogleFonts.dmSans(
                        color: txtMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: bdr),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.goldPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: AppTheme.goldPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date & Time",
                      style: GoogleFonts.dmSans(
                        color: txtMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$dateStr • $timeStr",
                      style: GoogleFonts.dmSans(
                        color: txt,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: innerSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: bdr),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: txtMuted),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: GoogleFonts.dmSans(
                        color: txtMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyAppt() => Center(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bdr),
        boxShadow: profileShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 48,
            color: txtMuted.withOpacity(0.4),
          ),
          const SizedBox(height: 14),
          Text(
            'No upcoming visits',
            style: GoogleFonts.dmSans(
              color: txtMuted,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Schedule your next appointment today',
            style: GoogleFonts.dmSans(
              color: txtMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );

  // ── SERVICES SECTION ──
  Widget _servicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _secTitle('Our Services'),
              GestureDetector(
                onTap: () => setState(() => _idx = 1),
                child: Text(
                  'See All',
                  style: GoogleFonts.dmSans(
                    color: AppTheme.goldPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Swipe and tap a service to learn more',
            style: GoogleFonts.dmSans(
              color: txtMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 380,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20, right: 4),
            itemCount: MockData.services.length,
            itemBuilder: (context, index) =>
                _serviceFullCard(MockData.services[index]),
          ),
        ),
      ],
    );
  }

  Widget _serviceFullCard(Map<String, dynamic> s) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ServiceDetailsScreen(service: s, isDarkMode: isDark),
          ),
        );
        if (result != null && result is String) {
          _servicesKey.currentState?.setInitialService(result);
          setState(() => _idx = 1);
        }
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: bdr),
          boxShadow: profileShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(23),
              ),
              child: Image.asset(
                s['img'] as String,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 140,
                  width: double.infinity,
                  color: innerSurface,
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    color: txtMuted.withOpacity(0.5),
                    size: 40,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['n'] as String,
                      style: GoogleFonts.dmSans(
                        color: txt,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.goldPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.goldPrimary.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            s['p'] as String,
                            style: GoogleFonts.dmSans(
                              color: AppTheme.goldPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: txtMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          s['dur'] as String,
                          style: GoogleFonts.dmSans(
                            color: txtMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(height: 1, color: bdr),
                    const SizedBox(height: 12),
                    Text(
                      s['desc'] as String,
                      style: GoogleFonts.dmSans(
                        color: txtMuted,
                        fontSize: 13,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Learn More',
                          style: GoogleFonts.dmSans(
                            color: AppTheme.goldPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppTheme.goldPrimary,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── MEET OUR SPECIALISTS SECTION ──
  Widget _specialistsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _secTitle('Meet Our Specialists'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20, right: 4),
            itemCount: MockData.dentists.length,
            itemBuilder: (context, index) =>
                _specialistCard(MockData.dentists[index]),
          ),
        ),
      ],
    );
  }

  Widget _specialistCard(Map<String, String> d) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DentistProfileScreen(dentist: d, isDarkMode: isDark),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: bdr),
          boxShadow: profileShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: goldGradient,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image.asset(
                  d['img']!,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person_rounded,
                    color: Colors.white54,
                    size: 40,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      d['name']!,
                      style: GoogleFonts.dmSans(
                        color: txt,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      d['spec']!,
                      style: GoogleFonts.dmSans(
                        color: AppTheme.goldPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'View Profile',
                          style: GoogleFonts.dmSans(
                            color: txtMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: AppTheme.goldPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── STAFF SECTION ──
  Widget _staffSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _secTitle('Meet Our Care Team'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20, right: 4),
            itemCount: MockData.staff.length,
            itemBuilder: (context, index) => _staffCard(MockData.staff[index]),
          ),
        ),
      ],
    );
  }

  Widget _staffCard(Map<String, String> s) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StaffProfileScreen(staff: s, isDarkMode: isDark),
          ),
        );
      },
      child: Container(
        width: 190,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: bdr),
          boxShadow: profileShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: goldGradient,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image.asset(
                  s['img']!,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person_rounded,
                    color: Colors.white54,
                    size: 40,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s['name']!,
                      style: GoogleFonts.dmSans(
                        color: txt,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        height: 1.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s['role']!,
                      style: GoogleFonts.dmSans(
                        color: AppTheme.goldPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── REDESIGNED TIPS SECTION ──
  Widget _tipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _secTitle('Dental Tips'),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 280, // Height increased to confidently hold full descriptions
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20, right: 4),
            itemCount: MockData.tips.length,
            itemBuilder: (context, index) {
              final tip = MockData.tips[index];
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: bdr),
                  boxShadow: profileShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.goldPrimary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            tip['i'] as IconData,
                            color: AppTheme.goldPrimary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            tip['t'] as String,
                            style: GoogleFonts.dmSans(
                              color: txt,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          tip['d'] as String,
                          style: GoogleFonts.dmSans(
                            color: txt.withOpacity(0.85),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.6,
                          ),
                        ),
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

  // ── NOTIFICATIONS PANEL ──
  void _showNotifs() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: bdr,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: txt,
                  ),
                ),
                if (_notifCount > 0)
                  TextButton(
                    onPressed: () {
                      setState(() => _notifCount = 0);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Clear All',
                      style: GoogleFonts.dmSans(
                        color: AppTheme.goldPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _notifCount == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_off_rounded,
                            size: 48,
                            color: txtMuted.withOpacity(0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No notifications yet',
                            style: GoogleFonts.dmSans(
                              color: txtMuted,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      _notifItem(
                        '🎉',
                        'Welcome to Smile Art!',
                        'Start your journey to a perfect smile.',
                        '2m ago',
                      ),
                      _notifItem(
                        '📅',
                        'Appointment Reminder',
                        'Your next checkup is in 3 days.',
                        '1h ago',
                      ),
                      _notifItem(
                        '💡',
                        'Dental Tip',
                        'Brush twice daily for 2 minutes.',
                        '5h ago',
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _notifItem(String emoji, String title, String desc, String time) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: bdr),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      color: txt,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    desc,
                    style: GoogleFonts.dmSans(
                      color: txtMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: GoogleFonts.dmSans(color: txtMuted, fontSize: 11),
            ),
          ],
        ),
      );

  // ── BOTTOM NAVIGATION BAR ──
  Widget _bottomNav() {
    final items = [
      [Icons.home_rounded, Icons.home_outlined, 'Home'],
      [Icons.medical_services_rounded, Icons.medical_services_outlined, 'Book'],
      [Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Calendar'],
      [Icons.person_rounded, Icons.person_outline_rounded, 'Profile'],
    ];
    return SafeArea(
      child: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: bdr),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(items.length, (i) {
            final sel = _idx == i;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _idx = i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: sel
                      ? AppTheme.goldPrimary.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      sel ? items[i][0] as IconData : items[i][1] as IconData,
                      color: sel ? AppTheme.goldPrimary : txtMuted,
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[i][2] as String,
                      style: GoogleFonts.dmSans(
                        color: sel ? AppTheme.goldPrimary : txtMuted,
                        fontSize: 11,
                        fontWeight: sel ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── LOGOUT CONFIRMATION DIALOG ──
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: bdr),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.redAccent.shade100.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent.shade200,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Logout?",
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: txt,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Are you sure you want to Log out?",
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: txtMuted,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: innerSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: bdr),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: txt,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.redAccent.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Log out",
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── DRAWER ──
  Widget _drawer() => Drawer(
    backgroundColor: cardBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(28)),
    ),
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
          decoration: BoxDecoration(gradient: goldGradient),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _avatar(
                '${widget.firstName.isNotEmpty ? widget.firstName[0] : ''}${widget.lastName.isNotEmpty ? widget.lastName[0] : ''}',
                28,
              ),
              const SizedBox(height: 14),
              Text(
                '${widget.firstName} ${widget.lastName}',
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.contactNo,
                style: GoogleFonts.dmSans(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _drawerItem(
          Icons.info_outline_rounded,
          'About Clinic',
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AboutClinicScreen(isDarkMode: isDark),
            ),
          ),
        ),
        _drawerItem(
          Icons.history_rounded,
          'Visit History',
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: GestureDetector(
            onTap: _showLogoutConfirmation,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.redAccent.shade100.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent.shade200,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Logout',
                    style: GoogleFonts.dmSans(
                      color: Colors.redAccent.shade200,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) =>
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: innerSurface,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: AppTheme.goldPrimary, size: 18),
        ),
        title: Text(
          title,
          style: GoogleFonts.dmSans(
            color: txt,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: txtMuted, size: 18),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      );

  Widget _secTitle(String t) => Row(
    mainAxisSize: MainAxisSize.min,
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
        t,
        style: GoogleFonts.dmSans(
          color: txt,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  );
}
