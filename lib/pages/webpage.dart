import 'package:flutter/material.dart';
import 'package:postman_app/components/main_drawer.dart';

class WebPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web'),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child:
              Text('Web Page Content', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
