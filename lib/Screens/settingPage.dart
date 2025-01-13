// lib/screens/settings_page.dart
// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:postman_app/Screens/LoginScreen.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282828),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      try {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          // Navigate to login screen and clear navigation stack
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error logging out. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsController(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: Color(0xFF1C1C1C),
        ),
        backgroundColor: Color(0xFF282828),
        body: Consumer<SettingsController>(
          builder: (context, controller, child) {
            return ListView(
              children: [
                _buildSettingsGroup(
                  'Account',
                  [
                    _buildMenuItem(
                      'Logout',
                      Icons.logout,
                      context,
                      () => _handleLogout(context),
                    ),
                  ],
                ),
                _buildSettingsGroup(
                  'Resources',
                  [
                    _buildMenuItem(
                      'Learning Center',
                      Icons.book,
                      context,
                      () => controller.handleItemTap(
                        context,
                        SettingsService.LEARNING_CENTER_URL,
                      ),
                    ),
                    _buildMenuItem(
                      'Support Center',
                      Icons.support,
                      context,
                      () => controller.handleItemTap(
                        context,
                        SettingsService.SUPPORT_CENTER_URL,
                      ),
                    ),
                  ],
                ),
                _buildSettingsGroup(
                  'Legal',
                  [
                    _buildMenuItem(
                      'Trust and Security',
                      Icons.security,
                      context,
                      () => controller.handleItemTap(
                        context,
                        SettingsService.TRUST_SECURITY_URL,
                      ),
                    ),
                    _buildMenuItem(
                      'Privacy Policy',
                      Icons.privacy_tip,
                      context,
                      () => controller.handleItemTap(
                        context,
                        SettingsService.PRIVACY_POLICY_URL,
                      ),
                    ),
                    _buildMenuItem(
                      'Terms',
                      Icons.description,
                      context,
                      () => controller.handleItemTap(
                        context,
                        SettingsService.TERMS_URL,
                      ),
                    ),
                  ],
                ),
                _buildSettingsGroup(
                  'Social',
                  [
                    _buildMenuItem(
                      '@getpostman',
                      Icons.alternate_email,
                      context,
                      () => controller.handleItemTap(
                        context,
                        SettingsService.TWITTER_URL,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon,
    BuildContext context,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 30),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      tileColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: onTap,
    );
  }
}
