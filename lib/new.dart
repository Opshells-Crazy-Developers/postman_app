// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewFile extends StatefulWidget {
  const NewFile({super.key});

  @override
  State<NewFile> createState() => _NewFileState();
}

class _NewFileState extends State<NewFile> {
  String selectedMethod = 'GET';
  final TextEditingController urlController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  // Add these variables to store response data
  String responseBody = '';
  int statusCode = 0;
  bool isLoading = false;
  bool hasRequestBeenSent = false;

  String selectedAuthType = 'No Auth';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();

  Future<void> sendRequest() async {
    setState(() {
      isLoading = true;
      responseBody = '';
      statusCode = 0;
      hasRequestBeenSent = true;
    });

    try {
      final url = Uri.parse(urlController.text);
final headers = {
        'Content-Type': 'application/json',
        ...getAuthorizationHeader(),
      };    
        http.Response response;

      switch (selectedMethod) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: bodyController.text,
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: bodyController.text,
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception('Unsupported method');
      }

      setState(() {
        responseBody = _formatResponse(response.body);
        statusCode = response.statusCode;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        responseBody = 'Error: $e';
        statusCode = -1;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  String _formatResponse(String body) {
    try {
      var jsonObj = json.decode(body);
      return JsonEncoder.withIndent('  ').convert(jsonObj);
    } catch (e) {
      return body; // Return original body if it's not JSON
    }
  }

  Map<String, String> getAuthorizationHeader() {
    switch (selectedAuthType) {
      case 'Basic Auth':
        if (usernameController.text.isNotEmpty || passwordController.text.isNotEmpty) {
          final credentials = base64Encode(
            utf8.encode('${usernameController.text}:${passwordController.text}')
          );
          return {'Authorization': 'Basic $credentials'};
        }
        break;

      case 'Bearer Token':
        if (tokenController.text.isNotEmpty) {
          return {'Authorization': 'Bearer ${tokenController.text}'};
        }
        break;

      case 'JWT Bearer':
        if (tokenController.text.isNotEmpty) {
          return {'Authorization': 'Bearer ${tokenController.text}'};
        }
        break;

      case 'OAuth 2.0':
        if (tokenController.text.isNotEmpty) {
          return {'Authorization': 'Bearer ${tokenController.text}'};
        }
        break;
    }
    return {};
  }

  // Add this method to validate authorization inputs
  String? validateAuthInputs() {
    switch (selectedAuthType) {
      case 'Basic Auth':
        if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
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


  Color getMethodColor(String method) {
    switch (method) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.orange;
      case 'PUT':
        return Colors.blue;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.white;
    }
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


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.03,
                vertical: screenSize.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Request Method and URL
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8.0),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: getMethodColor(selectedMethod)
                          //         .withOpacity(0.5),
                          //     blurRadius: 8,
                          //     spreadRadius: 1,
                          //   ),
                          // ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButton<String>(
                          value: selectedMethod,
                          items: ['GET', 'POST', 'PUT', 'DELETE']
                              .map(
                                (method) => DropdownMenuItem(
                                  value: method,
                                  child: Text(
                                    method,
                                    style: TextStyle(
                                      color: getMethodColor(method),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedMethod = value!;
                            });
                          },
                          dropdownColor: Colors.grey[800],
                          underline: SizedBox.shrink(),
                        ),
                      ),
                      SizedBox(width: screenSize.width * 0.03),
                      Expanded(
                        child: TextField(
                          controller: urlController,
                          decoration: InputDecoration(
                            hintText: 'Enter URL',
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.02),

                  // Tabs Section
                  DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: Colors.blue,
                          tabs: [
                            Tab(text: "Params"),
                            Tab(text: "Headers"),
                            Tab(text: "Authorization"),
                            Tab(text: "Body"),
                          ],
                        ),
                        SizedBox(
                          height: screenSize.height * 0.3,
                          child: TabBarView(
                            children: [
                              // Params Section
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Params Section (Coming Soon)",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              // Headers Section
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Headers Section (Coming Soon)",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              //Authorization
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Auth Type Dropdown
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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

                              // Body Section
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: bodyController,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: 'Request Body (JSON)',
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),

                  if (hasRequestBeenSent) ...[
                    Container(
                      padding: EdgeInsets.all(12.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: _getStatusCodeColor(),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Response Header with Status and Clear button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Status: ',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$statusCode',
                                    style: TextStyle(
                                      color: _getStatusCodeColor(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // Clear Response Button
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.white70),
                                onPressed: () {
                                  setState(() {
                                    hasRequestBeenSent = false;
                                    responseBody = '';
                                    statusCode = 0;
                                  });
                                },
                                tooltip: 'Clear Response',
                              ),
                            ],
                          ),

                          SizedBox(height: 8),

                          // Response Body
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: screenSize.height * 0.3,
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                responseBody.isEmpty
                                    ? 'No response yet'
                                    : responseBody,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        final validationError = validateAuthInputs();
        if (validationError != null && selectedAuthType != 'No Auth') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(validationError),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        sendRequest();
      },
      backgroundColor: getMethodColor(selectedMethod),
      child: isLoading 
          ? CircularProgressIndicator(color: Colors.white)
          : Icon(Icons.send),
    ),
    );
  }

  Color _getStatusCodeColor() {
    if (statusCode == 0) return Colors.grey;
    if (statusCode == -1) return Colors.red;
    if (statusCode >= 200 && statusCode < 300) return Colors.green;
    if (statusCode >= 300 && statusCode < 400) return Colors.blue;
    if (statusCode >= 400 && statusCode < 500) return Colors.orange;
    return Colors.red;
  }

  void _clearAuthInputs() {
    usernameController.clear();
    passwordController.clear();
    tokenController.clear();
  }

  @override
  void dispose() {
    urlController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}
