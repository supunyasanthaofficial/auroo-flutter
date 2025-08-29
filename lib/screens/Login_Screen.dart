import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../context/Product_Provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Map<String, bool> _errors = {};

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    final newErrors = <String, bool>{};
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      newErrors['email'] = true;
    }
    if (password.isEmpty || password.length < 6) {
      newErrors['password'] = true;
    }

    setState(() {
      _errors = newErrors;
    });

    return newErrors.isEmpty;
  }

  void _handleLogin(BuildContext context) {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid email and password (min 6 chars).',
          ),
        ),
      );
      return;
    }

    final cartItems =
        (ModalRoute.of(context)?.settings.arguments as List<CartItem>?) ?? [];
    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: {
        'cartItems': cartItems,
        'userEmail': _emailController.text.trim(),
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login Successful, redirecting to checkout...'),
      ),
    );
  }

  void _handleGoogleLogin(BuildContext context) {
    final cartItems =
        (ModalRoute.of(context)?.settings.arguments as List<CartItem>?) ?? [];
    // Set Google profile picture in ProductProvider
    context.read<ProductProvider>().setProfileImage(
      'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
    );
    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: {
        'cartItems': cartItems,
        'userEmail': _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : 'guest@gmail.com',
      },
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mock Google login success!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/images/Auroo2.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome Back 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                    fontFamily: 'Helvetica',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to continue shopping',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Helvetica',
                  ),
                ),
                const SizedBox(height: 32),
                Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['email'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['email'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['email'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF8E44AD),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['password'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['password'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['password'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF8E44AD),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E44AD),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      onPressed: () => _handleLogin(context),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        fontFamily: 'Helvetica',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => _handleGoogleLogin(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD1D5DB)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Ionicons.logo_google,
                              size: 22,
                              color: Color(0xFF8032AD),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF374151),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ],
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
}
