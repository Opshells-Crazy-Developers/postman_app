import 'package:flutter/material.dart';

class bodyContainer extends StatefulWidget {
  const bodyContainer({super.key});

  @override
  State<bodyContainer> createState() => _bodyContainerState();
}

class _bodyContainerState extends State<bodyContainer> {
  String selectedBodyType = 'raw';

  final TextEditingController bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Radio Buttons in ScrollView
          Container(
            height: 50, // Fixed height for the radio button container
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Raw Radio Button
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'raw',
                          groupValue: selectedBodyType,
                          onChanged: (String? value) {
                            setState(() {
                              selectedBodyType = value!;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        Text(
                          'raw',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Form Data Radio Button
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'form-data',
                          groupValue: selectedBodyType,
                          onChanged: (String? value) {
                            setState(() {
                              selectedBodyType = value!;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        Text(
                          'form-data',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // x-www-form-urlencoded Radio Button
                  Row(
                    children: [
                      Radio<String>(
                        value: 'x-www-form-urlencoded',
                        groupValue: selectedBodyType,
                        onChanged: (String? value) {
                          setState(() {
                            selectedBodyType = value!;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      Text(
                        'x-www-form-urlencoded',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Body Content based on selected type
          Expanded(
            child: _buildBodyContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    switch (selectedBodyType) {
      case 'raw':
        return TextField(
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
        );

      case 'form-data':
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Key', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text('Value', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Type', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 32), // Space for add/remove buttons
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 1, // You can make this dynamic
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: InputDecoration(
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
                        SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: InputDecoration(
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
                        SizedBox(width: 8),
                        Expanded(
                          child: DropdownButton<String>(
                            value: 'Text',
                            isExpanded: true,
                            dropdownColor: Colors.grey[800],
                            items: ['Text', 'File'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              // Handle type change
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            // Handle adding new row
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );

      case 'x-www-form-urlencoded':
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Key', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Value', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 32), // Space for add/remove buttons
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 1, // You can make this dynamic
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
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
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
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
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            // Handle adding new row
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );

      default:
        return Container();
    }
  }
}
