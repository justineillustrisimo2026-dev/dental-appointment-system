import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'app_theme.dart'; // ── GLOBAL THEME IMPORT ──

// ── MAIN SCREEN SETUP: Receives appointment data and handles calendar UI logic. ──
class CalendarScreen extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;
  final String patientName, firstName, lastName;
  final void Function(dynamic idx, dynamic newDate, dynamic newTime)
  onReschedule;

  const CalendarScreen({
    super.key,
    required this.appointments,
    required this.patientName,
    required this.firstName,
    required this.lastName,
    required this.onReschedule,
  });

  get contactNo => null;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  // ── DYNAMIC THEME GETTERS: Handles automatic switching between light and dark mode colors. ──
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get bg => AppTheme.bg(isDark);
  Color get surface => AppTheme.surface(isDark);
  Color get cardBg => AppTheme.cardBg(isDark);
  Color get innerSurface => AppTheme.innerSurface(isDark);
  Color get ink => AppTheme.txt(isDark);
  Color get inkMuted => AppTheme.txtMuted(isDark);
  Color get bdr => AppTheme.bdr(isDark);

  Color get successGreen =>
      isDark ? const Color(0xFF10B981) : const Color(0xFF059669);
  Color get dangerRed =>
      isDark ? Colors.redAccent.shade200 : const Color(0xFFDC2626);
  Color get pendingOrange =>
      isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706);

  LinearGradient get goldGradient => AppTheme.goldGradient;
  List<BoxShadow> get profileShadow => AppTheme.profileShadow(isDark);

  // ── STATE VARIABLES: Tracks current filter, selected date, and UI toggles. ──
  String _filter = 'All';
  DateTime _month = DateTime.now();
  DateTime? _selectedDay;
  late TabController _tabCtrl;

  final _filters = ['All', 'Pending', 'Upcoming', 'Completed', 'Cancelled'];

  final Set<int> _expandedCodes = {};

  final List<String> _rescheduleSlots = [
    "08:00 AM",
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
  ];

  // ── LIFECYCLE: Sets up tab controller on init and disposes it on exit. ──
  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _filters.length, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) {
        setState(() {
          _filter = _filters[_tabCtrl.index];
          _expandedCodes.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  // ── APPOINTMENT FILTERS: Logic to sort and filter appointments by date and status. ──
  List<Map<String, dynamic>> get _filtered {
    var list = widget.appointments;
    if (_selectedDay != null) {
      list = list.where((a) {
        final d = a['date'] as DateTime;
        return d.year == _selectedDay!.year &&
            d.month == _selectedDay!.month &&
            d.day == _selectedDay!.day;
      }).toList();
    }
    if (_filter != 'All') {
      list = list.where((a) => a['status'] == _filter.toLowerCase()).toList();
    }
    list = List.from(list)
      ..sort((a, b) {
        final order = {
          'pending': 0,
          'upcoming': 1,
          'completed': 2,
          'cancelled': 3,
        };
        return (order[a['status']] ?? 4).compareTo(order[b['status']] ?? 4);
      });
    return list;
  }

  int _countByStatus(String s) =>
      widget.appointments.where((a) => a['status'] == s).length;

  bool _hasAppointment(DateTime date) => widget.appointments.any((a) {
    final d = a['date'] as DateTime;
    return d.year == date.year && d.month == date.month && d.day == date.day;
  });

  // ── DATA FORMATTERS: Helper functions to format time and dates neatly. ──
  String _fmtTime(String t) {
    if (t.isEmpty) return '';
    if (t.contains('AM') || t.contains('PM')) return t;
    try {
      final p = t.split(':');
      final h = int.parse(p[0]);
      final m = p[1];
      return '${h > 12
          ? h - 12
          : h == 0
          ? 12
          : h}:$m ${h >= 12 ? 'PM' : 'AM'}';
    } catch (_) {
      return t;
    }
  }

  String _fmtDate(DateTime d) => DateFormat('EEE, MMM d, yyyy').format(d);

  // ── MAIN BUILD METHOD: Constructs the CustomScrollView holding the calendar and lists. ──
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          SliverToBoxAdapter(child: _buildStatsRow()),
          SliverToBoxAdapter(child: _buildCalendarCard()),
          SliverToBoxAdapter(child: _buildFilterTabs()),
          _buildAppointmentSliver(),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ── TOP HEADER: Collapsible app bar displaying user greeting. ──
  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 80,
      floating: false,
      pinned: true,
      backgroundColor: cardBg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Appointments",
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: ink,
              ),
            ),
            Text(
              "Hello, ${widget.firstName}! Manage your schedule",
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: inkMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            color: cardBg,
            border: Border(bottom: BorderSide(color: bdr)),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 48, right: 20),
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppTheme.goldPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── STATS ROW: Displays counts for Pending, Upcoming, Completed, and Cancelled apps. ──
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        children: [
          _statCard(
            Icons.schedule_rounded,
            "${_countByStatus('pending')}",
            "Pending",
            pendingOrange,
          ),
          const SizedBox(width: 8),
          _statCard(
            Icons.hourglass_top_rounded,
            "${_countByStatus('upcoming')}",
            "Upcoming",
            AppTheme.goldPrimary,
          ),
          const SizedBox(width: 8),
          _statCard(
            Icons.check_circle_outline_rounded,
            "${_countByStatus('completed')}",
            "Complete",
            successGreen,
          ),
          const SizedBox(width: 8),
          _statCard(
            Icons.cancel_outlined,
            "${_countByStatus('cancelled')}",
            "Cancel",
            dangerRed,
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String val, String label, Color color) {
    return Expanded(
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
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: ink,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: inkMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ── CALENDAR VIEW: Generates the month grid and highlights selected/today/appt dates. ──
  Widget _buildCalendarCard() {
    final daysInMonth = DateUtils.getDaysInMonth(_month.year, _month.month);
    final firstOffset = (_month.weekday - 1) % 7;
    final today = DateTime.now();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: bdr),
          boxShadow: profileShadow,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navBtn(
                  Icons.chevron_left_rounded,
                  () => setState(
                    () => _month = DateTime(_month.year, _month.month - 1),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    _month = DateTime.now();
                    _selectedDay = null;
                  }),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(_month),
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: ink,
                        ),
                      ),
                      if (_selectedDay != null)
                        Text(
                          DateFormat('MMM d').format(_selectedDay!),
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: AppTheme.goldPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
                _navBtn(
                  Icons.chevron_right_rounded,
                  () => setState(
                    () => _month = DateTime(_month.year, _month.month + 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: d == "Su"
                                ? dangerRed.withOpacity(0.5)
                                : inkMuted,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: 42,
                mainAxisSpacing: 2,
              ),
              itemCount: firstOffset + daysInMonth,
              itemBuilder: (_, i) {
                if (i < firstOffset) return const SizedBox();
                final day = i - firstOffset + 1;
                final date = DateTime(_month.year, _month.month, day);
                final isToday =
                    date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;
                final isSel =
                    _selectedDay != null &&
                    _selectedDay!.year == date.year &&
                    _selectedDay!.month == date.month &&
                    _selectedDay!.day == date.day;
                final hasAppt = _hasAppointment(date);
                final isSunday = date.weekday == DateTime.sunday;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedDay = isSel ? null : date);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: isSel ? goldGradient : null,
                      color: isSel
                          ? null
                          : isToday
                          ? innerSurface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isToday && !isSel
                          ? Border.all(
                              color: AppTheme.goldPrimary.withOpacity(0.5),
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "$day",
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: isSel || isToday || hasAppt
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: isSel
                                ? Colors.white
                                : isSunday
                                ? dangerRed.withOpacity(0.4)
                                : isToday
                                ? AppTheme.goldPrimary
                                : ink,
                          ),
                        ),
                        if (hasAppt && !isSel)
                          Positioned(
                            bottom: 4,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: AppTheme.goldPrimary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendDot(AppTheme.goldPrimary, "Has appointment"),
                const SizedBox(width: 16),
                _legendDot(innerSurface, "Today", border: AppTheme.goldPrimary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: innerSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: bdr),
        ),
        child: Icon(icon, color: ink, size: 20),
      ),
    );
  }

  Widget _legendDot(Color c, String label, {Color? border}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: border != null
                ? Border.all(color: border, width: 1.5)
                : null,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            color: inkMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ── FILTER TABS: Buttons to sort the appointment list below the calendar. ──
  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: bdr),
        ),
        child: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicator: BoxDecoration(
            gradient: goldGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.goldPrimary.withOpacity(0.3),
                blurRadius: 8,
              ),
            ],
          ),
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: inkMuted,
          labelStyle: GoogleFonts.dmSans(
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          tabs: _filters.map((f) => Tab(height: 36, text: f)).toList(),
        ),
      ),
    );
  }

  // ── APPOINTMENT LIST: Renders the filtered appointments as a scrolling list of cards. ──
  Widget _buildAppointmentSliver() {
    final list = _filtered;

    if (list.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: bdr),
              boxShadow: profileShadow,
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: innerSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.event_busy_rounded,
                    size: 30,
                    color: inkMuted.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedDay != null
                      ? "No appointments on this day"
                      : "No appointments found",
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Book a service to see it here",
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: inkMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((_, i) {
        final appt = list[i];
        final showHeader =
            i == 0 ||
            (list[i]['date'] as DateTime).day !=
                (list[i - 1]['date'] as DateTime).day;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showHeader) ...[
                const SizedBox(height: 20),
                _dateHeader(appt['date'] as DateTime),
                const SizedBox(height: 10),
              ],
              _appointmentCard(appt, i),
            ],
          ),
        );
      }, childCount: list.length),
    );
  }

  Widget _dateHeader(DateTime date) {
    final today = DateTime.now();
    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    final isTomorrow =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day + 1;
    String label = isToday
        ? "Today"
        : isTomorrow
        ? "Tomorrow"
        : DateFormat('EEEE, MMMM d').format(date);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isToday ? innerSurface : surface,
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(color: AppTheme.goldPrimary.withOpacity(0.4))
                : Border.all(color: bdr),
          ),
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isToday ? AppTheme.goldPrimary : inkMuted,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: bdr)),
      ],
    );
  }

  Widget _appointmentCard(Map<String, dynamic> a, int index) {
    final status = a['status'] as String;
    final isPending = status == 'pending';
    final isUpcoming = status == 'upcoming';
    final isCompleted = status == 'completed';
    final isCancelled = status == 'cancelled';

    final Color statusColor = isPending
        ? pendingOrange
        : isUpcoming
        ? AppTheme.goldPrimary
        : isCompleted
        ? successGreen
        : dangerRed;

    final String statusLabel = isPending
        ? 'Pending Approval'
        : isUpcoming
        ? 'Confirmed'
        : status.toUpperCase();

    final DateTime? date = a['date'] as DateTime?;
    final String dateStr = date != null
        ? DateFormat('EEEE, MMMM d, yyyy').format(date)
        : 'TBD';
    final String timeStr = _fmtTime(a['time'] ?? 'TBD');
    final String duration = a['duration'] ?? '—';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isUpcoming ? statusColor.withOpacity(0.4) : bdr,
          width: isUpcoming ? 1.5 : 1,
        ),
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
                  color: isUpcoming || isPending
                      ? statusColor.withOpacity(isDark ? 0.1 : 0.15)
                      : innerSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.5)),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.dmSans(
                    color: statusColor,
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
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.medical_services_rounded,
                  color: statusColor,
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
                        color: ink,
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
                        color: inkMuted,
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
                        color: inkMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$dateStr • $timeStr",
                      style: GoogleFonts.dmSans(
                        color: ink,
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
                    Icon(Icons.timer_outlined, size: 14, color: inkMuted),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: GoogleFonts.dmSans(
                        color: inkMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (isPending || isUpcoming) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    label: "Reschedule",
                    color: AppTheme.goldPrimary,
                    gradient: goldGradient,
                    onTap: () => _showReschedule(a),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _actionButton(
                    label: "Summary",
                    color: AppTheme.goldPrimary,
                    outlined: true,
                    onTap: () =>
                        _showAppointmentSummary(a, statusLabel, statusColor),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _actionButton(
                    label: "Cancel",
                    color: dangerRed,
                    outlined: true,
                    onTap: () => _showCancelDialog(a),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── APPOINTMENT SUMMARY: Bottom sheet showing full details of a clicked appointment. ──
  void _showAppointmentSummary(
    Map<String, dynamic> a,
    String statusLabel,
    Color statusColor,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: bdr,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.goldPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: AppTheme.goldPrimary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Appointment Summary",
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: ink,
                          ),
                        ),
                        Text(
                          "Full booking details",
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: inkMuted,
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
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      statusLabel,
                      style: GoogleFonts.dmSans(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildSectionHeader("Patient Info"),
                  const SizedBox(height: 8),
                  _summaryRow(
                    Icons.person_outline_rounded,
                    "Name",
                    a['patientName'] ??
                        "${widget.firstName} ${widget.lastName}",
                  ),
                  _summaryRow(
                    Icons.cake_outlined,
                    "Age",
                    "${a['patientAge'] ?? '—'} yrs",
                  ),
                  _summaryRow(
                    Icons.phone_outlined,
                    "Contact",
                    a['patientContact'] ?? widget.contactNo,
                  ),
                  const SizedBox(height: 16),

                  _buildSectionHeader("Service Details"),
                  const SizedBox(height: 8),
                  _summaryRow(
                    Icons.medical_services_outlined,
                    "Service",
                    a['service'] ?? "—",
                    highlight: true,
                  ),
                  _summaryRow(
                    Icons.payments_outlined,
                    "Price",
                    a['price'] ?? "—",
                    valColor: AppTheme.goldPrimary,
                  ),
                  _summaryRow(
                    Icons.timer_outlined,
                    "Duration",
                    a['duration'] ?? "—",
                  ),
                  const SizedBox(height: 16),

                  _buildSectionHeader("Schedule"),
                  const SizedBox(height: 8),
                  _summaryRow(
                    Icons.calendar_today_outlined,
                    "Date",
                    a['date'] != null
                        ? DateFormat('EEE, MMM d, yyyy').format(a['date'])
                        : "—",
                  ),
                  _summaryRow(
                    Icons.access_time_rounded,
                    "Time",
                    _fmtTime(a['time'] ?? "—"),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionHeader("Dentist"),
                  const SizedBox(height: 8),
                  _summaryRow(
                    Icons.person_outline_rounded,
                    "Name",
                    a['doctor'] ?? "—",
                  ),
                  _summaryRow(
                    Icons.work_outline_rounded,
                    "Specialty",
                    a['specialty'] ?? "—",
                  ),

                  if (a['confirmationCode'] != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: innerSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.goldPrimary.withOpacity(0.4),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "CONFIRMATION CODE",
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: inkMuted,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            a['confirmationCode'],
                            style: GoogleFonts.dmSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.goldPrimary,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
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
          title,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: ink,
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(
    IconData icon,
    String label,
    String val, {
    Color? valColor,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: highlight ? innerSurface : innerSurface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: highlight
                  ? Border.all(color: AppTheme.goldPrimary.withOpacity(0.3))
                  : null,
            ),
            child: Icon(
              icon,
              size: 18,
              color: highlight ? AppTheme.goldPrimary : inkMuted,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: highlight ? ink : inkMuted,
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: valColor != null
                  ? valColor.withOpacity(0.1)
                  : innerSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              val,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: valColor ?? ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── ACTION BUTTONS: Reusable text-only buttons for canceling/rescheduling. ──
  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool outlined = false,
    Gradient? gradient,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: outlined
              ? Colors.transparent
              : (gradient == null ? color : null),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: outlined ? color.withOpacity(0.5) : Colors.transparent,
          ),
          gradient: outlined
              ? null
              : (gradient ??
                    LinearGradient(colors: [color, color.withOpacity(0.8)])),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: outlined ? color : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ── RESCHEDULE MODAL: Opens a bottom sheet with a calendar to pick a new date/time. ──
  void _showReschedule(Map<String, dynamic> a) {
    DateTime sheetMonth = a['date'] as DateTime;
    DateTime? sheetDate = a['date'] as DateTime;
    String? sheetTime = a['time'] as String?;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: bdr,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: innerSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.goldPrimary.withOpacity(0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.edit_calendar_rounded,
                        color: AppTheme.goldPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reschedule",
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: ink,
                          ),
                        ),
                        Text(
                          a['service'] ?? '',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Text(
                      "Select New Date",
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _sheetCalendar(
                      sheetMonth,
                      sheetDate,
                      (d) => setSheet(() => sheetDate = d),
                      (m) => setSheet(() => sheetMonth = m),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Select Time",
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _sheetTimeGrid(
                      sheetTime,
                      (t) => setSheet(() => sheetTime = t),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  MediaQuery.of(context).padding.bottom + 20,
                ),
                child: AnimatedOpacity(
                  opacity: (sheetDate != null && sheetTime != null)
                      ? 1.0
                      : 0.45,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: (sheetDate != null && sheetTime != null)
                        ? () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              a['date'] = sheetDate;
                              a['time'] = sheetTime;
                            });
                            widget.onReschedule(null, sheetDate, sheetTime);
                            Navigator.pop(ctx);
                            _showSuccessSnack("Appointment rescheduled!");
                          }
                        : null,
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: goldGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.goldPrimary.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Confirm Changes",
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetCalendar(
    DateTime month,
    DateTime? selected,
    Function(DateTime) onSel,
    Function(DateTime) onMonth,
  ) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final firstOffset = (month.weekday - 1) % 7;
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: bdr),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navBtn(
                Icons.chevron_left_rounded,
                () => onMonth(DateTime(month.year, month.month - 1)),
              ),
              Text(
                DateFormat('MMMM yyyy').format(month),
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: ink,
                ),
              ),
              _navBtn(
                Icons.chevron_right_rounded,
                () => onMonth(DateTime(month.year, month.month + 1)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: inkMuted,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 38,
              mainAxisSpacing: 2,
            ),
            itemCount: firstOffset + daysInMonth,
            itemBuilder: (_, i) {
              if (i < firstOffset) return const SizedBox();
              final day = i - firstOffset + 1;
              final date = DateTime(month.year, month.month, day);
              final isPast = date.isBefore(
                DateTime(today.year, today.month, today.day),
              );
              final isSunday = date.weekday == DateTime.sunday;
              final disabled = isPast || isSunday;
              final isSel =
                  selected != null &&
                  selected.year == date.year &&
                  selected.month == date.month &&
                  selected.day == date.day;
              final isToday =
                  date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;
              return GestureDetector(
                onTap: disabled
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        onSel(date);
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: isSel ? goldGradient : null,
                    color: isSel
                        ? null
                        : isToday
                        ? innerSurface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday && !isSel
                        ? Border.all(
                            color: AppTheme.goldPrimary.withOpacity(0.5),
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      "$day",
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: isSel || isToday
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSel
                            ? Colors.white
                            : disabled
                            ? inkMuted.withOpacity(0.4)
                            : ink,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── TIME SELECTION GRID: Shows available time slots in a grid for the selected date. ──
  Widget _sheetTimeGrid(String? current, Function(String) onSel) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 44,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: _rescheduleSlots.length,
      itemBuilder: (_, i) {
        final t = _rescheduleSlots[i];
        final sel = current == t;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onSel(t);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              gradient: sel ? goldGradient : null,
              color: sel ? null : cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: sel ? AppTheme.goldPrimary : bdr,
                width: sel ? 1.5 : 1,
              ),
              boxShadow: sel
                  ? [
                      BoxShadow(
                        color: AppTheme.goldPrimary.withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                _fmtTime(t),
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: sel ? Colors.white : ink,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── CANCELLATION DIALOG: Prompts the user to confirm before changing status to cancelled. ──
  void _showCancelDialog(Map<String, dynamic> a) {
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
                  color: dangerRed.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.cancel_outlined, color: dangerRed, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                "Cancel Appointment?",
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Are you sure you want to cancel your ${a['service']} appointment on ${_fmtDate(a['date'] as DateTime)}?",
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: inkMuted,
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
                            "Keep It",
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: ink,
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
                        setState(() => a['status'] = 'cancelled');
                        widget.onReschedule(null, null, null);
                        Navigator.pop(context);
                        _showSuccessSnack("Appointment cancelled.");
                      },
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: dangerRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Yes, Cancel",
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

  // ── SNACKBAR: Shows a small pop-up notification at the bottom after action success. ──
  void _showSuccessSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              msg,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
