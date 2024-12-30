// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:postman_app/components/main_drawer.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collections'),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child: Text('Collections Content',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}