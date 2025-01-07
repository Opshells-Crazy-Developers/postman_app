import 'package:flutter/material.dart';

class Params extends StatefulWidget {
  
  const Params({super.key});

  @override
  State<Params> createState() => _ParamsState();
}

class _ParamsState extends State<Params> {
  List<Map<String, TextEditingController>> paramControllers = [
  {
    'key': TextEditingController(),
    'value': TextEditingController(),
    'description': TextEditingController(),
  }
];

Widget _buildParamRow(int index) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        // Key Field
        Expanded(
          child: TextField(
            controller: paramControllers[index]['key'],
            decoration: InputDecoration(
              hintText: 'Key',
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 8),
        
        // Value Field
        Expanded(
          child: TextField(
            controller: paramControllers[index]['value'],
            decoration: InputDecoration(
              hintText: 'Value',
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 8),
        
        // Description Field
        Expanded(
          child: TextField(
            controller: paramControllers[index]['description'],
            decoration: InputDecoration(
              hintText: 'Description',
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
        
        // Add/Remove buttons
        SizedBox(width: 8),
        if (index == paramControllers.length - 1)
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              setState(() {
                paramControllers.add({
                  'key': TextEditingController(),
                  'value': TextEditingController(),
                  'description': TextEditingController(),
                });
              });
            },
          ),
        if (paramControllers.length > 1)
          IconButton(
            icon: Icon(Icons.remove, color: Colors.white),
            onPressed: () {
              setState(() {
                if (index < paramControllers.length) {
                  // Dispose controllers before removing
                  paramControllers[index]['key']?.dispose();
                  paramControllers[index]['value']?.dispose();
                  paramControllers[index]['description']?.dispose();
                  paramControllers.removeAt(index);
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
  for (var controller in paramControllers) {
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
          'Params',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Param Fields
      ...paramControllers.asMap().entries.map((entry) {
        return _buildParamRow(entry.key);
      }).toList(),
    ],
  ),
);
  }
}