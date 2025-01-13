// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:postman_app/Screens/LoginScreen.dart';
import 'package:postman_app/Screens/mainscreen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the user is logged in
        if (snapshot.hasData) {
          return const MainScreen(); // Your main screen after login
        }
        // If the user is NOT logged in
        return LoginScreen();
      },
    );
  }
}