// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({
    super.key,
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  String selectedAuthType = 'No Auth';

  final TextEditingController tokenNameController = TextEditingController();
  final TextEditingController authUrlController = TextEditingController();
  final TextEditingController accessTokenUrlController =
      TextEditingController();
  final TextEditingController clientIdController = TextEditingController();
  final TextEditingController clientSecretController = TextEditingController();

  String? accessToken;
  DateTime? tokenExpiryTime;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    tokenController.dispose();
    tokenNameController.dispose();
    authUrlController.dispose();
    accessTokenUrlController.dispose();
    clientIdController.dispose();
    clientSecretController.dispose();
    super.dispose();
  }

  // In your AuthPage class
  String? validateAuthInputs() {
    switch (selectedAuthType) {
      case 'Basic Auth':
        if (usernameController.text.isEmpty ||
            passwordController.text.isEmpty) {
          return 'Username and password are required for Basic Auth';
        }
        break;
      case 'Bearer Token':
      case 'JWT Bearer':
        if (tokenController.text.isEmpty) {
          return 'Token is required';
        }
        break;
      case 'OAuth 2.0':
        // Add OAuth validation logic here
        break;
    }
    return null;
  }

  Widget _buildAuthenticationForm() {
    switch (selectedAuthType) {
      case 'Basic Auth':
        return Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.person, color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.white70),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.white),
            ),
          ],
        );

      case 'Bearer Token':
      case 'JWT Bearer':
        return TextField(
          controller: tokenController,
          decoration: InputDecoration(
            labelText: 'Token',
            labelStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.vpn_key, color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
        );

      case 'OAuth 2.0':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: tokenNameController,
              decoration: InputDecoration(
                labelText: 'Token Name',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.link, color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 12),
            TextField(
              controller: authUrlController,
              decoration: InputDecoration(
                labelText: 'Auth URL',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.link, color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 12),
            TextField(
              controller: accessTokenUrlController,
              decoration: InputDecoration(
                labelText: 'Access Token URL',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.link, color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 12),
            TextField(
              controller: clientIdController,
              decoration: InputDecoration(
                labelText: 'Client ID',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.account_box, color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 12),
            TextField(
              controller: clientSecretController,
              decoration: InputDecoration(
                labelText: 'Client Secret',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.security, color: Colors.white70),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _getNewAccessToken();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
              ),
              child: Text('Get New Access Token'),
            ),
          ],
        );

      default: // No Auth
        return Center(
          child: Text(
            'No authentication required',
            style: TextStyle(color: Colors.white70),
          ),
        );
    }
  }

  String _generateRandomState() {
    final random = Random();
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(32, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  // Helper method to save token information
  Future<void> _saveTokenInformation(
      String tokenName, Map<String, dynamic> tokenData) async {
    try {
      // Create a document with all the token information
      final tokenDocument = {
        'token_name': tokenName,
        'auth_url': authUrlController.text,
        'access_token_url': accessTokenUrlController.text,
        'client_id': clientIdController.text,
        'client_secret': clientSecretController.text,
        'access_token': tokenData['access_token'],
        'refresh_token': tokenData['refresh_token'],
        'expires_in': tokenData['expires_in'],
        'token_type': tokenData['token_type'],
        'scope': tokenData['scope'],
        'created_at': FieldValue.serverTimestamp(),
        'expiry_time': tokenExpiryTime?.toIso8601String(),
        'last_updated': FieldValue.serverTimestamp(),
      };

      // Save to Firebase
      await _firestore
          .collection('tokens')
          .doc(tokenName) // Using tokenName as document ID
          .set(tokenDocument, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token saved successfully to Firebase')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Error saving token to Firebase: ${error.toString()}')),
      );
    }
  }

  Future<Map<String, dynamic>?> getTokenFromFirebase(String tokenName) async {
    try {
      final docSnapshot =
          await _firestore.collection('tokens').doc(tokenName).get();

      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      }
      return null;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving token: ${error.toString()}')),
      );
      return null;
    }
  }

  Future<void> updateTokenInFirebase(
      String tokenName, Map<String, dynamic> tokenData) async {
    try {
      await _firestore.collection('tokens').doc(tokenName).update({
        'access_token': tokenData['access_token'],
        'refresh_token': tokenData['refresh_token'],
        'expires_in': tokenData['expires_in'],
        'last_updated': FieldValue.serverTimestamp(),
        'expiry_time': tokenExpiryTime?.toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating token: ${error.toString()}')),
      );
    }
  }

  // Modify _getNewAccessToken to check for existing tokens
  Future<void> _getNewAccessToken() async {
    final clientID = clientIdController.text;
    final clientSecret = clientSecretController.text;
    final authUrl = authUrlController.text;
    final accessTokenUrl = accessTokenUrlController.text;
    final tokenName = tokenNameController.text;

    if (clientID.isEmpty ||
        clientSecret.isEmpty ||
        authUrl.isEmpty ||
        accessTokenUrl.isEmpty ||
        tokenName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Check if token already exists
      final existingToken = await getTokenFromFirebase(tokenName);
      if (existingToken != null) {
        // Show confirmation dialog
        final shouldUpdate = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Token Already Exists'),
            content: Text('Do you want to update the existing token?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Update'),
              ),
            ],
          ),
        );

        if (shouldUpdate != true) {
          return;
        }
      }

      // Continue with token generation...
      final authorizationUrl = Uri.parse(authUrl).replace(
        queryParameters: {
          'response_type': 'code',
          'client_id': clientID,
          'redirect_uri': 'your_redirect_uri',
          'scope': 'your_scope',
          'state': _generateRandomState(),
        },
      );

      // Assuming we received the authorization code
      final authCode = 'received_auth_code';

      final response = await http.post(
        Uri.parse(accessTokenUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$clientID:$clientSecret'))}',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': authCode,
          'redirect_uri': 'your_redirect_uri',
        },
      );

      if (response.statusCode == 200) {
        final tokenData = json.decode(response.body);

        setState(() {
          accessToken = tokenData['access_token'];
          if (tokenData['expires_in'] != null) {
            tokenExpiryTime =
                DateTime.now().add(Duration(seconds: tokenData['expires_in']));
          }
          tokenController.text = accessToken ?? '';
        });

        // Save or update token in Firebase
        if (existingToken != null) {
          await updateTokenInFirebase(tokenName, tokenData);
        } else {
          await _saveTokenInformation(tokenName, tokenData);
        }
      } else {
        throw Exception('Failed to get access token: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }
  }

  

  // Add method to check if token is expired
  bool isTokenExpired() {
    if (tokenExpiryTime == null) return true;
    return DateTime.now().isAfter(tokenExpiryTime!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Auth Type Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedAuthType,
                  isExpanded: true,
                  dropdownColor: Colors.grey[800],
                  style: TextStyle(color: Colors.white),
                  items: [
                    'No Auth',
                    'Basic Auth',
                    'Bearer Token',
                    'JWT Bearer',
                    'OAuth 2.0',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedAuthType = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            // Auth Form
            _buildAuthenticationForm(),
          ],
        ),
      ),
    );
  }
}
