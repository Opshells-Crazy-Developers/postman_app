import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:postman_app/widgets/app_state.dart';
import 'package:postman_app/Screens/ApisPage.dart';
import 'package:postman_app/Screens/HelpPage.dart';
import 'package:postman_app/Screens/Historypage.dart';
import 'package:postman_app/Screens/MonitorPage.dart';
import 'package:postman_app/Screens/mainscreen.dart';
import 'package:postman_app/Screens/webpage.dart';
import 'package:postman_app/Screens/workspacePage.dart';
import 'package:postman_app/Screens/workflow.dart';
import 'Screens/CollectionsPage.dart';
import 'Screens/settingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppStateContainer(child: MyApp()));
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
        '/workflow': (context) => CanvasScreen(),
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
