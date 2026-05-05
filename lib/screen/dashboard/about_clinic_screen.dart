import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // ── REPLACED WEBVIEW WITH THIS ──

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

  // ── EXACT PALETTE & SHADOWS ──
  static const Color _cardWhite = Color(0xFFFFFFFF);
  static const Color _inputCream = Color(0xFFFAF6EE);
  static const Color _goldDeep = Color(0xFFB88A44);
  static const Color _goldMid = Color(0xFFD4AF37);
  static const Color _goldShine = Color(0xFFF0D86C);
  static const Color _goldPrimary = Color(0xFFB59410);
  static const Color _textDark = Color(0xFF2C2410);
  static const Color _textMuted = Color(0xFF8A7A5A);

  Color get bg => isDark ? const Color(0xFF1A160F) : const Color(0xFFF9F9F9);
  Color get cardBg => isDark ? const Color(0xFF262016) : _cardWhite;
  Color get innerSurface => isDark ? const Color(0xFF332B1E) : _inputCream;
  Color get ink => isDark ? _inputCream : _textDark;
  Color get inkMuted => isDark ? const Color(0xFFA6967A) : _textMuted;
  Color get bdr =>
      isDark ? const Color(0xFF403626) : _goldMid.withOpacity(0.20);

  LinearGradient get goldGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_goldDeep, _goldMid, _goldShine, _goldMid],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  List<BoxShadow> get profileShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];

  // ── GOOGLE MAPS LAUNCHER FUNCTION ──
  Future<void> _openGoogleMaps() async {
    // This URL searches for your exact location
    final Uri mapUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=Gaisano+Grand+Mall+Liloan+Cebu',
    );

    // Launch Mode externalApplication forces it to open the Maps App or Browser
    if (!await launchUrl(mapUrl, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch map');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _goldPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About Clinic',
          style: GoogleFonts.dmSans(
            color: ink,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 🏆 PREMIUM HERO BANNER ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: goldGradient,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: _goldDeep.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 110,
                    height: 110,
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
                      'assets/clinic_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.medical_services_rounded,
                        color: _goldPrimary,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'SMILE ART',
                    style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  Text(
                    'DENTAL CLINIC',
                    style: GoogleFonts.dmSans(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // ── CLINIC OVERVIEW ──
            _sectionHeader('About Us'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: bdr),
                boxShadow: profileShadow,
              ),
              child: Text(
                'Smile Art Dental Clinic is dedicated to quality dental care with modern technology, personalized treatment plans, and compassionate patient service. We believe every patient deserves a masterpiece smile.',
                style: GoogleFonts.dmSans(
                  color: inkMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── CONTACT DETAILS ──
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

            // ── CLICKABLE MAP BUTTON ──
            _sectionHeader('Our Location'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _openGoogleMaps, // Opens the map when clicked!
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: innerSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: bdr),
                  boxShadow: profileShadow,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _goldPrimary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.map_rounded,
                        color: _goldPrimary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Open in Google Maps',
                      style: GoogleFonts.dmSans(
                        color: ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap here to view directions to\nGaisano Grand Mall, Liloan',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        color: inkMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── HELPER WIDGETS ──
  Widget _sectionHeader(String title) => Row(
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
          fontWeight: FontWeight.w900,
          fontSize: 17,
          color: ink,
        ),
      ),
    ],
  );

  Widget _infoCard(IconData icon, String title, String desc) => Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: bdr),
      boxShadow: profileShadow,
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: innerSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: _goldPrimary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.dmSans(
                  color: ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.dmSans(
                  color: inkMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
