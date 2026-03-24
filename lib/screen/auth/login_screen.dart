import 'package:dentalclinicsystem/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'dashboard/dashboard_screen.dart'; // Make sure the path matches your project structure!

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

  // ── ☀️ DYNAMIC THEMED (Matches the rest of your app) ──
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
      _showMsg('Please fill all fields', danger);
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

  void _showMsg(
    String msg,
    Color color,
  ) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            msg,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── GLOWING LOGO ──
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [primary, accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🦷', style: TextStyle(fontSize: 44)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'SMILE ART',
                    style: TextStyle(
                      color: text,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'DENTAL CLINIC',
                    style: TextStyle(
                      color: primary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // ── FLOATING LOGIN CARD ──
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
                        _inputField(
                          user,
                          Icons.alternate_email_rounded,
                          'Username',
                          false,
                        ),
                        const SizedBox(height: 16),
                        _inputField(pass, Icons.lock_rounded, 'Password', true),
                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => _showMsg(
                              'Contact clinic to reset password',
                              primary,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── LOGIN BUTTON ──
                        GestureDetector(
                          onTap: isLoading ? null : _login,
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primary, accent],
                              ),
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
                                      'LOGIN',
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

                  // ── REGISTER LINK ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        ),
                        child: Text(
                          'Register',
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
      ),
    );
  }

  // ── CUSTOM INPUT FIELD HELPER ──
  Widget _inputField(
    TextEditingController ctrl,
    IconData icon,
    String hint,
    bool isPass,
  ) {
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
