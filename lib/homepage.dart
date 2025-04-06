import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = 'User';
  List<Map<String, String>> _notifications = [
    {
      'title': 'Welcome!',
      'message': 'Thanks for joining DevExy.',
      'time': 'Today, 10:00 AM',
    },
    {
      'title': 'Update Available',
      'message': 'Version 1.1 is ready.',
      'time': 'Yesterday, 3:45 PM',
    },
  ];
  // List<Map<String, dynamic>> _trackingData = [
  //   {'activity': 'Login', 'date': 'April 05, 2025', 'status': 'Completed'},
  //   {
  //     'activity': 'Profile Update',
  //     'date': 'April 04, 2025',
  //     'status': 'Pending',
  //   },
  // ];

  // New test insights data
  Map<String, dynamic> _testInsights = {
    'unit_tests': {'passed': 42, 'failed': 3, 'total': 45, 'percentage': 93.3},
    'integration_tests': {
      'passed': 18,
      'failed': 2,
      'total': 20,
      'percentage': 90.0,
    },
    'stress_tests': {
      'passed': 12,
      'failed': 1,
      'total': 13,
      'percentage': 92.3,
    },
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        _username = user['username'] ?? 'User';
      });
    }

    // Load test insights data (in a real app, this might come from an API)
    final testInsightsJson = prefs.getString('test_insights');
    if (testInsightsJson != null) {
      setState(() {
        _testInsights = jsonDecode(testInsightsJson);
      });
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;
    final themeColor = isDarkMode ? Colors.green[400]! : Colors.green[600]!;
    final backgroundColor = isDarkMode ? const Color(0xFF1f2937) : Colors.white;
    final cardBackgroundColor =
        isDarkMode ? const Color(0xFF2d3748) : Colors.grey[50]!;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 28),
            const SizedBox(width: 10),
            Text(
              'DevExy',
              style: TextStyle(
                color: themeColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => widget.toggleTheme(!widget.isDarkMode),
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: isDarkMode ? Colors.yellow[300]! : Colors.grey[700]!,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section with Profile Button
            _buildWelcomeCard(
              themeColor,
              backgroundColor,
              secondaryTextColor,
              isDarkMode,
            ),
            const SizedBox(height: 24),

            // New Test Insights Section
            _buildTestInsightsSection(
              themeColor,
              cardBackgroundColor,
              textColor,
              secondaryTextColor,
              isDarkMode,
            ),
            const SizedBox(height: 24),

            // // Activity Tracking Section
            // _buildSectionHeader('Activity Tracking', themeColor),
            // const SizedBox(height: 12),
            // _buildActivityTrackingCard(
            //   cardBackgroundColor,
            //   textColor,
            //   secondaryTextColor,
            // ),
            // const SizedBox(height: 24),

            // Notifications Section
            _buildSectionHeader('Notifications', themeColor),
            const SizedBox(height: 12),
            _buildNotificationsCard(
              cardBackgroundColor,
              themeColor,
              textColor,
              secondaryTextColor,
            ),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtonsCard(
              cardBackgroundColor,
              themeColor,
              isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(
    Color themeColor,
    Color backgroundColor,
    Color secondaryTextColor,
    bool isDarkMode,
  ) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: themeColor.withOpacity(0.9),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/profile'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: themeColor, size: 36),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $_username',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to view your profile details',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.9),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestInsightsSection(
    Color themeColor,
    Color cardBackgroundColor,
    Color textColor,
    Color secondaryTextColor,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Test Insights', themeColor),
        const SizedBox(height: 12),
        Card(
          elevation: 6,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: cardBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Test Pass Rates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTestPassRateIndicator(
                              'Unit Tests',
                              _testInsights['unit_tests']['percentage'],
                              Colors.blue,
                              textColor,
                              secondaryTextColor,
                            ),
                            _buildTestPassRateIndicator(
                              'Integration Tests',
                              _testInsights['integration_tests']['percentage'],
                              Colors.purple,
                              textColor,
                              secondaryTextColor,
                            ),
                            _buildTestPassRateIndicator(
                              'Stress Tests',
                              _testInsights['stress_tests']['percentage'],
                              Colors.orange,
                              textColor,
                              secondaryTextColor,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: _buildTestDetailsList(
                          textColor,
                          secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.pushNamed(context, '/test-dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.analytics),
                    label: const Text('View Detailed Reports'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestPassRateIndicator(
    String label,
    double percentage,
    Color color,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: Stack(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 6,
                ),
              ),
              Center(
                child: Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: secondaryTextColor),
          ),
        ),
      ],
    );
  }

  Widget _buildTestDetailsList(Color textColor, Color secondaryTextColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: secondaryTextColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTestDetailItem(
            'Unit Tests',
            '${_testInsights['unit_tests']['passed']}/${_testInsights['unit_tests']['total']}',
            textColor,
            secondaryTextColor,
          ),
          _buildTestDetailItem(
            'Integration Tests',
            '${_testInsights['integration_tests']['passed']}/${_testInsights['integration_tests']['total']}',
            textColor,
            secondaryTextColor,
          ),
          _buildTestDetailItem(
            'Stress Tests',
            '${_testInsights['stress_tests']['passed']}/${_testInsights['stress_tests']['total']}',
            textColor,
            secondaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTestDetailItem(
    String label,
    String value,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: secondaryTextColor)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTrackingCard(
    Color cardBackgroundColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // child: Column(
        //   children:
        //       _trackingData.map((data) {
        //         return Padding(
        //           padding: const EdgeInsets.symmetric(vertical: 8.0),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Expanded(
        //                 child: Row(
        //                   children: [
        //                     Container(
        //                       width: 10,
        //                       height: 10,
        //                       decoration: BoxDecoration(
        //                         color:
        //                             data['status'] == 'Completed'
        //                                 ? Colors.green
        //                                 : Colors.grey,
        //                         shape: BoxShape.circle,
        //                       ),
        //                     ),
        //                     const SizedBox(width: 12),
        //                     Expanded(
        //                       child: Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: [
        //                           Text(
        //                             data['activity']!,
        //                             style: TextStyle(
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.w500,
        //                               color: textColor,
        //                             ),
        //                           ),
        //                           Text(
        //                             data['date']!,
        //                             style: TextStyle(
        //                               fontSize: 14,
        //                               color: secondaryTextColor,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               Container(
        //                 padding: const EdgeInsets.symmetric(
        //                   horizontal: 12,
        //                   vertical: 6,
        //                 ),
        //                 decoration: BoxDecoration(
        //                   color:
        //                       data['status'] == 'Completed'
        //                           ? Colors.green.withOpacity(0.15)
        //                           : Colors.grey.withOpacity(0.15),
        //                   borderRadius: BorderRadius.circular(12),
        //                 ),
        //                 child: Text(
        //                   data['status']!,
        //                   style: TextStyle(
        //                     fontSize: 14,
        //                     fontWeight: FontWeight.w500,
        //                     color:
        //                         data['status'] == 'Completed'
        //                             ? Colors.green
        //                             : Colors.grey,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //       }).toList(),
        // ),
      ),
    );
  }

  Widget _buildNotificationsCard(
    Color cardBackgroundColor,
    Color themeColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children:
              _notifications.map((notification) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications,
                          color: themeColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notification['title']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  notification['time']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: secondaryTextColor.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification['message']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionButtonsCard(
    Color cardBackgroundColor,
    Color themeColor,
    bool isDarkMode,
  ) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? Colors.grey[700] : Colors.grey[300],
                  foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Log Out'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.person_add),
                label: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
