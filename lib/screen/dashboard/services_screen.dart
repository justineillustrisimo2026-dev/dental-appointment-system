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

  final _services = [
    {
      'n': 'Consultation',
      'i': Icons.chat_rounded,
      'p': '₱500',
      'dur': '30 mins',
      'desc': 'Initial dental examination and consultation with your dentist',
    },
    {
      'n': 'Panoramic X-Ray',
      'i': Icons.radar_rounded,
      'p': '₱1,000',
      'dur': '15 mins',
      'desc': 'Comprehensive panoramic view of your entire dental structure',
    },
    {
      'n': 'Oral Prophylaxis',
      'i': Icons.cleaning_services_rounded,
      'p': '₱850–1,200',
      'dur': '45 mins',
      'desc': 'Professional teeth cleaning to remove tartar and plaque buildup',
    },
    {
      'n': 'Braces',
      'i': Icons.medical_services_rounded,
      'p': '₱5K+',
      'dur': 'Multiple sessions',
      'desc': 'Orthodontic treatment for teeth alignment and correction',
    },
    {
      'n': 'Tooth Extraction',
      'i': Icons.healing_rounded,
      'p': '₱850–1,200',
      'dur': '30-45 mins',
      'desc': 'Safe removal of damaged or decayed teeth',
    },
    {
      'n': 'Wisdom Tooth',
      'i': Icons.medical_services_rounded,
      'p': '₱8K–13K',
      'dur': '45-60 mins',
      'desc': 'Specialized extraction of impacted wisdom teeth',
    },
    {
      'n': 'Dental Filling',
      'i': Icons.build_rounded,
      'p': '₱850–1,200',
      'dur': '30 mins',
      'desc': 'Restoration of cavities with tooth-colored composite material',
    },
    {
      'n': 'Root Canal',
      'i': Icons.psychology_rounded,
      'p': '₱8,000',
      'dur': '60-90 mins',
      'desc': 'Treatment to save an infected or damaged tooth nerve',
    },
    {
      'n': 'Dentures',
      'i': Icons.face_rounded,
      'p': 'From ₱1K',
      'dur': 'Multiple sittings',
      'desc': 'Custom-made artificial teeth replacement solutions',
    },
    {
      'n': 'Dental Bridges',
      'i': Icons.medical_services_rounded,
      'p': '₱1,000',
      'dur': 'Multiple sittings',
      'desc': 'Fixed prosthetic solution to replace missing teeth',
    },
    {
      'n': 'Dental Crown',
      'i': Icons.workspace_premium_rounded,
      'p': '₱1,000',
      'dur': 'Multiple sittings',
      'desc': 'Protective cap to restore tooth strength and appearance',
    },
    {
      'n': 'Teeth Whitening',
      'i': Icons.color_lens_rounded,
      'p': '₱3K/sess.',
      'dur': '60 mins',
      'desc': 'Professional teeth bleaching for a brighter, whiter smile',
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
    {
      'n': 'Dr. Maria Santos',
      's': 'Prosthodontist',
      'h': 'Mon/Wed/Fri 9–5',
      'a': ['09:00', '11:00', '13:00', '15:00', '16:00'],
    },
  ];

  // Smart Progress Bar tracking
  int get _step {
    if (_srv != null && _doc != null && _dat != null && _tim != null) return 5;
    if (_srv != null && _doc != null && _dat != null) return 4;
    if (_srv != null && _doc != null) return 3;
    if (_srv != null || _doc != null) return 2;
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
          const SizedBox(height: 24),

          _pad(_title('Our Services', 'Swipe to select a dental service')),
          const SizedBox(height: 12),
          _servicesSwiper(),

          if (_srv != null) ...[_pad(_badge(Icons.medical_services, _srv!))],

          // DOCTORS NOW VISIBLE IMMEDIATELY
          const SizedBox(height: 24),
          _pad(_title('Your Doctor', 'Pick your preferred dentist')),
          const SizedBox(height: 14),
          ..._docs.map((d) => _pad(_docCard(d))),

          // CALENDAR ONLY SHOWS WHEN BOTH ARE SELECTED
          if (_srv != null && _doc != null) ...[
            _pad(_badge(Icons.person, _doc!)),
            const SizedBox(height: 24),
            _pad(_title('Appointment Date', 'Choose a date')),
            const SizedBox(height: 14),
            _pad(_cal()),
          ],

          if (_srv != null && _doc != null && _dat != null) ...[
            _pad(
              _badge(
                Icons.calendar_today,
                '${_dat!.day}/${_dat!.month}/${_dat!.year}',
              ),
            ),
            const SizedBox(height: 24),
            _pad(_title('Available Times', 'Pick a time slot')),
            const SizedBox(height: 14),
            _pad(_times()),
          ],

          if (_srv != null && _doc != null && _dat != null && _tim != null) ...[
            _pad(
              _badge(
                Icons.access_time,
                _fmt(
                  '${_tim!.hour.toString().padLeft(2, '0')}:${_tim!.minute.toString().padLeft(2, '0')}',
                ),
              ),
            ),
            const SizedBox(height: 28),
            _pad(
              ElevatedButton(
                onPressed: _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

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
          // Important fix: Doesn't wipe out "Doctor" selection if you just change your mind on a "Service"
          onTap: () => setState(() {
            _srv = s['n'] as String;
            _dat = _tim = null;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 12),
            width: 115,
            decoration: BoxDecoration(
              color: sel ? primary : card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: sel ? accent : border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  s['i'] as IconData,
                  color: sel ? Colors.white : primary,
                  size: 30,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    s['n'] as String,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: sel ? Colors.white : text,
                      height: 1.15,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s['p'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: sel ? Colors.white70 : textMuted,
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

  Widget _progressBar() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
              decoration: BoxDecoration(
                color: _step > i ~/ 2 + 1 ? success : border,
                borderRadius: BorderRadius.circular(2),
              ),
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
                    ? primary
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
                      ? primary
                      : textMuted,
                ),
              ),
            ],
          ),
        );
      }),
    ),
  );

  Widget _title(String t, String s) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        t,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: text,
        ),
      ),
      const SizedBox(height: 2),
      Text(s, style: TextStyle(fontSize: 12, color: textMuted)),
    ],
  );

  Widget _badge(IconData i, String l) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: success.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: success.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: success, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              l,
              style: TextStyle(
                color: success,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _docCard(Map d) {
    final sel = _doc == d['n'];
    return GestureDetector(
      // Important fix: Doesn't wipe out "Service" selection if you just change your mind on a "Doctor"
      onTap: () => setState(() {
        _doc = d['n'];
        _dat = _tim = null;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: sel ? primary : card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sel ? accent : border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: sel ? Colors.white24 : primary.withOpacity(0.1),
              child: Text(
                (d['n'] as String)[4],
                style: TextStyle(
                  color: sel ? Colors.white : primary,
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
              icon: Icon(Icons.chevron_left, color: primary),
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
              icon: Icon(Icons.chevron_right, color: primary),
              onPressed: () =>
                  setState(() => _m = DateTime(_m.year, _m.month + 1)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map(
                (d) => Text(
                  d,
                  style: TextStyle(
                    color: textMuted,
                    fontWeight: FontWeight.bold,
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
            final isPast = date.isBefore(
              DateTime(now.year, now.month, now.day),
            );
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
                  color: isPast
                      ? surface.withOpacity(0.5)
                      : sel
                      ? primary
                      : isToday
                      ? primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
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
                          ? primary
                          : text,
                      fontWeight: (sel || isToday) && !isPast
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
              color: sel ? primary : card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: sel ? accent : border),
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

  void _book() {
    // Validate that the selected date is not in the past
    final now = DateTime.now();
    final selectedDate = DateTime(_dat!.year, _dat!.month, _dat!.day);
    final today = DateTime(now.year, now.month, now.day);

    if (selectedDate.isBefore(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Cannot book appointments for past dates',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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
      _m = DateTime.now();
    });
    Navigator.pop(context);
  }

  void _confirm() => showDialog(
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
              backgroundColor: primary.withOpacity(0.1),
              child: Icon(Icons.event_available, color: primary, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              'Confirm Booking',
              style: TextStyle(
                color: text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 30),
            _row(Icons.medical_services, 'Service', _srv!),
            _row(Icons.person, 'Doctor', _doc!),
            _row(
              Icons.calendar_today,
              'Date',
              '${_dat!.day}/${_dat!.month}/${_dat!.year}',
            ),
            _row(
              Icons.access_time,
              'Time',
              _fmt(
                '${_tim!.hour.toString().padLeft(2, '0')}:${_tim!.minute.toString().padLeft(2, '0')}',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(color: textMuted)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _book,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Confirm',
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

  Widget _row(IconData i, String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(i, color: primary, size: 18),
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
