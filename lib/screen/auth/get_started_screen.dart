import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ── IMPORT YOUR WELCOME SCREEN HERE ──
import 'package:dentalclinicsystem/screen/auth/welcome_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── EXACT PREMIUM GOLD PALETTE ──
  static const Color _goldDeep = Color(0xFFB88A44);
  static const Color _goldMid = Color(0xFFD4AF37);
  static const Color _goldShine = Color(0xFFF0D86C);
  static const Color _goldPrimary = Color(0xFFB59410);

  // ── PURE WHITE BACKGROUND & DARK TEXT ──
  static const Color _bgWhite = Colors.white;
  static const Color _textDark = Color(0xFF2C2410);

  // Exact 4-step gradient matching the Login Screen curves and button
  LinearGradient get goldGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_goldDeep, _goldMid, _goldShine, _goldMid],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  // Solid gold/yellow for the circle behind the doctor
  static const Color _solidCircleGold = Color(0xFFD6B24A);

  @override
  void initState() {
    super.initState();
    // ── SMOOTH ENTRANCE ANIMATION ──
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: _bgWhite,
      body: Stack(
        children: [
          // ── CURVES ──
          Positioned.fill(
            child: CustomPaint(painter: PerfectGoldPainter(goldGradient)),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── FIXED SPACING: Forcing the text completely below the top curves ──
                const SizedBox(height: 125),

                // ── HEADER TEXT ──
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      children: [
                        Text(
                          'SMILE ART',
                          style: GoogleFonts.dmSans(
                            color: _goldPrimary,
                            fontSize: 14,
                            letterSpacing: 4.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Masterpiece\nSmile Begins Here.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            color: _textDark,
                            fontSize: 34,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(
                  flex: 1,
                ), // Reduced spacer so the image fits nicely below
                // ── CIRCULAR IMAGE WITH POP-OUT HEAD ──
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SizedBox(
                      height: 320, // Taller container to allow head pop-out
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          // 1. The Solid Gold Circle
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 300,
                              height: 300,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    _solidCircleGold, // Solid color from your image
                              ),
                            ),
                          ),
                          // 2. The Doctor Image (Bottom aligned, popping out the top)
                          Positioned(
                            bottom: 0,
                            child: Image.asset(
                              'assets/krischelle.png',
                              height: 370, // Taller than the circle
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // ── LETS GET STARTED BUTTON ──
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 55.0),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();

                          // ── FULLY FUNCTIONAL NAVIGATION ──
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const WelcomeScreen(),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: goldGradient,
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: _goldDeep.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Let's Get Started",
                                style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 150), // Bottom padding safeguard
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── PERFECTED GOLD PAINTER (Exact copy from your Login Screen) ──
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

    // 2. Top Front Curve
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
    // 1. Bottom Back Curve
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

    // 2. Bottom Front Curve
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
