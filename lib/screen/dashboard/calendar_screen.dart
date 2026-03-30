import 'package:flutter/material.dart';

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

  // ── ✨ LUXURY GOLD THEME ──
  final Color goldPrimary = const Color(0xFFD4AF37);
  final Color goldDark = const Color(0xFFA67C00);
  final Color goldLight = const Color(0xFFF9E4B7);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get bg => isDark ? const Color(0xFF0F172A) : Colors.white;
  Color get card => isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
  Color get surface =>
      isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
  Color get text => isDark ? Colors.white : const Color(0xFF1E293B);
  Color get textMuted =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get border =>
      isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0);

  Color get success => const Color(0xFF10B981);
  Color get danger => const Color(0xFFEF4444);

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
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          _pad(
            Text(
              'Manage your dental schedule',
              style: TextStyle(
                color: textMuted,
                fontSize: 14,
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

  Widget _headerStats() => Row(
    children: [
      _statPill(
        Icons.calendar_today_rounded,
        '${widget.appointments.where((a) => a['status'] == 'upcoming').length}',
        'Pending',
        goldPrimary,
      ),
      const SizedBox(width: 12),
      _statPill(
        Icons.check_circle_outline_rounded,
        '${widget.appointments.where((a) => a['status'] == 'completed').length}',
        'Done',
        success,
      ),
      const SizedBox(width: 12),
      _statPill(
        Icons.history_rounded,
        '${widget.appointments.length}',
        'Total',
        goldDark,
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

  Widget _calendarCard() => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: border),
      boxShadow: [
        BoxShadow(color: goldPrimary.withOpacity(0.05), blurRadius: 20),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left_rounded, color: goldDark),
              onPressed: () =>
                  setState(() => _m = DateTime(_m.year, _m.month - 1)),
            ),
            Text(
              '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][_m.month - 1]} ${_m.year}',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: goldDark,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right_rounded, color: goldDark),
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
            final dy = i - first + 1,
                date = DateTime(_m.year, _m.month, dy),
                now = DateTime.now();
            final isToday =
                now.day == dy && now.month == _m.month && now.year == _m.year;
            final sel = _sel?.day == dy && _sel?.month == _m.month;
            final hasAppt = widget.appointments.any(
              (a) =>
                  a['date'].day == dy &&
                  a['date'].month == _m.month &&
                  a['date'].year == _m.year,
            );
            return GestureDetector(
              onTap: () => setState(() => _sel = sel ? null : date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: sel
                      ? goldPrimary
                      : isToday
                      ? goldPrimary.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: hasAppt && !sel
                      ? Border.all(
                          color: goldPrimary.withOpacity(0.5),
                          width: 1.5,
                        )
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '$dy',
                      style: TextStyle(
                        color: sel
                            ? Colors.white
                            : (isToday || hasAppt)
                            ? goldDark
                            : text,
                        fontWeight: (sel || isToday || hasAppt)
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
                            color: goldDark,
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
      indicator: BoxDecoration(
        color: goldDark,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: goldDark.withOpacity(0.3), blurRadius: 8)],
      ),
      dividerColor: Colors.transparent,
      labelColor: Colors.white,
      unselectedLabelColor: textMuted,
      tabs: _filters
          .map(
            (f) => Tab(
              height: 36,
              child: Text(
                f,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          )
          .toList(),
    ),
  );

  Widget _appointmentsList() {
    if (_filtered.isEmpty)
      return _pad(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Icon(
                Icons.event_busy_rounded,
                size: 48,
                color: textMuted.withOpacity(0.3),
              ),
              const SizedBox(height: 12),
              Text(
                'No records found',
                style: TextStyle(color: textMuted, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    return Column(children: _filtered.map((a) => _pad(_apptCard(a))).toList());
  }

  Widget _apptCard(Map a) {
    final status = a['status'];
    final isUp = status == 'upcoming';
    final col = isUp ? goldDark : (status == 'completed' ? success : danger);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: col.withOpacity(0.1),
              child: Icon(Icons.medical_services_rounded, color: col),
            ),
            title: Text(
              a['service'],
              style: TextStyle(fontWeight: FontWeight.w900, color: text),
            ),
            subtitle: Text(
              'Dr. ${a['doctor'].split('Dr. ').last}',
              style: TextStyle(
                color: textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: col.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: col,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Divider(height: 1, color: border),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: goldPrimary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${a['date'].day}/${a['date'].month}/${a['date'].year}',
                  style: TextStyle(
                    color: text,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time_rounded, size: 14, color: goldPrimary),
                const SizedBox(width: 6),
                Text(
                  _fmtTime(a['time']),
                  style: TextStyle(
                    color: text,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (isUp) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _reschedule(a),
                      icon: const Icon(Icons.edit_calendar_rounded, size: 16),
                      label: const Text('Reschedule'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldDark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _cancel(a),
                      icon: const Icon(Icons.cancel_rounded, size: 16),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: danger,
                        side: BorderSide(color: danger.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

  void _reschedule(Map a) {
    DateTime m = DateTime(a['date'].year, a['date'].month);
    DateTime? d = a['date'];
    String? t = a['time'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Change Schedule',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: text,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _miniCalendar(
                      m,
                      d,
                      (newD) => setS(() => d = newD),
                      (newM) => setS(() => m = newM),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Available Times',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _miniTimeGrid(t, (newT) => setS(() => t = newT)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: (d != null && t != null)
                      ? () {
                          setState(() {
                            a['date'] = d;
                            a['time'] = t;
                          });
                          widget.onReschedule(null, null, null); // Refresh Home
                          Navigator.pop(ctx);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldDark,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'CONFIRM CHANGES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _miniCalendar(
    DateTime m,
    DateTime? d,
    Function(DateTime) onSel,
    Function(DateTime) onMonth,
  ) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => onMonth(DateTime(m.year, m.month - 1)),
            ),
            Text(
              '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m.month - 1]} ${m.year}',
              style: TextStyle(fontWeight: FontWeight.bold, color: goldDark),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => onMonth(DateTime(m.year, m.month + 1)),
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount:
              DateTime(m.year, m.month + 1, 0).day +
              DateTime(m.year, m.month, 1).weekday -
              1,
          itemBuilder: (_, i) {
            final first = DateTime(m.year, m.month, 1).weekday - 1;
            if (i < first) return const SizedBox();
            final dy = i - first + 1, date = DateTime(m.year, m.month, dy);
            final sel = d?.day == dy && d?.month == m.month;
            return GestureDetector(
              onTap: () => onSel(date),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: sel ? goldDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$dy',
                    style: TextStyle(
                      color: sel ? Colors.white : text,
                      fontSize: 12,
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

  Widget _miniTimeGrid(String? currentT, Function(String) onSel) => Wrap(
    spacing: 10,
    runSpacing: 10,
    children: ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'].map((
      time,
    ) {
      final sel = currentT == time;
      return GestureDetector(
        onTap: () => onSel(time),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: sel ? goldDark : surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: sel ? goldLight : border),
          ),
          child: Text(
            _fmtTime(time),
            style: TextStyle(
              color: sel ? Colors.white : text,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }).toList(),
  );

  void _cancel(Map a) => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Cancel Appointment?'),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('No, Keep It', style: TextStyle(color: textMuted)),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() => a['status'] = 'cancelled');
            widget.onReschedule(null, null, null); // Refresh Home
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: danger),
          child: const Text(
            'Yes, Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );

  String _fmtTime(String t) {
    if (t.isEmpty) return '';
    final p = t.split(':');
    final h = int.parse(p[0]), m = int.parse(p[1]);
    return '${h > 12
        ? h - 12
        : h == 0
        ? 12
        : h}:${m.toString().padLeft(2, '0')} ${h >= 12 ? 'PM' : 'AM'}';
  }
}
