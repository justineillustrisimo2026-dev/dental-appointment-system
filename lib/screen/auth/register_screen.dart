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

  // ── ☀️ DYNAMIC THEMED (Matches Login and Dashboard perfectly) ──
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  // ── PREMIUM SLATE BLUE DARK MODE ──
  Color get bg => isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F6F9);
  Color get card => isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get surface =>
      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  Color get text => isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
  Color get textMuted =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get border =>
      isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0);

  Color get primary => const Color(0xFF4A6CF7);
  Color get accent => const Color(0xFF00D4FF);
  Color get danger => const Color(0xFFEF4444);

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
      return _showMsg('Please fill all fields', danger);
    }
    if (c4.text.length < 6) {
      return _showMsg('Password must be at least 6 characters', danger);
    }

    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showMsg('Account created! Please login.', primary);

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

  void _showMsg(
    String msg,
    Color color,
  ) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              msg,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                // ── SLEEK HEADER LAYOUT ──
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: border),
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: text,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SMILE ART',
                            style: TextStyle(
                              color: text,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            'DENTAL CLINIC',
                            style: TextStyle(
                              color: primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.medical_services_rounded,
                        color: primary,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: text,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Join our dental family securely',
                  style: TextStyle(
                    fontSize: 14,
                    color: textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),

                // ── REGISTRATION FORM FLOATING CARD ──
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(color: border),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.04),
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

                      // ── CREATE ACCOUNT BUTTON ──
                      GestureDetector(
                        onTap: isLoading ? null : _register,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [primary, accent]),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text(
                                    'CREATE ACCOUNT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
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

                // ── ALREADY HAVE ACCOUNT LINK ──
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
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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

  // ── CUSTOM INPUT FIELD HELPER ──
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
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
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
          icon: Icon(icon, color: primary, size: 22),
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
