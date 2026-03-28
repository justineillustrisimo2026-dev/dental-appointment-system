import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final c1 = TextEditingController(),
      c2 = TextEditingController(),
      c3 = TextEditingController(),
      c4 = TextEditingController(),
      c5 = TextEditingController();

  bool isLoading = false, obscure = true;
  late AnimationController _animController;

  // ── ✨ LUXURY GOLD THEME COLORS ──
  final Color goldPrimary = const Color(0xFFD4AF37); // Metallic Gold
  final Color goldDark = const Color(0xFFA67C00); // Deep Gold
  final Color goldLight = const Color(0xFFF9E4B7); // Champagne Gold

  Color get bg => Colors.white;
  Color get text => const Color(0xFF1E293B);
  Color get textMuted => const Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    c1.dispose();
    c2.dispose();
    c3.dispose();
    c4.dispose();
    c5.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _register() {
    if (c1.text.isEmpty ||
        c2.text.isEmpty ||
        c3.text.isEmpty ||
        c4.text.isEmpty ||
        c5.text.isEmpty) {
      return _showMsg('Please fill all fields', Colors.redAccent);
    }
    if (c4.text.length < 6) {
      return _showMsg(
        'Password must be at least 6 characters',
        Colors.redAccent,
      );
    }

    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showMsg('Account created! Please login.', goldDark);

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
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── ✨ TOP LOGO & BRANDING ──
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/clinic_logo.png',
                        width: 140, // Elegant size for the register header
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ── ✨ TOP LOGO & BRANDING ──
                // (This part is around line 130 of your code)
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color:
                        goldDark, // <-- CHANGE THIS FROM 'text' TO 'goldDark'
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Join our dental family securely',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        goldDark, // <-- CHANGE THIS FROM 'textMuted' TO 'goldDark'
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),

                // ── 🏆 GOLD REGISTRATION CARD ──
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [goldPrimary, goldDark], // Matches your Login box
                    ),
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: goldDark.withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _inputField(c1, Icons.badge_rounded, 'First Name', false),
                      const SizedBox(height: 16),
                      _inputField(c2, Icons.badge_outlined, 'Last Name', false),
                      const SizedBox(height: 16),
                      _inputField(
                        c3,
                        Icons.alternate_email_rounded,
                        'Username',
                        false,
                      ),
                      const SizedBox(height: 16),
                      _inputField(
                        c5,
                        Icons.phone_rounded,
                        'Contact No.',
                        false,
                        TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _inputField(c4, Icons.lock_rounded, 'Password', true),

                      const SizedBox(height: 32),

                      // ── ✨ SIGN UP BUTTON (Premium White on Gold) ──
                      GestureDetector(
                        onTap: isLoading ? null : _register,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: goldDark,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      color: goldDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── 🔗 BACK TO LOGIN ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: goldDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 🎨 CUSTOM INPUT FIELD HELPER (Styled for Gold Card) ──
  Widget _inputField(
    TextEditingController ctrl,
    IconData icon,
    String hint,
    bool isPass, [
    TextInputType kType = TextInputType.text,
  ]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white, // Pure white for high contrast inside the gold box
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isPass ? obscure : false,
        keyboardType: kType,
        style: TextStyle(
          color: text,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          icon: Icon(icon, color: goldDark, size: 22),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: textMuted, fontWeight: FontWeight.normal),
          suffixIcon: isPass
              ? IconButton(
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: textMuted,
                    size: 20,
                  ),
                  onPressed: () => setState(() => obscure = !obscure),
                )
              : null,
        ),
      ),
    );
  }
}
