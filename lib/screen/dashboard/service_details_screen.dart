import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> service;
  final bool isDarkMode;

  const ServiceDetailsScreen({
    super.key,
    required this.service,
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
    // Extracting the new extended data (falling back to empty lists if null)
    final List<String> beforeCare = service['before'] ?? [];
    final List<String> afterCare = service['after'] ?? [];
    final List<String> warnings = service['warnings'] ?? [];

    return Theme(
      data: ThemeData(brightness: isDark ? Brightness.dark : Brightness.light),
      child: Scaffold(
        backgroundColor: bg,
        // ── STICKY BOOKING BUTTON AT THE BOTTOM ──
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: BoxDecoration(
            color: bg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
                blurRadius: 20,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              // Pop this screen and pass the service ID back to the dashboard!
              Navigator.pop(context, service['id']);
            },
            child: Container(
              width: double.infinity,
              height: 64, // Increased height for better tap target
              decoration: BoxDecoration(
                gradient: goldGradient,
                borderRadius: BorderRadius.circular(35), // Rounded pill shape
                boxShadow: [
                  BoxShadow(
                    color: _goldDeep.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Book This Procedure',
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 17, // Increased text size
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── PREMIUM COLLAPSING HEADER ──
            SliverAppBar(
              expandedHeight: 350.0,
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
                      color: Colors.black.withOpacity(0.4),
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
                    Image.asset(
                      service['img'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: innerSurface,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: Colors.grey,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      left: 0,
                      right: 0,
                      height: 100,
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

            // ── DETAILS CONTENT ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── TITLE, PRICE & DURATION ──
                    Text(
                      service['n'] as String,
                      style: GoogleFonts.dmSans(
                        color: txt,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _goldPrimary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _goldPrimary.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            service['p'] as String,
                            style: GoogleFonts.dmSans(
                              color: _goldPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 18,
                              color: txtMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              service['dur'] as String,
                              style: GoogleFonts.dmSans(
                                color: txtMuted,
                                fontSize: 15, // Slightly larger
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ── ABOUT PROCEDURE ──
                    _secTitle('About this Procedure'),
                    const SizedBox(height: 16),
                    Text(
                      service['desc'] as String,
                      style: GoogleFonts.dmSans(
                        color: txt.withOpacity(
                          0.85,
                        ), // Changed from muted to standard text for better readability
                        fontSize: 16, // Increased from 15
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── PREPARATION (BEFORE) ──
                    if (beforeCare.isNotEmpty) ...[
                      _infoCard(
                        title: 'How to Prepare (Before)',
                        items: beforeCare,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── AFTERCARE (AFTER) ──
                    if (afterCare.isNotEmpty) ...[
                      _infoCard(
                        title: 'Aftercare (What to do after)',
                        items: afterCare,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── CONTRAINDICATIONS (WARNINGS) ──
                    if (warnings.isNotEmpty) ...[
                      _infoCard(
                        title: 'When we cannot perform this',
                        items: warnings,
                        isWarning: true,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated Info Card: No icons, uses a vertical line, and larger text
  Widget _infoCard({
    required String title,
    required List<String> items,
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isWarning ? Colors.redAccent.withOpacity(0.05) : cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isWarning ? Colors.redAccent.withOpacity(0.3) : bdr,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── VERTICAL LINE INSTEAD OF ICON ──
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: isWarning ? null : goldGradient,
                  color: isWarning ? Colors.redAccent : null,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.dmSans(
                    color: isWarning ? Colors.redAccent.shade400 : txt,
                    fontSize: 18, // Increased from 16
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isWarning ? Colors.redAccent : _goldPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.dmSans(
                        color: txt.withOpacity(0.85), // Increased readability
                        fontSize: 16, // Increased from 14
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Section Title with vertical gold line
  Widget _secTitle(String t) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 4,
        height: 20, // Matched height with InfoCards
        decoration: BoxDecoration(
          gradient: goldGradient,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        t,
        style: GoogleFonts.dmSans(
          color: txt,
          fontSize: 20, // Increased from 18
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  );
}
