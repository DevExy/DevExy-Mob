import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Register Page
class RegisterPage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const RegisterPage({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _githubController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _error = '';
  bool _isLoading = false;
  bool _showSuccess = false;

  Future<void> _handleRegister() async {
    setState(() {
      _error = '';
      _isLoading = true;
    });

    if (_passwordController.text.length < 8) {
      setState(() {
        _error = 'Password must be at least 8 characters long.';
        _isLoading = false;
      });
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _error = 'Passwords do not match.';
        _isLoading = false;
      });
      return;
    }

    final payload = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'full_name': _fullNameController.text,
      'github_username': _githubController.text,
      'password': _passwordController.text,
      'confirm_password': _confirmPasswordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('https://devexy-backend.azurewebsites.net/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() => _showSuccess = true);
      } else {
        setState(() => _error = data['detail'] ?? 'Registration failed. Please try again.');
      }
    } catch (e) {
      setState(() => _error = 'Failed to connect to the server. Please try again later.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePopupClose() {
    setState(() => _showSuccess = false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/home'),
                        child: Row(
                          children: [
                            Image.asset('assets/logo.png', height: 24),
                            const SizedBox(width: 8),
                            Text(
                              'DevExy',
                              style: TextStyle(
                                fontSize: 20,
                                color: widget.isDarkMode ? Colors.green[400] : Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => widget.toggleTheme(!widget.isDarkMode),
                        icon: Icon(
                          widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                          color: widget.isDarkMode ? Colors.yellow[300] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Form Container
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: widget.isDarkMode ? const Color(0xFF1f2937) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 16),
                        Image.asset('assets/logo.png', height: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: widget.isDarkMode ? Colors.green : Colors.green[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign up for your DevExy account',
                          style: TextStyle(color: widget.isDarkMode ? Colors.grey[300] : Colors.grey[500]),
                        ),
                        const SizedBox(height: 24),
                        if (_error.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[900],
                              border: const Border(left: BorderSide(color: Colors.red, width: 4)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error, color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _error,
                                    style: const TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                        // Form Fields
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            hintText: 'Choose a username',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _githubController,
                          decoration: const InputDecoration(
                            labelText: 'GitHub Username',
                            hintText: 'Enter your GitHub username',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Create a password (min. 8 characters)',
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Password must be at least 8 characters long',
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Confirm your password',
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          child: Text(_isLoading ? 'Loading...' : 'Create Account'),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/login'),
                              child: Text(
                                'Log in here',
                                style: TextStyle(
                                  color: widget.isDarkMode ? Colors.green[500] : Colors.green[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showSuccess) SuccessPopup(message: 'Registration successful', onClose: _handlePopupClose),
        ],
      ),
    );
  }
}

// Success Popup
class SuccessPopup extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const SuccessPopup({super.key, required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1f2937),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onClose,
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}