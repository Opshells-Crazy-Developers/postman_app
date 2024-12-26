import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          children: [
            // Outlined Header
            Container(
              color: Colors.grey[900],
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  Icon(Icons.web, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildOutlinedTab('Overview', true),
                          buildOutlinedTab('Test Examples', false),
                          buildOutlinedTab('Another Tab', false),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.add, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    'No environment',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Icon(Icons.expand_more, color: Colors.grey[400]),
                ],
              ),
            ),
            // Rest of the UI
            Expanded(
              child: Center(
                child: Text(
                  'Body Content Here',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget buildOutlinedTab(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.orange : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}