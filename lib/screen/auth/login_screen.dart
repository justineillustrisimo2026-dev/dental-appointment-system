import 'package:dentalclinicsystem/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'dashboard/dashboard_screen.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.registeredUsername != null) {
      user.text = widget.registeredUsername!;
    }
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..forward();
  }

  void _login() {
    if (user.text.isEmpty || pass.text.isEmpty) {
      _showMsg('Please fill all fields', Colors.red);
      return;
    }
    setState(() => isLoading = true);
    Future.delayed(Duration(seconds: 1), () {
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
                  // Logo and Clinic Name
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🦷', style: TextStyle(fontSize: 50)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SMILE ART',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const Text(
                    'DENTAL CLINIC',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // White Card for Form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Username Field
                        TextField(
                          controller: user,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: const Color(0xFF4A6FA5),
                            ),
                            hintText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F7FA),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        TextField(
                          controller: pass,
                          obscureText: obscure,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: const Color(0xFF4A6FA5),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF4A6FA5),
                              ),
                              onPressed: () =>
                                  setState(() => obscure = !obscure),
                            ),
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F7FA),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _showMsg(
                              'Contact clinic to reset password',
                              const Color(0xFF4A6FA5),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF4A6FA5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A6FA5),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 3,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    'LOGIN',
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
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Register',
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

  @override
  void dispose() {
    user.dispose();
    pass.dispose();
    _animController.dispose();
    super.dispose();
  }
}
