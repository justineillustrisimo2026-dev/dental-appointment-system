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

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..forward();
  }

  void _register() {
    if (c1.text.isEmpty ||
        c2.text.isEmpty ||
        c3.text.isEmpty ||
        c4.text.isEmpty ||
        c5.text.isEmpty) {
      return _showMsg('Please fill all fields', Colors.red);
    }
    if (c4.text.length < 6) {
      return _showMsg('Password must be at least 6 characters', Colors.red);
    }

    setState(() => isLoading = true);
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showMsg('Account created! Please login.', const Color(0xFF4A6FA5));
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
          content: Row(
            children: [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 8),
              Text(msg),
            ],
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xFF2C3E50), const Color(0xFF4A6FA5)],
        ),
      ),
      child: SafeArea(
        child: FadeTransition(
          opacity: _animController,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header with back button and clinic name
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'SMILE ART',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              'DENTAL CLINIC',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Title
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Join our dental family',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  // White Card for Form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        35,
                      ), // Increased to match dashboard
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _field(Icons.person_outline, 'First Name', c1),
                        const SizedBox(height: 16),
                        _field(Icons.person, 'Last Name', c2),
                        const SizedBox(height: 16),
                        _field(Icons.account_circle, 'Username', c3),
                        const SizedBox(height: 16),
                        _field(
                          Icons.lock_outline,
                          'Password',
                          c4,
                          isPass: true,
                        ),
                        const SizedBox(height: 16),
                        _field(
                          Icons.phone_outlined,
                          'Contact Number',
                          c5,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A6FA5),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ), // Pill shape
                              elevation: 3,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    'CREATE ACCOUNT',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
    ),
  );

  Widget _field(
    IconData icon,
    String hint,
    TextEditingController ctrl, {
    bool isPass = false,
    TextInputType keyboardType = TextInputType.text,
  }) => TextField(
    controller: ctrl,
    obscureText: isPass ? obscure : false,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF4A6FA5)),
      suffixIcon: isPass
          ? IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF4A6FA5),
              ),
              onPressed: () => setState(() => obscure = !obscure),
            )
          : null,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ), // Pill shape
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
  );

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
}
