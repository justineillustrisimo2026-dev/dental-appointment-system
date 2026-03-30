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
    with TickerProviderStateMixin {
  final c1 = TextEditingController(); // First Name
  final c2 = TextEditingController(); // Last Name
  final c3 = TextEditingController(); // Username
  final c4 = TextEditingController(); // Password
  final c5 = TextEditingController(); // Contact

  bool isLoading = false, obscure = true;
  late AnimationController _mainController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  final Color goldDeep = const Color(0xFFB88A44);
  final Color goldMid = const Color(0xFFD4AF37);
  final Color goldShine = const Color.fromARGB(255, 240, 216, 108);
  final Color goldPrimary = const Color(0xFFB59410);

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = CurvedAnimation(parent: _mainController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _mainController, curve: Curves.fastOutSlowIn),
        );
    _mainController.forward();
  }

  @override
  void dispose() {
    c1.dispose();
    c2.dispose();
    c3.dispose();
    c4.dispose();
    c5.dispose();
    _mainController.dispose();
    super.dispose();
  }

  void _register() {
    if (c1.text.isEmpty ||
        c2.text.isEmpty ||
        c3.text.isEmpty ||
        c4.text.isEmpty ||
        c5.text.isEmpty) {
      _showMsg('Please fill all fields', Colors.redAccent);
      return;
    }
    if (c5.text.length != 11) {
      _showMsg('Contact must be 11 digits', Colors.redAccent);
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
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✨ Background changed to White
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                // ⚪ WHITE LOGO ORB
                Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: goldDeep.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
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
                    color: goldPrimary, // ✨ Gold text for White background
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 25),

                // ⬜ GRADIENT GOLD REGISTER CARD
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Container(
                      padding: const EdgeInsets.all(28),
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
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Account',
                            style: GoogleFonts.montserrat(
                              color: Colors
                                  .white, // ✨ White text for Gold background
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInput(
                            c1,
                            Icons.badge_rounded,
                            'First Name',
                            false,
                          ),
                          const SizedBox(height: 12),
                          _buildInput(
                            c2,
                            Icons.badge_outlined,
                            'Last Name',
                            false,
                          ),
                          const SizedBox(height: 12),
                          _buildInput(
                            c3,
                            Icons.person_outline,
                            'Username',
                            false,
                          ),
                          const SizedBox(height: 12),
                          _buildInput(
                            c5,
                            Icons.phone_android_rounded,
                            'Contact No.',
                            false,
                            TextInputType.phone,
                            [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInput(
                            c4,
                            Icons.lock_outline_rounded,
                            'Password',
                            true,
                          ),
                          const SizedBox(height: 25),

                          // 🔘 WHITE BUTTON
                          GestureDetector(
                            onTap: isLoading ? null : _register,
                            child: Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                color:
                                    Colors.white, // ✨ White button for contrast
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: goldPrimary,
                                      )
                                    : Text(
                                        'CREATE ACCOUNT',
                                        style: GoogleFonts.montserrat(
                                          color:
                                              goldPrimary, // ✨ Gold text for White button
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                          letterSpacing: 1,
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
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: "Already a patient? ",
                      style: GoogleFonts.montserrat(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
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
    );
  }

  Widget _buildInput(
    TextEditingController ctrl,
    IconData icon,
    String hint,
    bool isPass, [
    TextInputType kType = TextInputType.text,
    List<TextInputFormatter>? formatters,
  ]) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // ✨ White inputs for Gold card
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isPass ? obscure : false,
        keyboardType: kType,
        inputFormatters: formatters,
        style: GoogleFonts.montserrat(
          color: const Color(0xFF1E293B),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: goldPrimary, size: 20),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
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
