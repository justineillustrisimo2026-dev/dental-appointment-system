import 'package:flutter/material.dart';

class AboutClinicScreen extends StatelessWidget {
  const AboutClinicScreen({super.key});

  // ── ☀️ DYNAMIC THEMED (Matches Dashboard Automatically) ──
  bool isDark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;

  // ── PREMIUM SLATE BLUE DARK MODE ──
  Color bg(BuildContext c) =>
      isDark(c) ? const Color(0xFF0F172A) : const Color(0xFFF4F6F9);
  Color card(BuildContext c) =>
      isDark(c) ? const Color(0xFF1E293B) : Colors.white;
  Color surface(BuildContext c) =>
      isDark(c) ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  Color text(BuildContext c) =>
      isDark(c) ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
  Color textMuted(BuildContext c) =>
      isDark(c) ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color border(BuildContext c) =>
      isDark(c) ? const Color(0xFF475569) : const Color(0xFFE2E8F0);

  Color get primary => const Color(0xFF4A6CF7);
  Color get accent => const Color(0xFF00D4FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      appBar: AppBar(
        backgroundColor: bg(context),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: text(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About Clinic',
          style: TextStyle(color: text(context), fontWeight: FontWeight.w900),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: 60,
        ),
        child: Column(
          children: [
            // ── HERO BANNER ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🦷', style: TextStyle(fontSize: 44)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SMILE ART',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text(
                    'DENTAL CLINIC',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'DENTAL X ORTHO X COSMETIC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // ── EXACT CLINIC DETAILS ──
            _infoCard(
              context,
              Icons.location_on_rounded,
              'Visit Us',
              'LG, Gaisano Grandmall,\nLiloan, Philippines',
            ),
            const SizedBox(height: 16),
            _infoCard(context, Icons.phone_rounded, 'Call Us', '0960 434 9004'),
            const SizedBox(height: 16),
            _infoCard(
              context,
              Icons.email_rounded,
              'Email Us',
              'smileart.dentalavenue@gmail.com',
            ),
            const SizedBox(height: 36),

            // ── EXACT CLINIC HOURS ──
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Operating Hours',
                style: TextStyle(
                  color: text(context),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: card(context),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: border(context)),
              ),
              child: Column(
                children: [
                  _hourRow(
                    context,
                    'Open Daily (Mon-Sun)',
                    '10:00 AM - 7:00 PM',
                    true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // ── OUR TEAM ──
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Meet Our Specialists',
                style: TextStyle(
                  color: text(context),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _docCard(context, 'Dr. Justine Illustrisimo', 'Lead Orthodontist'),
            _docCard(context, 'Dr. Sarah Smith', 'General Dentist'),
            _docCard(context, 'Dr. Michael Chen', 'Oral Surgeon'),
            _docCard(context, 'Dr. Maria Santos', 'Prosthodontist'),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── HELPER WIDGETS ──
  Widget _infoCard(BuildContext c, IconData icon, String title, String desc) =>
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: card(c),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border(c)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: text(c),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      color: textMuted(c),
                      fontSize: 13,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _hourRow(BuildContext c, String day, String time, bool open) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        day,
        style: TextStyle(
          color: text(c),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: open
              ? primary.withOpacity(0.1)
              : const Color(0xFFEF4444).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: open ? primary : const Color(0xFFEF4444),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    ],
  );

  Widget _docCard(BuildContext c, String n, String s) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: card(c),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: border(c)),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: primary.withOpacity(0.15),
          child: Text(
            n[4],
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                n,
                style: TextStyle(
                  color: text(c),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                s,
                style: TextStyle(
                  color: textMuted(c),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
