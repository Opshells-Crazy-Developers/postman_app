import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:postman_app/pages/ApisPage.dart';
import 'package:postman_app/pages/HelpPage.dart';
import 'package:postman_app/pages/Historypage.dart';
import 'package:postman_app/pages/MonitorPage.dart';
import 'package:postman_app/pages/mainscreen.dart';
import 'package:postman_app/pages/webpage.dart';
import 'package:postman_app/pages/workspacePage.dart';
import 'pages/CollectionsPage.dart';
import 'pages/settingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Postman Clone',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/web': (context) => WebPage(),
        '/workspace': (context) => WorkspacePage(),
        '/collections': (context) => CollectionsPage(),
        '/apis': (context) => ApisPage(),
        '/monitor': (context) => MonitorPage(),
        '/history': (context) => HistoryPage(),
        '/help': (context) => HelpPage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}


