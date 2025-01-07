import 'package:flutter/material.dart';

class header extends StatefulWidget {
  const header({super.key});

  @override
  State<header> createState() => _ParamsState();
}

class _ParamsState extends State<header> {
  List<Map<String, TextEditingController>> headerControllers = [
    {
      'key': TextEditingController(),
      'value': TextEditingController(),
      'description': TextEditingController(),
    }
  ];

  Widget _buildheaderRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          // Key Field
          Expanded(
            child: TextField(
              controller: headerControllers[index]['key'],
              decoration: InputDecoration(
                hintText: 'Key',
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 8),

          // Value Field
          Expanded(
            child: TextField(
              controller: headerControllers[index]['value'],
              decoration: InputDecoration(
                hintText: 'Value',
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 8),

          // Description Field
          Expanded(
            child: TextField(
              controller: headerControllers[index]['description'],
              decoration: InputDecoration(
                hintText: 'Description',
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),

          // Add/Remove buttons
          SizedBox(width: 8),
          if (index == headerControllers.length - 1)
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                setState(() {
                  headerControllers.add({
                    'key': TextEditingController(),
                    'value': TextEditingController(),
                    'description': TextEditingController(),
                  });
                });
              },
            ),
          if (headerControllers.length > 1)
            IconButton(
              icon: Icon(Icons.remove, color: Colors.white),
              onPressed: () {
                setState(() {
                  if (index < headerControllers.length) {
                    // Dispose controllers before removing
                    headerControllers[index]['key']?.dispose();
                    headerControllers[index]['value']?.dispose();
                    headerControllers[index]['description']?.dispose();
                    headerControllers.removeAt(index);
                  }
                });
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in headerControllers) {
      controller['key']?.dispose();
      controller['value']?.dispose();
      controller['description']?.dispose();
    }
    // ... rest of your dispose method
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Headers',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Param Fields
          ...headerControllers.asMap().entries.map((entry) {
            return _buildheaderRow(entry.key);
          }).toList(),
        ],
      ),
    );
  }
}
