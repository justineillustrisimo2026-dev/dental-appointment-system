import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_screen.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? registeredFirstName,
      registeredLastName,
      registeredUsername,
      registeredContact;
  const LoginScreen({
    super.key,
    this.registeredFirstName,
    this.registeredLastName,
    this.registeredUsername,
    this.registeredContact,
  });
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ── ADDED MIXIN FOR ANIMATION ──

  final user = TextEditingController();
  final pass = TextEditingController();
  bool isLoading = false, obscure = true;
  bool _userFocused = false, _passFocused = false;

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

  // Exact 4-step gradient matching the Welcome Screen
  LinearGradient get goldGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_goldDeep, _goldMid, _goldShine, _goldMid],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  @override
  void initState() {
    super.initState();
    if (widget.registeredUsername != null) {
      user.text = widget.registeredUsername!;
    }

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
    user.dispose();
    pass.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (user.text.trim().isEmpty || pass.text.trim().isEmpty) {
      _showMsg('Please enter your credentials', Colors.redAccent.shade200);
      return;
    }
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          patientName: widget.registeredUsername ?? user.text,
          firstName: widget.registeredFirstName ?? 'User',
          lastName: widget.registeredLastName ?? 'Member',
          contactNo: widget.registeredContact ?? 'Not provided',
        ),
      ),
    );
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
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),

                        // ── LOGO ──
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _cardWhite,
                            border: Border.all(
                              color: _goldMid.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _goldDeep.withOpacity(0.22),
                                blurRadius: 28,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/clinic_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 16),

                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [_goldDeep, _goldMid, _goldShine, _goldMid],
                            stops: [0.0, 0.35, 0.65, 1.0],
                          ).createShader(bounds),
                          child: Text(
                            'SMILE ART',
                            style: GoogleFonts.cinzel(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 9,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'DENTAL CLINIC',
                          style: GoogleFonts.dmSans(
                            color: _textMuted,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 5,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // ── MINIMAL LOGIN CARD ──
                        Container(
                          decoration: BoxDecoration(
                            color: _cardWhite,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: _goldMid.withOpacity(0.28),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _goldDeep.withOpacity(0.13),
                                blurRadius: 40,
                                offset: const Offset(0, 16),
                                spreadRadius: -4,
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
                                // Clean, minimal fields directly inside the card
                                _fieldLabel('Username'),
                                const SizedBox(height: 6),
                                _buildField(
                                  user,
                                  Icons.alternate_email_rounded,
                                  'Enter your username',
                                  false,
                                  _userFocused,
                                  (v) => setState(() => _userFocused = v),
                                ),
                                const SizedBox(height: 18),
                                _fieldLabel('Password'),
                                const SizedBox(height: 6),
                                _buildField(
                                  pass,
                                  Icons.lock_outline_rounded,
                                  'Enter your password',
                                  true,
                                  _passFocused,
                                  (v) => setState(() => _passFocused = v),
                                ),
                                const SizedBox(height: 28),
                                GestureDetector(
                                  onTap: isLoading ? null : _handleLogin,
                                  child: Container(
                                    width: double.infinity,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          _goldDeep,
                                          _goldMid,
                                          _goldShine,
                                          _goldMid,
                                        ],
                                        stops: [0.0, 0.35, 0.65, 1.0],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _goldDeep.withOpacity(0.35),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'SIGN IN',
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 14,
                                                    letterSpacing: 2.5,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                const Icon(
                                                  Icons.arrow_forward_rounded,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── REGISTER FOOTER ──
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: GoogleFonts.dmSans(
                                color: _textMuted,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Register Now →',
                                  style: GoogleFonts.dmSans(
                                    color: _goldPrimary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),
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

  Widget _fieldLabel(String label) => Text(
    label,
    style: GoogleFonts.dmSans(
      color: _textDark,
      fontSize: 13,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget _buildField(
    TextEditingController ctrl,
    IconData icon,
    String label,
    bool isPass,
    bool isFocused,
    ValueChanged<bool> onFocus,
  ) {
    return Focus(
      onFocusChange: onFocus,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _inputCream,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFocused ? _goldMid : _goldMid.withOpacity(0.22),
            width: isFocused ? 1.5 : 1,
          ),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    color: _goldMid.withOpacity(0.15),
                    blurRadius: 14,
                    spreadRadius: -2,
                  ),
                ]
              : [],
        ),
        child: TextField(
          controller: ctrl,
          obscureText: isPass ? obscure : false,
          style: GoogleFonts.dmSans(
            color: _textDark,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: isFocused ? _goldMid : _textMuted,
              size: 20,
            ),
            hintText: label,
            hintStyle: GoogleFonts.dmSans(
              color: _textMuted.withOpacity(0.6),
              fontSize: 14,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 4,
            ),
            suffixIcon: isPass
                ? IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
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

// ── PERFECTED GOLD PAINTER (Matched from Welcome Screen) ──
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
