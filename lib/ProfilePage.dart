import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required bool isDarkMode});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'User';
  String _email = 'user@example.com';
  String _fullName = 'User';
  String _githubUsername = '';
  String _joinDate = 'April 2025';
  bool _isEditing = false;
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _githubUsernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _authToken = ''; // Will be fetched from SharedPreferences

  @override
  void initState() {
    super.initState();
    _fetchAuthTokenAndUserData();
  }

  Future<void> _fetchAuthTokenAndUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('access_token') ?? '';
    });
    if (_authToken.isNotEmpty) {
      await _fetchUserData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No authentication token found. Please log in.'),
        ),
      );
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('https://devexy-backend.azurewebsites.net/auth/me'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final user = jsonDecode(response.body);
        setState(() {
          _username = user['username'] ?? 'User';
          _email = user['email'] ?? 'user@example.com';
          _fullName = user['full_name'] ?? 'User';
          _githubUsername = user['github_username'] ?? '';
          _fullNameController.text = _fullName;
          _emailController.text = _email;
          _githubUsernameController.text = _githubUsername;
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading user data: $e')));
    }
  }

  Future<void> _updateUserData() async {
    try {
      final response = await http.put(
        Uri.parse('https://devexy-backend.azurewebsites.net/auth/update'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({
          'full_name': _fullNameController.text,
          'email': _emailController.text,
          'github_username': _githubUsernameController.text,
          'password': _passwordController.text,
          'confirm_password': _confirmPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final updatedUser = jsonDecode(response.body);
        setState(() {
          _fullName = updatedUser['full_name'] ?? _fullName;
          _email = updatedUser['email'] ?? _email;
          _githubUsername = updatedUser['github_username'] ?? _githubUsername;
          _username = updatedUser['username'] ?? _username;
          _isEditing = false;
          _fullNameController.text = _fullName;
          _emailController.text = _email;
          _githubUsernameController.text = _githubUsername;
          _passwordController.clear();
          _confirmPasswordController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        throw Exception('Failed to update user data');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: isDarkMode ? Colors.green[400] : Colors.green[600],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green[200],
              child: Icon(
                Icons.person,
                size: 80,
                color: isDarkMode ? Colors.green[800] : Colors.green[600],
              ),
            ),
            const SizedBox(height: 24),
            if (_isEditing)
              Column(
                children: [
                  TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _githubUsernameController,
                    decoration: InputDecoration(
                      labelText: 'GitHub Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    _fullName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _email,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _githubUsername.isNotEmpty
                        ? 'GitHub: $_githubUsername'
                        : '',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Text(
              'Member since $_joinDate',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            _buildInfoSection(isDarkMode, 'Account Information', [
              {'label': 'Full Name', 'value': _fullName},
              {'label': 'Email', 'value': _email},
              {'label': 'GitHub Username', 'value': _githubUsername},
              {'label': 'Membership', 'value': 'Basic'},
            ]),
            const SizedBox(height: 16),

            _buildInfoSection(isDarkMode, 'Settings', [
              {'label': 'Notifications', 'value': 'Enabled'},
              {'label': 'Language', 'value': 'English'},
              {'label': 'Privacy', 'value': 'Public'},
            ]),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _authToken.isEmpty
                        ? null
                        : () {
                          if (_isEditing) {
                            if (_passwordController.text ==
                                _confirmPasswordController.text) {
                              _updateUserData();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match'),
                                ),
                              );
                            }
                          } else {
                            setState(() {
                              _isEditing = true;
                            });
                          }
                        },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isEditing ? 'Update Profile' : 'Edit Profile',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    bool isDarkMode,
    String title,
    List<Map<String, String>> items,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1f2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.green[400] : Colors.green[600],
            ),
          ),
          const SizedBox(height: 16),
          ...items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['label']!,
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                      Text(
                        item['value']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
