// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:postman_app/widgets/main_drawer.dart';

class ApisPage extends StatelessWidget {
  const ApisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APIs (VPN Network)'),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child: Text('APIs Content', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
