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

  // ── ✨ RADIANT GOLD COLORS (Matching your Image) ──
  final Color goldDeep = const Color(0xFFB88A44); // The darker "bronze" edges
  final Color goldMid = const Color(0xFFD4AF37); // The classic gold transition
  final Color goldShine = const Color.fromARGB(
    255,
    241,
    225,
    156,
  ); // The Radiant Shine
  // The bright "radiant" center
  final Color goldPrimary = const Color(0xFFB59410);

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

  void _showMsg(String msg, Color color) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset('assets/clinic_logo.png', width: 120),
                ),
                const SizedBox(height: 20),
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: goldPrimary,
                  ),
                ),
                const SizedBox(height: 25),

                // ── 🟡 UPDATED RADIANT GRADIENT CONTAINER ──
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    // THIS IS THE GRADIENT LOGIC FROM THE IMAGE
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        goldDeep, // Start dark
                        goldMid, // Move to gold
                        goldShine, // THE RADIANT SHINE (Center)
                        goldMid, // Back to gold
                        goldDeep, // End dark
                      ],
                      stops: const [
                        0.0,
                        0.25,
                        0.5,
                        0.75,
                        1.0,
                      ], // Controls the "spread"
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: goldDeep.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _inputField(c1, Icons.badge_rounded, 'First Name', false),
                      const SizedBox(height: 15),
                      _inputField(c2, Icons.badge_outlined, 'Last Name', false),
                      const SizedBox(height: 15),
                      _inputField(c3, Icons.person_outline, 'Username', false),
                      const SizedBox(height: 15),
                      _inputField(
                        c5,
                        Icons.phone_android_rounded,
                        'Contact No.',
                        false,
                        TextInputType.phone,
                      ),
                      const SizedBox(height: 15),
                      _inputField(
                        c4,
                        Icons.lock_outline_rounded,
                        'Password',
                        true,
                      ),
                      const SizedBox(height: 30),

                      // SIGN UP BUTTON
                      GestureDetector(
                        onTap: isLoading ? null : _register,
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 10),
                            ],
                          ),
                          child: Center(
                            child: isLoading
                                ? CircularProgressIndicator(color: goldPrimary)
                                : Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      color: goldPrimary,
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
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: textMuted),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: goldPrimary,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _inputField(
    TextEditingController ctrl,
    IconData icon,
    String hint,
    bool isPass, [
    TextInputType kType = TextInputType.text,
  ]) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isPass ? obscure : false,
        keyboardType: kType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: goldPrimary, size: 20),
          border: InputBorder.none,
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          suffixIcon: isPass
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: goldPrimary,
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
