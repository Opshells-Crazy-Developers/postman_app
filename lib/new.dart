// newfile.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class newFile extends StatefulWidget {
  const newFile({super.key});

  @override
  State<newFile> createState() => _newFileState();
}

class _newFileState extends State<newFile> {
  String selectedMethod = 'GET';
  final TextEditingController urlController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  Future<void> sendRequest() async {
    try {
      final url = Uri.parse(urlController.text);
      final headers = {'Content-Type': 'application/json'};
      http.Response response;

      switch (selectedMethod) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: bodyController.text,
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: bodyController.text,
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception('Unsupported method');
      }

      // Show response in a snackbar or dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Response: ${response.statusCode}\n${response.body}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[850],
      child: Column(
        children: [
          // Request Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton<String>(
                    value: selectedMethod,
                    items: ['GET', 'POST', 'PUT', 'DELETE']
                        .map((method) => DropdownMenuItem(
                              value: method,
                              child: Text(
                                method,
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value!;
                      });
                    },
                    dropdownColor: Colors.grey[800],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: 'Enter URL',
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.5),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
          // Request Body Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: bodyController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Request Body (JSON)',
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.5),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: sendRequest,
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    urlController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}
