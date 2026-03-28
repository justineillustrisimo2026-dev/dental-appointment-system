import 'package:flutter/material.dart';

class AboutClinicScreen extends StatefulWidget {
  final bool isDarkMode;

  const AboutClinicScreen({super.key, this.isDarkMode = false});

  @override
  State<AboutClinicScreen> createState() => _AboutClinicScreenState();
}

class _AboutClinicScreenState extends State<AboutClinicScreen> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(AboutClinicScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      setState(() => isDark = widget.isDarkMode);
    }
  }

  // ── ✨ LUXURY GOLD THEME COLORS ──
  final Color goldPrimary = const Color(0xFFD4AF37);
  final Color goldDark = const Color(0xFFA67C00);
  final Color goldLight = const Color(0xFFF9E4B7);

  Color get bg => isDark ? const Color(0xFF0F172A) : Colors.white;
  Color get cardColor =>
      isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
  Color get textColor => isDark ? Colors.white : const Color(0xFF1E293B);
  Color get textMutedColor =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get borderColor =>
      isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: goldDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About Clinic',
          style: TextStyle(color: textColor, fontWeight: FontWeight.w900),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 60),
        child: Column(
          children: [
            // ── 🏆 PREMIUM HERO BANNER (White Badge & Centered Gold Logo) ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [goldPrimary, goldDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: goldDark.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ✨ PREMIUM WHITE BADGE ✨
                  Container(
                    width: 110,
                    height: 110,
                    // Padding creates the "frame" around your logo
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/clinic_logo.png', // Ensure this is a transparent PNG
                      fit: BoxFit.contain, // Fits perfectly within the padding
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.medical_services_rounded,
                        color: Color(0xFFA67C00),
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'DENTAL • ORTHO • COSMETIC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // ── 📄 CLINIC OVERVIEW ──
            _sectionHeader('About Us'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor),
              ),
              child: Text(
                'Smile Art Dental Clinic is dedicated to quality dental care with modern technology, personalized treatment plans, and compassionate patient service. We believe every patient deserves a masterpiece smile.',
                style: TextStyle(
                  color: textMutedColor,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── 📍 CONTACT DETAILS ──
            _sectionHeader('Contact Information'),
            const SizedBox(height: 12),
            _infoCard(
              Icons.location_on_rounded,
              'Visit Us',
              'LG, Gaisano Grandmall, Liloan, Philippines',
            ),
            const SizedBox(height: 12),
            _infoCard(Icons.phone_rounded, 'Call Us', '0960 434 9004'),
            const SizedBox(height: 12),
            _infoCard(
              Icons.email_rounded,
              'Email Us',
              'smileart.dentalavenue@gmail.com',
            ),

            const SizedBox(height: 32),

            // ── ⏰ OPERATING HOURS ──
            _sectionHeader('Operating Hours'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: goldPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: goldLight.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Open Daily (Mon-Sun)',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: goldPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '10:00 AM - 7:00 PM',
                      style: TextStyle(
                        color: goldDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── 👨‍⚕️ SPECIALISTS ──
            _sectionHeader('Meet Our Specialists'),
            const SizedBox(height: 12),
            _docCard('Dr. Justine Illustrisimo', 'Lead Orthodontist'),
            _docCard('Dr. Sarah Smith', 'General Dentist'),
            _docCard('Dr. Michael Chen', 'Oral Surgeon'),
            _docCard('Dr. Maria Santos', 'Prosthodontist'),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── HELPER WIDGETS ──
  Widget _sectionHeader(String title) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
      ),
    ),
  );

  Widget _infoCard(IconData icon, String title, String desc) => Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: borderColor),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: goldPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: goldDark, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  color: textMutedColor,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _docCard(String n, String s) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: borderColor),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: goldPrimary.withOpacity(0.1),
          child: Text(
            n.split(' ').last[0],
            style: TextStyle(
              color: goldDark,
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
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(s, style: TextStyle(color: textMutedColor, fontSize: 13)),
            ],
          ),
        ),
        Icon(Icons.stars_rounded, color: goldPrimary, size: 20),
      ],
    ),
  );
}
