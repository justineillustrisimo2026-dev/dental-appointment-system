import 'package:flutter/material.dart';
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
  late AnimationController _animController;

  // ── ☀️ WEB-MATCHED LUXURY THEME ──
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get bg =>
      isDark ? const Color(0xFF0F172A) : Colors.white; // Pure White Background
  Color get textDark => const Color(0xFF1E293B);
  Color get textMuted => const Color(0xFF64748B);

  // SIGNATURE GOLD COLORS
  final Color goldPrimary = const Color(0xFFB59410);
  final Color goldLight = const Color(0xFFFCF6BA);
  final Color goldDark = const Color(0xFFBF953F);

  @override
  void initState() {
    super.initState();
    if (widget.registeredUsername != null) {
      user.text = widget.registeredUsername!;
    }
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    user.dispose();
    pass.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _login() {
    if (user.text.isEmpty || pass.text.isEmpty) {
      _showMsg('Please fill all fields', Colors.redAccent);
      return;
    }
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            patientName: widget.registeredUsername ?? user.text,
            firstName: widget.registeredFirstName ?? 'John',
            lastName: widget.registeredLastName ?? 'Doe',
            contactNo: widget.registeredContact ?? 'Not provided',
          ),
        ),
      );
    });
  }

  void _showMsg(String msg, Color color) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _animController,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── 1. THE LOGO (PLACED ON THE WHITE BACKGROUND) ──
                  // ── 1. THE LOGO ONLY (NO FALLBACK ICON) ──s
                  Image.asset(
                    'assets/clinic_logo.png',
                    width: 140,
                    fit: BoxFit.contain,
                    // errorBuilder is removed so the medical icon never appears
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'SMILE ART DENTAL CLINIC',
                    style: TextStyle(
                      color: goldPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ── 2. YOUR GRADIENT GOLD BOX STARTS HERE ──
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          goldPrimary, // The main, rich gold
                          goldDark, // The deep, metallic gold
                        ],
                        // No stops needed for a smooth, natural blend
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          // Using a gold-tinted shadow makes the box look like it belongs
                          color: goldDark.withOpacity(0.3),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        _label('Username'),
                        _inputField(
                          user,
                          Icons.person_outline,
                          'Enter username',
                          false,
                        ),

                        const SizedBox(height: 20),

                        _label('Password'),
                        _inputField(pass, Icons.lock_outline, '••••••••', true),

                        const SizedBox(height: 30),

                        // ── 3. WHITE BUTTON (Contrasts against Gold Box) ──
                        GestureDetector(
                          onTap: isLoading ? null : _login,
                          child: Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: goldPrimary,
                                    )
                                  : Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: goldPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── REGISTER LINK ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: textDark),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        ),
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                            color: goldPrimary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );

  Widget _inputField(
    TextEditingController ctrl,
    IconData icon,
    String hint,
    bool isPass,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isPass ? obscure : false,
        style: TextStyle(color: textDark, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: goldPrimary),
          hintText: hint,
          hintStyle: TextStyle(color: textMuted.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          suffixIcon: isPass
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: goldPrimary,
                  ),
                  onPressed: () => setState(() => obscure = !obscure),
                )
              : null,
        ),
      ),
    );
  }
}
