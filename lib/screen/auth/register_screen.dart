// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  // ── ADDED MIXIN FOR ANIMATION ──

  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  final c4 = TextEditingController();
  final c5 = TextEditingController();
  bool isLoading = false, obscure = true;
  bool _f1 = false, _f2 = false, _f3 = false, _f4 = false, _f5 = false;

  // ── ANIMATION VARIABLES ──
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const Color _cardWhite = Color(0xFFFFFFFF);
  static const Color _inputCream = Color(0xFFFAF6EE);
  static const Color _goldDeep = Color(0xFFB88A44);
  static const Color _goldMid = Color(0xFFD4AF37);
  static const Color _goldShine = Color(0xFFF0D86C);
  static const Color _goldPrimary = Color(0xFFB59410);
  static const Color _textDark = Color(0xFF2C2410);
  static const Color _textMuted = Color(0xFF8A7A5A);

  // Exact 4-step gradient matching the Welcome & Login Screens
  LinearGradient get goldGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_goldDeep, _goldMid, _goldShine, _goldMid],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  @override
  void initState() {
    super.initState();
    // ── SMOOTH ENTRANCE ANIMATION SETUP ──
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
    _animCtrl.dispose(); // Dispose animation
    c1.dispose();
    c2.dispose();
    c3.dispose();
    c4.dispose();
    c5.dispose();
    super.dispose();
  }

  void _register() {
    if (c1.text.isEmpty ||
        c2.text.isEmpty ||
        c3.text.isEmpty ||
        c4.text.isEmpty ||
        c5.text.isEmpty) {
      _showMsg('Please fill all fields', Colors.redAccent.shade200);
      return;
    }
    if (c5.text.length != 11) {
      _showMsg('Contact must be 11 digits', Colors.redAccent.shade200);
      return;
    }
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(
            registeredFirstName: c1.text,
            registeredLastName: c2.text,
            registeredUsername: c3.text,
            registeredContact: c5.text,
          ),
        ),
      );
    });
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── PERFECTED MULTI-LAYERED GRADIENT CURVES ──
          Positioned.fill(
            child: CustomPaint(painter: PerfectGoldPainter(goldGradient)),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 20,
                ),
                // ── APPLIED ANIMATION TO THE ENTIRE COLUMN ──
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      children: [
                        // ── LOGO ──
                        Container(
                          width: 90,
                          height: 90,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _cardWhite,
                            border: Border.all(
                              color: _goldMid.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _goldDeep.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/clinic_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [_goldDeep, _goldMid, _goldShine, _goldMid],
                          ).createShader(bounds),
                          child: Text(
                            'SMILE ART',
                            style: GoogleFonts.cinzel(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── MINIMAL REGISTER CARD ──
                        Container(
                          decoration: BoxDecoration(
                            color: _cardWhite,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: _goldMid.withOpacity(0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _goldDeep.withOpacity(0.1),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              28,
                            ), // Simplified padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── MINIMAL UI (REMOVED BULKY HEADER) ──
                                _dividerLabel('Personal Info'),
                                const SizedBox(height: 12),

                                // ── FIRST + LAST NAME (2-column) ──
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildField(
                                        c1,
                                        Icons.badge_rounded,
                                        'First Name',
                                        false,
                                        _f1,
                                        (v) => setState(() => _f1 = v),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildField(
                                        c2,
                                        Icons.badge_outlined,
                                        'Last Name',
                                        false,
                                        _f2,
                                        (v) => setState(() => _f2 = v),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // ── CONTACT (full width) ──
                                _buildField(
                                  c5,
                                  Icons.phone_android_rounded,
                                  'Contact No.',
                                  false,
                                  _f5,
                                  (v) => setState(() => _f5 = v),
                                  kType: TextInputType.phone,
                                  formatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                ),

                                const SizedBox(height: 20),
                                _dividerLabel('Account Details'),
                                const SizedBox(height: 12),

                                // ── USERNAME ──
                                _buildField(
                                  c3,
                                  Icons.alternate_email_rounded,
                                  'Username',
                                  false,
                                  _f3,
                                  (v) => setState(() => _f3 = v),
                                ),
                                const SizedBox(height: 12),

                                // ── PASSWORD ──
                                _buildField(
                                  c4,
                                  Icons.lock_outline_rounded,
                                  'Password',
                                  true,
                                  _f4,
                                  (v) => setState(() => _f4 = v),
                                ),

                                const SizedBox(height: 28),

                                // ── BUTTON ──
                                GestureDetector(
                                  onTap: isLoading ? null : _register,
                                  child: Container(
                                    width: double.infinity,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: const LinearGradient(
                                        colors: [
                                          _goldDeep,
                                          _goldMid,
                                          _goldShine,
                                          _goldMid,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _goldDeep.withOpacity(0.3),
                                          blurRadius: 16,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              'CREATE ACCOUNT',
                                              style: GoogleFonts.dmSans(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        TextButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'Already a patient? ',
                              style: GoogleFonts.dmSans(
                                color: _textMuted,
                                fontSize: 13,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Login →',
                                  style: TextStyle(
                                    color: _goldPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── SECTION DIVIDER LABEL ──
  Widget _dividerLabel(String label) => Row(
    children: [
      Text(
        label,
        style: GoogleFonts.dmSans(
          color: _goldPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(child: Container(height: 1, color: _goldMid.withOpacity(0.2))),
    ],
  );

  Widget _buildField(
    TextEditingController ctrl,
    IconData icon,
    String label,
    bool isPass,
    bool isFocused,
    ValueChanged<bool> onFocus, {
    TextInputType kType = TextInputType.text,
    List<TextInputFormatter>? formatters,
  }) {
    return Focus(
      onFocusChange: onFocus,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _inputCream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isFocused ? _goldMid : _goldMid.withOpacity(0.15),
            width: isFocused ? 1.5 : 1,
          ),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    color: _goldMid.withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: -2,
                  ),
                ]
              : [],
        ),
        child: TextField(
          controller: ctrl,
          obscureText: isPass ? obscure : false,
          keyboardType: kType,
          inputFormatters: formatters,
          style: GoogleFonts.dmSans(
            color: _textDark,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: isFocused ? _goldMid : _textMuted,
              size: 18,
            ),
            hintText: label,
            hintStyle: TextStyle(
              color: _textMuted.withOpacity(0.5),
              fontSize: 13,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            suffixIcon: isPass
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: _textMuted,
                      size: 18,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

// ── PERFECTED GOLD PAINTER (Matched from Welcome & Login Screens) ──
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
