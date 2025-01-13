// lib/services/settings_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  
  late SharedPreferences _prefs;
  bool _initialized = false;

  SettingsService._internal();

  // Initialize method
  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // URLs
  static const String LEARNING_CENTER_URL = 'https://learning.postman.com';
  static const String SUPPORT_CENTER_URL = 'https://support.postman.com';
  static const String TRUST_SECURITY_URL = 'https://www.postman.com/trust';
  static const String PRIVACY_POLICY_URL = 'https://www.postman.com/privacy-policy';
  static const String TERMS_URL = 'https://www.postman.com/terms';
  static const String TWITTER_URL = 'https://twitter.com/getpostman';

  // Launch URL method
  Future<void> launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // This ensures it opens in external browser
      )) {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      throw 'Failed to open link: $e';
    }
  }

  // Theme preferences
  Future<void> setTheme(String theme) async {
    await _prefs.setString('theme', theme);
  }

  String getTheme() {
    return _prefs.getString('theme') ?? 'dark';
  }

  // Language preferences
  Future<void> setLanguage(String language) async {
    await _prefs.setString('language', language);
  }

  String getLanguage() {
    return _prefs.getString('language') ?? 'en';
  }
}


// lib/models/settings_model.dart
class SettingsItem {
  final String title;
  final String url;
  final IconData icon;
  final Function? onTap;

  SettingsItem({
    required this.title,
    required this.url,
    required this.icon,
    this.onTap,
  });
}



class SettingsController extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      await _settingsService.init();
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> handleItemTap(BuildContext context, String url) async {
    try {
      await _settingsService.launchURL(url);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open link: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> updateTheme(String theme) async {
    await _settingsService.setTheme(theme);
    notifyListeners();
  }

  Future<void> updateLanguage(String language) async {
    await _settingsService.setLanguage(language);
    notifyListeners();
  }
}
