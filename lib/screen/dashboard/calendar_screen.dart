import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;
  final String patientName, firstName, lastName;
  const CalendarScreen({
    super.key,
    required this.appointments,
    required this.patientName,
    required this.firstName,
    required this.lastName,
  });
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  String _filter = 'All';
  DateTime _m = DateTime.now();
  DateTime? _sel;
  late TabController _tabs;

  final _filters = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  // ── DYNAMIC THEME COLORS TO MATCH DASHBOARD ──
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
  Color get danger => const Color(0xFFEF4444); // Used in Calendar
  Color get warning => const Color(0xFFF59E0B); // Used in Calendar

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _filters.length, vsync: this);
    _tabs.addListener(() => setState(() => _filter = _filters[_tabs.index]));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    var l = _sel != null
        ? widget.appointments
              .where(
                (a) =>
                    a['date'].day == _sel!.day &&
                    a['date'].month == _sel!.month &&
                    a['date'].year == _sel!.year,
              )
              .toList()
        : widget.appointments;
    if (_filter == 'All') return l.toList();
    return l.where((a) => a['status'] == _filter.toLowerCase()).toList();
  }

  Widget _pad(Widget w) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: w);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 115, bottom: 100),
        children: [
          _pad(
            Text(
              'My Appointments',
              style: TextStyle(
                color: text,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          _pad(
            Text(
              'Manage your dental schedule cleanly',
              style: TextStyle(
                color: textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),

          _pad(_headerStats()),
          const SizedBox(height: 24),

          _pad(_calendarCard()),
          const SizedBox(height: 24),

          _pad(_tabBar()),
          const SizedBox(height: 20),

          _appointmentsList(),
        ],
      ),
    );
  }

  // ── HEADER STATS PILLS ───────────────────────────────────
  Widget _headerStats() => Row(
    children: [
      _statPill(
        Icons.upcoming_rounded,
        '${widget.appointments.where((a) => a['status'] == 'upcoming').length}',
        'Upcoming',
        primary,
      ),
      const SizedBox(width: 12),
      _statPill(
        Icons.check_circle_rounded,
        '${widget.appointments.where((a) => a['status'] == 'completed').length}',
        'Completed',
        success,
      ),
      const SizedBox(width: 12),
      _statPill(
        Icons.library_books_rounded,
        '${widget.appointments.length}',
        'Total',
        warning,
      ),
    ],
  );

  Widget _statPill(IconData icon, String val, String label, Color c) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              Icon(icon, color: c, size: 24),
              const SizedBox(height: 8),
              Text(
                val,
                style: TextStyle(
                  color: text,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );

  // ── INTERACTIVE CALENDAR ─────────────────────────────────
  Widget _calendarCard() => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: border),
      boxShadow: [BoxShadow(color: primary.withOpacity(0.05), blurRadius: 20)],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left_rounded, color: primary),
              onPressed: () =>
                  setState(() => _m = DateTime(_m.year, _m.month - 1)),
            ),
            GestureDetector(
              onTap: () => setState(() {
                _m = DateTime.now();
                _sel = null;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][_m.month - 1]} ${_m.year}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: primary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right_rounded, color: primary),
              onPressed: () =>
                  setState(() => _m = DateTime(_m.year, _m.month + 1)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
              .map(
                (d) => Text(
                  d,
                  style: TextStyle(
                    color: textMuted,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.1,
          ),
          itemCount:
              DateTime(_m.year, _m.month + 1, 0).day +
              DateTime(_m.year, _m.month, 1).weekday -
              1,
          itemBuilder: (_, i) {
            final first = DateTime(_m.year, _m.month, 1).weekday - 1;
            if (i < first) return const SizedBox();
            final d = i - first + 1,
                date = DateTime(_m.year, _m.month, d),
                now = DateTime.now();
            final isToday =
                now.day == d && now.month == _m.month && now.year == _m.year;
            final sel = _sel?.day == d && _sel?.month == _m.month;
            final hasAppt = widget.appointments.any(
              (a) =>
                  a['date'].day == d &&
                  a['date'].month == _m.month &&
                  a['date'].year == _m.year,
            );
            return GestureDetector(
              onTap: () => setState(() => _sel = sel ? null : date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: sel
                      ? primary
                      : isToday
                      ? primary.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: hasAppt && !sel
                      ? Border.all(color: primary.withOpacity(0.5), width: 1.5)
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '$d',
                      style: TextStyle(
                        color: sel
                            ? Colors.white
                            : isToday || hasAppt
                            ? primary
                            : text,
                        fontWeight: sel || isToday || hasAppt
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (hasAppt && !sel)
                      Positioned(
                        bottom: 4,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: primary,
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
        if (_sel != null) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => _sel = null),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.filter_alt_rounded, size: 14, color: primary),
                  const SizedBox(width: 8),
                  Text(
                    'Showing: ${_sel!.day}/${_sel!.month}/${_sel!.year}',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.close_rounded, size: 14, color: primary),
                ],
              ),
            ),
          ),
        ],
      ],
    ),
  );

  Widget _tabBar() => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: border),
    ),
    child: TabBar(
      controller: _tabs,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      dividerColor: Colors.transparent,
      labelColor: Colors.white,
      unselectedLabelColor: textMuted,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      tabs: _filters.map((f) => Tab(height: 36, text: f)).toList(),
    ),
  );

  Widget _appointmentsList() {
    if (_filtered.isEmpty)
      return _pad(
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              Icon(
                Icons.event_busy_rounded,
                size: 48,
                color: textMuted.withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'No appointments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Try a different filter or date',
                style: TextStyle(color: textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    return Column(children: _filtered.map((a) => _pad(_apptCard(a))).toList());
  }

  // ── APPOINTMENT CARDS ──────────────────────────────────────
  Widget _apptCard(Map a) {
    final status = a['status'];
    final isUp = status == 'upcoming', isDone = status == 'completed';
    final col = isUp
        ? primary
        : isDone
        ? success
        : danger;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: col.withOpacity(0.15),
                  child: Text(
                    a['doctor'][0],
                    style: TextStyle(
                      color: col,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a['doctor'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: text,
                        ),
                      ),
                      Text(
                        a['service'],
                        style: TextStyle(color: textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: col.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isUp
                            ? Icons.upcoming_rounded
                            : isDone
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: col,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isUp
                            ? 'Upcoming'
                            : isDone
                            ? 'Done'
                            : 'Cancelled',
                        style: TextStyle(
                          color: col,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _chip(
                  Icons.calendar_today_rounded,
                  '${a['date'].day}/${a['date'].month}/${a['date'].year}',
                ),
                const SizedBox(width: 10),
                _chip(Icons.access_time_rounded, _fmtTime(a['time'])),
              ],
            ),
          ),
          if (isUp) ...[
            Divider(height: 1, color: border),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _reschedule(a),
                      style: TextButton.styleFrom(
                        iconColor: primary,
                        foregroundColor: primary,
                      ),
                      icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                      label: const Text(
                        'Reschedule',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _cancel(a),
                      style: TextButton.styleFrom(
                        iconColor: danger,
                        foregroundColor: danger,
                      ),
                      icon: const Icon(Icons.cancel_rounded, size: 18),
                      label: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(IconData i, String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(i, size: 14, color: primary),
        const SizedBox(width: 6),
        Text(
          t,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: text,
          ),
        ),
      ],
    ),
  );

  // ── CUSTOM RESCHEDULE SYSTEM ──────────────────────────────
  void _reschedule(Map a) {
    DateTime m = DateTime(a['date'].year, a['date'].month);
    DateTime? d = a['date'];
    final p = a['time'].split(':');
    TimeOfDay? t = TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));

    // Match times with doctor's schedule exactly like ServicesScreen
    final docsRef = [
      {
        'n': 'Dr. Justine Illustrisimo',
        'a': ['09:00', '10:00', '11:00', '14:00', '15:00'],
      },
      {
        'n': 'Dr. Sarah Smith',
        'a': ['10:00', '11:00', '14:00', '15:00', '16:00'],
      },
      {
        'n': 'Dr. Michael Chen',
        'a': ['08:00', '09:00', '10:00', '13:00', '14:00'],
      },
      {
        'n': 'Dr. Maria Santos',
        'a': ['09:00', '11:00', '13:00', '15:00', '16:00'],
      },
    ];
    List<String> slots;
    try {
      slots =
          (docsRef.firstWhere((doc) => doc['n'] == a['doctor'])['a'] as List)
              .cast<String>();
    } catch (_) {
      slots = ['09:00', '10:00', '11:00', '14:00', '15:00'];
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.88,
            decoration: BoxDecoration(
              color: card,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reschedule Appointment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: text,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: border),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Service & Doctor Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: primary.withOpacity(0.15),
                              child: Icon(
                                Icons.medical_services_rounded,
                                color: primary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a['service'],
                                    style: TextStyle(
                                      color: text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'with ${a['doctor']}',
                                    style: TextStyle(
                                      color: textMuted,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Select New Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: text,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Custom Calendar UI Block inside the modal
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: border),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.chevron_left_rounded,
                                    color: primary,
                                  ),
                                  onPressed: () => setS(
                                    () => m = DateTime(m.year, m.month - 1),
                                  ),
                                ),
                                Text(
                                  '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m.month - 1]} ${m.year}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: primary,
                                    fontSize: 15,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.chevron_right_rounded,
                                    color: primary,
                                  ),
                                  onPressed: () => setS(
                                    () => m = DateTime(m.year, m.month + 1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:
                                  ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
                                      .map(
                                        (day) => Text(
                                          day,
                                          style: TextStyle(
                                            color: textMuted,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    childAspectRatio: 1.1,
                                  ),
                              itemCount:
                                  DateTime(m.year, m.month + 1, 0).day +
                                  DateTime(m.year, m.month, 1).weekday -
                                  1,
                              itemBuilder: (_, i) {
                                final first =
                                    DateTime(m.year, m.month, 1).weekday - 1;
                                if (i < first) return const SizedBox();
                                final dy = i - first + 1,
                                    date = DateTime(m.year, m.month, dy),
                                    now = DateTime.now();
                                final isToday =
                                    now.day == dy &&
                                    now.month == m.month &&
                                    now.year == m.year;
                                final sel =
                                    d?.day == dy &&
                                    d?.month == m.month &&
                                    d?.year == m.year;
                                return GestureDetector(
                                  onTap: () => setS(() {
                                    d = date;
                                    t = null;
                                  }),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: sel
                                          ? primary
                                          : isToday
                                          ? primary.withOpacity(0.15)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$dy',
                                        style: TextStyle(
                                          color: sel
                                              ? Colors.white
                                              : isToday
                                              ? primary
                                              : text,
                                          fontWeight: sel || isToday
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (d != null) ...[
                        Text(
                          'Select New Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: text,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: slots.map((timeStr) {
                            final sel =
                                t != null &&
                                '${t!.hour.toString().padLeft(2, '0')}:${t!.minute.toString().padLeft(2, '0')}' ==
                                    timeStr;
                            return GestureDetector(
                              onTap: () => setS(
                                () => t = TimeOfDay(
                                  hour: int.parse(timeStr.split(':')[0]),
                                  minute: int.parse(timeStr.split(':')[1]),
                                ),
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: sel ? primary : surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: sel ? accent : border,
                                  ),
                                ),
                                child: Text(
                                  _fmtTime(timeStr),
                                  style: TextStyle(
                                    color: sel ? Colors.white : text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 40),

                      if (d != null && t != null)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              a['date'] = d;
                              a['time'] =
                                  '${t!.hour.toString().padLeft(2, '0')}:${t!.minute.toString().padLeft(2, '0')}';
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Rescheduled successfully!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: primary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Confirm Reschedule',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _cancel(Map a) => showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: danger.withOpacity(0.1),
              child: Icon(Icons.cancel_rounded, color: danger, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              'Cancel Appointment',
              style: TextStyle(
                color: text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to cancel this appointment?',
              textAlign: TextAlign.center,
              style: TextStyle(color: textMuted),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Keep It',
                      style: TextStyle(
                        color: textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => a['status'] = 'cancelled');
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: danger,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  String _fmtTime(String t) {
    if (t.isEmpty) return '';
    final p = t.split(':');
    if (p.length < 2) return t;
    final h = int.parse(p[0]), m = int.parse(p[1]);
    return '${h > 12
        ? h - 12
        : h == 0
        ? 12
        : h}:${m.toString().padLeft(2, '0')} ${h >= 12 ? 'PM' : 'AM'}';
  }
}
