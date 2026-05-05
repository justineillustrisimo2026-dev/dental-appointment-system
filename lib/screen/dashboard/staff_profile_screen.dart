import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class StaffProfileScreen extends StatelessWidget {
  final Map<String, String> staff;
  final bool isDarkMode;

  const StaffProfileScreen({
    super.key,
    required this.staff,
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
    return Theme(
      data: ThemeData(brightness: isDark ? Brightness.dark : Brightness.light),
      child: Scaffold(
        backgroundColor: bg,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── PREMIUM COLLAPSING HEADER (Exact Match to Dentist) ──
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
                      staff['img']!,
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
                    // ── NAME & ROLE (Exact Match to Dentist Name/Spec) ──
                    Text(
                      staff['name']!,
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
                        staff['role']!, // Shows "Front Desk" or "Assistant"
                        style: GoogleFonts.dmSans(
                          color: _goldPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
