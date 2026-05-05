// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class DentistProfileScreen extends StatelessWidget {
  final Map<String, String> dentist;
  final bool isDarkMode;

  const DentistProfileScreen({
    super.key,
    required this.dentist,
    required this.isDarkMode,
  });

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
  Color get txt => isDark ? _inputCream : _textDark;
  Color get txtMuted => isDark ? const Color(0xFFA6967A) : _textMuted;
  Color get bdr =>
      // ignore: deprecated_member_use
      isDark ? const Color(0xFF403626) : _goldMid.withOpacity(0.20);

  bool get isDark => isDarkMode;

  LinearGradient get goldGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_goldDeep, _goldMid, _goldShine, _goldMid],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    // ── HARDCODED SERVICES LISTS ──
    final List<String> krischelleServices = [
      'Consultation',
      'Panoramic X-ray',
      'Tooth Extraction',
      'Cleaning',
      'Dental Filling',
      'Braces Installation',
      'Braces Adjustment',
      'Root Canal',
      'Teeth Bleaching',
      'Wisdom Tooth',
      'Dentures',
      'Dental Crown',
      'Dental Bridge',
    ];

    final List<String> clydeServices = [
      'Consultation',
      'Panoramic X-ray',
      'Tooth Extraction',
      'Cleaning',
      'Dental Filling',
      'Teeth Bleaching',
      'Dentures',
      'Dental Crown',
      'Dental Bridge',
    ];

    // Check the name to decide which list to display
    final bool isKrischelle = dentist['name']!.contains('Krischelle');
    final List<String> activeServices = isKrischelle
        ? krischelleServices
        : clydeServices;

    return Theme(
      data: ThemeData(brightness: isDark ? Brightness.dark : Brightness.light),
      child: Scaffold(
        backgroundColor: bg,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── PREMIUM COLLAPSING HEADER ──
            SliverAppBar(
              expandedHeight: 420.0,
              pinned: true,
              stretch: true,
              backgroundColor: bg,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(gradient: goldGradient),
                    ),
                    Image.asset(
                      dentist['img']!,
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.bottomCenter,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.white54,
                              size: 80,
                            ),
                          ),
                    ),
                    Positioned(
                      bottom: -2,
                      left: 0,
                      right: 0,
                      height: 80,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [bg.withOpacity(0.0), bg],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── PROFILE CONTENT ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── NAME & SPECIALTY ──
                    Text(
                      dentist['name']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        color: txt,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _goldPrimary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _goldPrimary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        dentist['spec']!,
                        style: GoogleFonts.dmSans(
                          color: _goldPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // ── EDITORIAL ABOUT SECTION ──
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: bdr),
                        boxShadow: [
                          BoxShadow(
                            color: _goldDeep.withOpacity(0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.format_quote_rounded,
                            color: _goldPrimary.withOpacity(0.4),
                            size: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dentist['desc'] ?? '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              color: txt,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.7,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── ORGANIZED 2-COLUMN SERVICES GRID ──
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _secTitle('Expertise & Services'),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap:
                          true, // Crucial for using GridView inside a ScrollView
                      physics:
                          const NeverScrollableScrollPhysics(), // Disables inner scrolling
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 Perfectly aligned columns
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio:
                                2.8, // Adjusts the height of the boxes
                          ),
                      itemCount: activeServices.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _goldMid.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _goldDeep.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: _goldPrimary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.star_rounded,
                                  color: _goldPrimary,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                // Ensures text wraps cleanly inside the box
                                child: Text(
                                  activeServices[index],
                                  style: GoogleFonts.dmSans(
                                    color: txt,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
