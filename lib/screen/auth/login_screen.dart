import 'dart:ui';
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
    with TickerProviderStateMixin {
  final user = TextEditingController();
  final pass = TextEditingController();
  bool isLoading = false, obscure = true;

  // ── ✨ ANIMATION CONTROLLERS ──
  late AnimationController _mainController;
  late AnimationController _buttonController;
  late Animation<double> _buttonScale;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  final Color goldDeep = const Color(0xFFB88A44);
  final Color goldMid = const Color(0xFFD4AF37);
  final Color goldShine = const Color.fromARGB(255, 240, 216, 108);
  final Color goldPrimary = const Color(0xFFB59410);

  @override
  void initState() {
    super.initState();
    if (widget.registeredUsername != null)
      user.text = widget.registeredUsername!;

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = CurvedAnimation(parent: _mainController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _mainController, curve: Curves.fastOutSlowIn),
        );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _mainController.forward();
  }

  @override
  void dispose() {
    user.dispose();
    pass.dispose();
    _mainController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    _buttonController.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    _buttonController.reverse();

    ScaffoldMessenger.of(context).clearSnackBars();

    if (user.text.trim().isEmpty || pass.text.trim().isEmpty) {
      _showMsg(
        'Access Denied: Please enter your credentials',
        Colors.redAccent,
      );
      return;
    }

    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).clearSnackBars();

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
    });
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✨ Background changed to White
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ⚪ WHITE LOGO ORB (Above Login Section)
                    Container(
                      height: 110,
                      width: 110,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: goldDeep.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/clinic_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'SMILE ART',
                      style: GoogleFonts.cinzel(
                        color:
                            goldPrimary, // ✨ Text changed to Gold for white background
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                      ),
                    ),
                    const SizedBox(height: 35),

                    // ⬜ GRADIENT GOLD LOGIN CARD
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            // ✨ Background changed to Gradient Gold
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                goldDeep,
                                goldMid,
                                goldShine,
                                goldMid,
                                goldDeep,
                              ],
                              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: goldDeep.withOpacity(0.3),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Welcome to Smile Art',
                                style: GoogleFonts.montserrat(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ), // ✨ White text for Gold background
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your dental health, our priority',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 35),

                              _buildInput(
                                user,
                                Icons.person_rounded,
                                'Username',
                                false,
                              ),
                              const SizedBox(height: 18),
                              _buildInput(
                                pass,
                                Icons.lock_rounded,
                                'Password',
                                true,
                              ),

                              const SizedBox(height: 35),

                              // 🔘 ANIMATED BUTTON (White for contrast on Gold card)
                              ScaleTransition(
                                scale: _buttonScale,
                                child: GestureDetector(
                                  onTap: isLoading ? null : _handleLogin,
                                  child: Container(
                                    width: double.infinity,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white, // ✨ White button
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 12,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: isLoading
                                          ? CircularProgressIndicator(
                                              color: goldPrimary,
                                              strokeWidth: 3,
                                            )
                                          : Text(
                                              'SIGN IN',
                                              style: GoogleFonts.montserrat(
                                                color:
                                                    goldPrimary, // ✨ Gold text for White button
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // REGISTER FOOTER
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
                          style: GoogleFonts.montserrat(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(
                              text: "Register Now",
                              style: TextStyle(
                                color: goldPrimary,
                                fontWeight: FontWeight.w900,
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
        ],
      ),
    );
  }

  Widget _buildInput(
    TextEditingController ctrl,
    IconData icon,
    String hint,
    bool isPass,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // ✨ Keep input white for best readability
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isPass ? obscure : false,
        style: GoogleFonts.montserrat(
          color: const Color(0xFF1E293B),
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: goldPrimary, size: 22),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          suffixIcon: isPass
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.blueGrey,
                    size: 18,
                  ),
                  onPressed: () => setState(() => obscure = !obscure),
                )
              : null,
        ),
      ),
    );
  }
}
