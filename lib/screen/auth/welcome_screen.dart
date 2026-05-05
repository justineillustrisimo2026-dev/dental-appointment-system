import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ──  PALETTE ──
  static const Color _cardWhite = Color(0xFFFFFFFF);
  static const Color _goldDeep = Color(0xFFB88A44);
  static const Color _goldMid = Color(0xFFD4AF37);
  static const Color _goldShine = Color(0xFFF0D86C);
  static const Color _goldPrimary = Color(0xFFB59410);
  static const Color _textMuted = Color(0xFF8A7A5A);

  // Exact 4-step gradient matching the Login Button
  LinearGradient get goldGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_goldDeep, _goldMid, _goldShine, _goldMid],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  @override
  void initState() {
    super.initState();
    // ── ENTRANCE ANIMATION ──
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animCtrl,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double logoSize = 160.0;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── PERFECTED MULTI-LAYERED GRADIENT CURVES ──
          Positioned.fill(
            child: CustomPaint(painter: PerfectGoldPainter(goldGradient)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 44.0, // Keep padding consistent with logo/title
                vertical: 24.0,
              ),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // ── LOGO IN CIRCLE ──
                      Container(
                        width: logoSize,
                        height: logoSize,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: _cardWhite,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _goldMid.withOpacity(0.5),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _goldDeep.withOpacity(0.25),
                              blurRadius: 35,
                              spreadRadius: 4,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/clinic_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // ── TITLES ──
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            goldGradient.createShader(bounds),
                        child: Text(
                          'SMILE ART',
                          style: GoogleFonts.cinzel(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'DENTAL CLINIC',
                        style: GoogleFonts.dmSans(
                          color: _textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 6,
                        ),
                      ),

                      const SizedBox(height: 50),

                      // ── LOG IN BUTTON
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 64, // Increased height to match
                          decoration: BoxDecoration(
                            gradient: goldGradient,
                            borderRadius: BorderRadius.circular(
                              35,
                            ), // Fully rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: _goldDeep.withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Log In',
                                style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 17, // Increased font size
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── REGISTER BUTTON  ──
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 64, // Increased height
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              35,
                            ), // Fully rounded corners
                            border: Border.all(
                              color: _goldPrimary.withOpacity(0.6),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _goldDeep.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Register',
                              style: GoogleFonts.dmSans(
                                color: _goldPrimary,
                                fontSize: 17, // Increased font size
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── PERFECTED GOLD PAINTER ──
class PerfectGoldPainter extends CustomPainter {
  final LinearGradient gradient;
  PerfectGoldPainter(this.gradient);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect fullRect = Offset.zero & size;

    // Solid Front Paint
    final Paint frontPaint = Paint()
      ..shader = gradient.createShader(fullRect)
      ..style = PaintingStyle.fill;

    // Translucent Back Paint for depth
    final Paint backPaint = Paint()
      ..shader = gradient.createShader(fullRect)
      ..style = PaintingStyle.fill
      ..colorFilter = ColorFilter.mode(
        Colors.white.withOpacity(0.6),
        BlendMode.modulate,
      );

    // ── TOP RIGHT: LAYERED CURVES ──
    // 1. Top Back Curve
    final Path topBack = Path()
      ..moveTo(size.width * 0.35, 0)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.22,
        size.width * 0.85,
        size.height * 0.05,
        size.width,
        size.height * 0.2,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(topBack, backPaint);

    // 2. Top Front Curve (Matches Button)
    final Path topFront = Path()
      ..moveTo(size.width * 0.5, 0)
      ..cubicTo(
        size.width * 0.65,
        size.height * 0.15,
        size.width * 0.9,
        0,
        size.width,
        size.height * 0.1,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(topFront, frontPaint);

    // ── BOTTOM LEFT: MIRRORED LAYERED CURVES ──
    // 1. Bottom Back Curve (180-degree reflection of Top Back)
    final Path bottomBack = Path()
      ..moveTo(size.width * 0.65, size.height)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.78,
        size.width * 0.15,
        size.height * 0.95,
        0,
        size.height * 0.8,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(bottomBack, backPaint);

    // 2. Bottom Front Curve (180-degree reflection of Top Front)
    final Path bottomFront = Path()
      ..moveTo(size.width * 0.5, size.height)
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.85,
        size.width * 0.1,
        size.height,
        0,
        size.height * 0.9,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(bottomFront, frontPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
