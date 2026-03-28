import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;
  final Function(Map<String, dynamic>) onBookAppointment;
  final String patientName, firstName, lastName;

  const ServicesScreen({
    super.key,
    required this.appointments,
    required this.onBookAppointment,
    required this.patientName,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String? _srv, _doc;
  DateTime? _dat;
  TimeOfDay? _tim;
  DateTime _m = DateTime.now();

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

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
  Color get success => const Color(0xFF10B981);

  // ── 🏥 OFFICIAL SERVICES LIST ──
  final _services = [
    {
      'n': 'Braces & Adjustments',
      'i': Icons.health_and_safety_rounded,
      'p': '₱5K Down',
      'dur': '1-2 Years',
    },
    {
      'n': 'Consultation',
      'i': Icons.chat_rounded,
      'p': '₱500',
      'dur': '30 mins',
    },
    {
      'n': 'Panoramic X-Ray',
      'i': Icons.radar_rounded,
      'p': '₱1,000',
      'dur': '15 mins',
    },
    {
      'n': 'Oral Prophylaxis',
      'i': Icons.cleaning_services_rounded,
      'p': '₱850–1,200',
      'dur': '45 mins',
    },
    {
      'n': 'Tooth Extraction',
      'i': Icons.healing_rounded,
      'p': '₱850–1,200',
      'dur': '30-45 mins',
    },
    {
      'n': 'Wisdom Tooth Removal',
      'i': Icons.medical_services_rounded,
      'p': '₱8K–13K',
      'dur': '60 mins',
    },
    {
      'n': 'Dental Filling (Pasta)',
      'i': Icons.build_rounded,
      'p': '₱850–1,200',
      'dur': '30 mins',
    },
    {
      'n': 'Dentures (Pustiso)',
      'i': Icons.face_rounded,
      'p': 'From ₱1K',
      'dur': 'Multiple sittings',
    },
    {
      'n': 'Dental Bridges',
      'i': Icons.settings_input_component_rounded,
      'p': '₱1,000',
      'dur': '2-3 Sessions',
    },
    {
      'n': 'Dental Jacket / Crown',
      'i': Icons.workspace_premium_rounded,
      'p': '₱1,000',
      'dur': '2 Sessions',
    },
    {
      'n': 'Teeth Whitening',
      'i': Icons.auto_awesome_rounded,
      'p': '₱3K/sess.',
      'dur': '60 mins',
    },
    {
      'n': 'Root Canal (RCT)',
      'i': Icons.psychology_rounded,
      'p': '₱8,000',
      'dur': '60-90 mins',
    },
  ];

  final _docs = [
    {
      'n': 'Dr. Justine Illustrisimo',
      's': 'Orthodontist',
      'h': 'Mon–Fri 9–5',
      'a': ['09:00', '10:00', '11:00', '14:00', '15:00'],
    },
    {
      'n': 'Dr. Sarah Smith',
      's': 'General Dentist',
      'h': 'Tue–Sat 10–6',
      'a': ['10:00', '11:00', '14:00', '15:00', '16:00'],
    },
    {
      'n': 'Dr. Michael Chen',
      's': 'Oral Surgeon',
      'h': 'Mon–Thu 8–4',
      'a': ['08:00', '09:00', '10:00', '13:00', '14:00'],
    },
  ];

  int get _step {
    if (_srv != null && _doc != null && _dat != null && _tim != null) return 4;
    if (_srv != null && _doc != null && _dat != null) return 3;
    if (_srv != null && _doc != null) return 2;
    return 1;
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
          _pad(_progressBar()),
          const SizedBox(height: 32),

          // STEP 01: SERVICE
          _pad(
            _sectionHeader('01', 'Our Services', 'Select a dental treatment'),
          ),
          const SizedBox(height: 12),
          _servicesSwiper(),
          const SizedBox(height: 30),

          // STEP 02: DOCTOR
          _pad(
            _sectionHeader('02', 'Your Doctor', 'Pick your preferred dentist'),
          ),
          const SizedBox(height: 14),
          ..._docs.map((d) => _pad(_docCard(d))),
          const SizedBox(height: 30),

          // STEP 03: DATE
          _pad(
            _sectionHeader(
              '03',
              'Appointment Date',
              'Choose a day for your visit',
            ),
          ),
          const SizedBox(height: 14),
          _pad(_cal()),
          const SizedBox(height: 30),

          // STEP 04: TIME
          _pad(
            _sectionHeader(
              '04',
              'Available Times',
              'Select a convenient time slot',
            ),
          ),
          const SizedBox(height: 14),
          _doc == null
              ? _pad(
                  _placeholder('Please select a doctor to see available slots'),
                )
              : _pad(_times()),

          const SizedBox(height: 40),

          // FINAL ACTION BUTTON
          _pad(
            ElevatedButton(
              onPressed:
                  (_srv != null && _doc != null && _dat != null && _tim != null)
                  ? _confirm
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: goldDark,
                disabledBackgroundColor: border,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 5,
              ),
              child: const Text(
                'BOOK APPOINTMENT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String num, String title, String sub) => Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: goldPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: goldPrimary),
        ),
        child: Text(
          num,
          style: TextStyle(
            color: goldDark,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: text,
            ),
          ),
          Text(sub, style: TextStyle(fontSize: 12, color: textMuted)),
        ],
      ),
    ],
  );

  Widget _placeholder(String msg) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: surface.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: border),
    ),
    child: Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textMuted,
        fontStyle: FontStyle.italic,
        fontSize: 13,
      ),
    ),
  );

  Widget _servicesSwiper() => SizedBox(
    height: 145,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _services.length,
      itemBuilder: (_, i) {
        final s = _services[i];
        final sel = _srv == s['n'];
        return GestureDetector(
          onTap: () => setState(() {
            _srv = s['n'] as String;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 12),
            width: 115,
            decoration: BoxDecoration(
              color: sel ? goldPrimary : card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: sel ? goldLight : border),
              boxShadow: sel
                  ? [
                      BoxShadow(
                        color: goldDark.withOpacity(0.2),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  s['i'] as IconData,
                  color: sel ? Colors.white : goldDark,
                  size: 30,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    s['n'] as String,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: sel ? Colors.white : text,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s['p'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: sel ? Colors.white70 : goldDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  Widget _docCard(Map d) {
    final sel = _doc == d['n'];
    return GestureDetector(
      onTap: () => setState(() {
        _doc = d['n'];
        _tim = null;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: sel ? goldPrimary : card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sel ? goldLight : border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: sel
                  ? Colors.white24
                  : goldPrimary.withOpacity(0.1),
              child: Text(
                (d['n'] as String)[4],
                style: TextStyle(
                  color: sel ? Colors.white : goldDark,
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
                    d['n'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: sel ? Colors.white : text,
                    ),
                  ),
                  Text(
                    '${d['s']} · ${d['h']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: sel ? Colors.white70 : textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (sel) const Icon(Icons.check_circle, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _cal() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: border),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: goldDark),
              onPressed: () =>
                  setState(() => _m = DateTime(_m.year, _m.month - 1)),
            ),
            Text(
              '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][_m.month - 1]} ${_m.year}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: text,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: goldDark),
              onPressed: () =>
                  setState(() => _m = DateTime(_m.year, _m.month + 1)),
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
              DateTime(_m.year, _m.month + 1, 0).day +
              DateTime(_m.year, _m.month, 1).weekday -
              1,
          itemBuilder: (_, i) {
            final first = DateTime(_m.year, _m.month, 1).weekday - 1;
            if (i < first) return const SizedBox();
            final d = i - first + 1,
                date = DateTime(_m.year, _m.month, d),
                now = DateTime.now();
            final isPast = date.isBefore(
              DateTime(now.year, now.month, now.day),
            );
            final isToday =
                date.day == now.day &&
                date.month == now.month &&
                date.year == now.year;
            final sel = _dat?.day == d && _dat?.month == _m.month;
            return GestureDetector(
              onTap: isPast
                  ? null
                  : () => setState(() {
                      _dat = date;
                      _tim = null;
                    }),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: sel
                      ? goldPrimary
                      : isToday
                      ? goldPrimary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isToday ? Border.all(color: goldPrimary) : null,
                ),
                child: Center(
                  child: Text(
                    '$d',
                    style: TextStyle(
                      color: isPast
                          ? textMuted.withOpacity(0.5)
                          : sel
                          ? Colors.white
                          : isToday
                          ? goldDark
                          : text,
                      fontWeight: (sel || isToday)
                          ? FontWeight.bold
                          : FontWeight.normal,
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

  Widget _times() {
    final slots = (_docs.firstWhere((d) => d['n'] == _doc)['a'] as List)
        .cast<String>();
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: slots.map((t) {
        final sel =
            _tim != null &&
            '${_tim!.hour.toString().padLeft(2, '0')}:${_tim!.minute.toString().padLeft(2, '0')}' ==
                t;
        return GestureDetector(
          onTap: () => setState(
            () => _tim = TimeOfDay(
              hour: int.parse(t.split(':')[0]),
              minute: int.parse(t.split(':')[1]),
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: sel ? goldPrimary : card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: sel ? goldLight : border),
            ),
            child: Text(
              _fmt(t),
              style: TextStyle(
                color: sel ? Colors.white : text,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _progressBar() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: border),
    ),
    child: Row(
      children: List.generate(7, (i) {
        if (i.isOdd)
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              height: 3,
              color: _step > i ~/ 2 + 1 ? goldPrimary : border,
            ),
          );
        int n = i ~/ 2 + 1;
        bool done = _step > n, active = _step == n;
        return Expanded(
          flex: 2,
          child: Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: done
                    ? success
                    : active
                    ? goldPrimary
                    : surface,
                child: done
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : Text(
                        '$n',
                        style: TextStyle(
                          color: active ? Colors.white : textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                ['Service', 'Doctor', 'Date', 'Time'][n - 1],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: done
                      ? success
                      : active
                      ? goldPrimary
                      : textMuted,
                ),
              ),
            ],
          ),
        );
      }),
    ),
  );

  void _confirm() => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'Confirm Booking',
        style: TextStyle(color: text, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _summaryRow(Icons.medical_services, 'Service', _srv!),
          _summaryRow(Icons.person, 'Doctor', _doc!),
          _summaryRow(
            Icons.calendar_today,
            'Date',
            '${_dat!.day}/${_dat!.month}/${_dat!.year}',
          ),
          _summaryRow(
            Icons.access_time,
            'Time',
            _fmt(
              '${_tim!.hour.toString().padLeft(2, '0')}:${_tim!.minute.toString().padLeft(2, '0')}',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Edit', style: TextStyle(color: textMuted)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onBookAppointment({
              'service': _srv!,
              'doctor': _doc!,
              'date': _dat!,
              'time':
                  '${_tim!.hour.toString().padLeft(2, '0')}:${_tim!.minute.toString().padLeft(2, '0')}',
              'status': 'upcoming',
            });
            setState(() {
              _srv = _doc = _dat = _tim = null;
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: goldDark),
          child: const Text('Confirm', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  Widget _summaryRow(IconData i, String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(i, color: goldDark, size: 18),
        const SizedBox(width: 10),
        Text(
          '$l: ',
          style: TextStyle(color: textMuted, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(v, style: TextStyle(color: text)),
        ),
      ],
    ),
  );

  String _fmt(String t) {
    final c = t.split(':'), h = int.parse(c[0]), m = int.parse(c[1]);
    return '${h > 12
        ? h - 12
        : h == 0
        ? 12
        : h}:${m.toString().padLeft(2, '0')} ${h >= 12 ? 'PM' : 'AM'}';
  }
}
