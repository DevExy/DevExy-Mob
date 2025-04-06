import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Login Page
class LoginPage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const LoginPage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = '';
  bool _isLoading = false;
  bool _showSuccess = false;

  Future<void> _handleLogin() async {
    setState(() {
      _error = '';
      _isLoading = true;
    });

    final formData = {
      'username': _usernameController.text,
      'password': _passwordController.text,
      'grant_type': 'password',
      'scope': '',
      'client_id': 'string', // Replace with actual client_id
      'client_secret': 'string', // Replace with actual client_secret
    };

    try {
      final response = await http.post(
        Uri.parse('https://devexy-backend.azurewebsites.net/auth/login'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access_token']);
        await prefs.setString('token_type', data['token_type']);
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString(
          'user',
          jsonEncode({'username': _usernameController.text}),
        );
        setState(() => _showSuccess = true);
      } else {
        setState(
          () => _error = data['detail'] ?? 'Invalid username or password',
        );
      }
    } catch (e) {
      setState(
        () =>
            _error = 'Failed to connect to the server. Please try again later.',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePopupClose() {
    setState(() => _showSuccess = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            // Centers the entire content vertically and horizontally
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centers children horizontally
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers children vertically
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
                                color:
                                    widget.isDarkMode
                                        ? Colors.green[400]
                                        : Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => widget.toggleTheme(!widget.isDarkMode),
                        icon: Icon(
                          widget.isDarkMode
                              ? Icons.wb_sunny
                              : Icons.nightlight_round,
                          color:
                              widget.isDarkMode
                                  ? Colors.yellow[300]
                                  : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 120),
                  // Form Container
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color:
                              widget.isDarkMode
                                  ? const Color(0xFF1f2937)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 10),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(height: 2, color: Colors.green),
                            const SizedBox(height: 16),
                            Image.asset('assets/logo.png', height: 40),
                            const SizedBox(height: 16),
                            Text(
                              'Welcome back',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color:
                                    widget.isDarkMode
                                        ? Colors.green
                                        : Colors.green[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in to your DevExy account',
                              style: TextStyle(
                                color:
                                    widget.isDarkMode
                                        ? Colors.grey[300]
                                        : Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (_error.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red[900],
                                  border: const Border(
                                    left: BorderSide(
                                      color: Colors.red,
                                      width: 4,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _error,
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                        ),
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
                                hintText: 'Enter your username',
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              child: Text(
                                _isLoading ? 'Loading...' : 'Sign in',
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: TextStyle(
                                    color:
                                        widget.isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                  ),
                                ),
                                GestureDetector(
                                  onTap:
                                      () => Navigator.pushNamed(
                                        context,
                                        '/register',
                                      ),
                                  child: Text(
                                    'Sign up now',
                                    style: TextStyle(
                                      color:
                                          widget.isDarkMode
                                              ? Colors.green[500]
                                              : Colors.green[600],
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
                ],
              ),
            ),
          ),
          if (_showSuccess)
            SuccessPopup(
              message: 'Login successful',
              onClose: _handlePopupClose,
            ),
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
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onClose, child: const Text('OK')),
          ],
        ),
      ),
    );
  }
}
