import 'package:flutter/material.dart';
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

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animController;
  List<Map<String, dynamic>> appointments = [];

  String get _greeting {
    var h = DateTime.now().hour;
    return h < 12
        ? 'Good Morning'
        : h < 17
        ? 'Good Afternoon'
        : 'Good Evening';
  }

  List<Map<String, dynamic>> get _upcoming =>
      appointments.where((a) => a['status'] == 'upcoming').toList();
  List<Map<String, dynamic>> get _completed =>
      appointments.where((a) => a['status'] == 'completed').toList();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..forward();
  }

  void addAppointment(Map<String, dynamic> a) => setState(() {
    appointments.add(a);
    _showSnack('Appointment booked!', Icons.check_circle);
  });

  void _showSnack(String m, IconData i) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(i, color: Colors.white),
              SizedBox(width: 8),
              Text(m),
            ],
          ),
          backgroundColor: Color(0xFF4A6FA5),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: SizedBox(),
      title: Row(
        children: [
          _buildAvatar(),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${widget.firstName} ${widget.lastName}',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        _buildIconButton(
          Icons.qr_code_scanner,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QRScannerScreen(userAppointments: appointments),
            ),
          ),
        ),
        _buildIconButton(
          Icons.menu,
          () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
      ],
    ),
    endDrawer: _buildDrawer(),
    body: FadeTransition(
      opacity: _animController,
      child: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboardHome(),
          ServicesScreen(
            appointments: appointments,
            onBookAppointment: (a) {
              addAppointment(a);
              setState(() => _selectedIndex = 2);
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
    ),
    bottomNavigationBar: _buildBottomNavBar(),
  );

  Widget _buildIconButton(IconData i, VoidCallback o) => Container(
    margin: EdgeInsets.only(right: 8),
    decoration: BoxDecoration(
      color: const Color(0xFF4A6FA5),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: IconButton(
      icon: Icon(i, color: Colors.white, size: 22),
      onPressed: o,
      splashRadius: 20,
    ),
  );

  Widget _buildAvatar() => Container(
    width: 45,
    height: 45,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xFF4A6FA5), Color(0xFF6B8EC9)]),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF4A6FA5).withOpacity(0.3),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Center(
      child: Text(
        '${widget.firstName[0]}${widget.lastName[0]}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _buildDashboardHome() => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      children: [
        _buildWelcomeCard(),
        _buildStatsSection(),
        _buildUpcomingSection(),
        _buildHistoryPreview(),
        SizedBox(height: 20),
      ],
    ),
  );

  Widget _buildWelcomeCard() => Container(
    margin: EdgeInsets.all(20),
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF4A6FA5), Color(0xFF6B8EC9), Color(0xFF8AAEE0)],
      ),
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF4A6FA5).withOpacity(0.3),
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  '${widget.firstName} ${widget.lastName}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(Icons.emoji_emotions, color: Colors.white, size: 30),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your smile is our priority. Ready for your next visit?',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildStatsSection() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        _buildStatCard(
          'Upcoming',
          '${_upcoming.length}',
          Icons.event_available,
          Color(0xFF4A6FA5),
        ),
        SizedBox(width: 16),
        _buildStatCard(
          'Completed',
          '${_completed.length}',
          Icons.check_circle,
          Color(0xFF10B981),
        ),
        SizedBox(width: 16),
        _buildStatCard(
          'Total',
          '${appointments.length}',
          Icons.auto_awesome,
          Color(0xFFF59E0B),
        ),
      ],
    ),
  );

  Widget _buildStatCard(String l, String v, IconData i, Color c) => Expanded(
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: c.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(i, color: c, size: 22),
          ),
          SizedBox(height: 8),
          Text(
            v,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          Text(l, style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        ],
      ),
    ),
  );

  Widget _buildUpcomingSection() {
    if (_upcoming.isEmpty) return _buildEmptyState();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Appointments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 2),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6FA5).withOpacity(0.1),
                  foregroundColor: Color(0xFF4A6FA5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 12),
          ..._upcoming.take(2).map((a) => _buildAppointmentCard(a)),
          if (_upcoming.length > 2)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A6FA5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '+ ${_upcoming.length - 2} more',
                    style: TextStyle(
                      color: Color(0xFF4A6FA5),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> a) => Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: const Color(0xFF4A6FA5).withOpacity(0.2),
        width: 1,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A6FA5), Color(0xFF6B8EC9)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              a['time'].split(':')[0],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                a['service'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                a['doctor'],
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: Color(0xFF94A3B8),
                  ),
                  SizedBox(width: 4),
                  Text(
                    _formatDate(a['date']),
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
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
  );

  Widget _buildHistoryPreview() {
    if (_completed.isEmpty) return SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: _showHistory,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6FA5).withOpacity(0.1),
                  foregroundColor: Color(0xFF4A6FA5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 12),
          ..._completed.take(2).map((i) => _buildHistoryCard(i)),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> i) => Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      border: Border.all(color: Colors.green.withOpacity(0.2), width: 1),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.check_circle, color: Colors.green, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i['service'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                i['doctor'],
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ),
        ),
        Text(
          _formatDate(i['date']),
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
        ),
      ],
    ),
  );

  Widget _buildEmptyState() => Padding(
    padding: EdgeInsets.all(20),
    child: Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF4A6FA5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.event_busy, size: 50, color: Color(0xFF4A6FA5)),
          ),
          SizedBox(height: 16),
          Text(
            'No Appointments Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Book your first dental service now!',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => setState(() => _selectedIndex = 1),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A6FA5),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Text('Book Now'),
          ),
        ],
      ),
    ),
  );

  Widget _buildDrawer() => Drawer(
    child: Column(
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A6FA5), Color(0xFF6B8EC9), Color(0xFF8AAEE0)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          '${widget.firstName[0]}${widget.lastName[0]}',
                          style: TextStyle(
                            color: Color(0xFF4A6FA5),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${widget.firstName} ${widget.lastName}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${widget.patientName}',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(top: 20),
            children: [
              _drawerItem(
                Icons.info_outline,
                'About Clinic',
                null,
                isAbout: true,
              ),
              _drawerItem(
                Icons.history_outlined,
                'History',
                null,
                isHistory: true,
              ),
              _drawerItem(
                Icons.qr_code_scanner,
                'QR Scanner',
                null,
                isScanner: true,
              ),
              Divider(thickness: 1, height: 40, indent: 20, endIndent: 20),
              _drawerItem(
                Icons.logout_outlined,
                'Logout',
                null,
                isLogout: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _drawerItem(
    IconData i,
    String l,
    int? idx, {
    bool isHistory = false,
    bool isScanner = false,
    bool isLogout = false,
    bool isAbout = false,
  }) => ListTile(
    leading: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isLogout
            ? Colors.red.withOpacity(0.1)
            : Color(0xFF4A6FA5).withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        i,
        color: isLogout ? Colors.red : Color(0xFF4A6FA5),
        size: 22,
      ),
    ),
    title: Text(
      l,
      style: TextStyle(
        color: isLogout ? Colors.red : Color(0xFF1E293B),
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),
    trailing: isLogout
        ? null
        : Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF94A3B8)),
    onTap: () {
      Navigator.pop(context);
      if (isLogout) {
        _showLogoutDialog();
      } else if (isAbout)
        _showAboutUs();
      else if (isHistory)
        _showHistory();
      else if (isScanner)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QRScannerScreen(userAppointments: appointments),
          ),
        );
      else
        setState(() => _selectedIndex = idx!);
    },
  );

  Widget _buildBottomNavBar() => Container(
    margin: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF4A6FA5), // Same color as header
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: Offset(0, -5),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24),
            activeIcon: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.home, color: Colors.white, size: 22),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined, size: 24),
            activeIcon: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.medical_services,
                color: Colors.white,
                size: 22,
              ),
            ),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined, size: 24),
            activeIcon: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.calendar_month, color: Colors.white, size: 22),
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24),
            activeIcon: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.person, color: Colors.white, size: 22),
            ),
            label: 'Profile',
          ),
        ],
      ),
    ),
  );

  void _showAboutUs() => showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF4A6FA5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(Icons.info, color: Color(0xFF4A6FA5), size: 30),
            ),
            SizedBox(height: 16),
            Text(
              'About Smile Art',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 8),
            Divider(indent: 50, endIndent: 50),
            SizedBox(height: 16),
            _infoRow(
              Icons.location_on,
              'Lower Ground Floor, Gaisano Grandmall Liloan',
            ),
            _infoRow(Icons.access_time, 'Open Daily: 10AM - 7PM'),
            _infoRow(Icons.phone, '0960 434 9004'),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF4A6FA5).withOpacity(0.05),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Est. 2020 - Providing quality dental care.',
                style: TextStyle(color: Color(0xFF4A6FA5)),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A6FA5),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _infoRow(IconData i, String t) => Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF4A6FA5).withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(i, color: Color(0xFF4A6FA5), size: 18),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(t, style: TextStyle(color: Color(0xFF1E293B))),
        ),
      ],
    ),
  );

  void _showLogoutDialog() => showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(Icons.logout, color: Colors.red, size: 30),
            ),
            SizedBox(height: 16),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Are you sure you want to logout?',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  void _showHistory() => showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Treatment History',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF4A6FA5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '${_completed.length} total',
                    style: TextStyle(
                      color: Color(0xFF4A6FA5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 1, height: 1),
          Expanded(
            child: _completed.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.history,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No history yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your completed appointments will appear here',
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _completed.length,
                    itemBuilder: (_, i) => _historyItem(_completed[i]),
                  ),
          ),
        ],
      ),
    ),
  );

  Widget _historyItem(Map<String, dynamic> i) => Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.green.withOpacity(0.2), width: 1),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.check_circle, color: Colors.green, size: 24),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i['doctor'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${i['service']} • ${_formatDate(i['date'])}',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  String _formatDate(DateTime d) =>
      '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1]} ${d.day}, ${d.year}';
  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
}
