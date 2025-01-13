import 'package:flutter/material.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  final TextEditingController _collectionNameController =
      TextEditingController();
  final List<String> collections = [];

  void _createNewCollection() {
    String selectedTemplate = 'Blank Template'; // Default selection

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[800],
              title: const Text(
                'Create New Collection',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _collectionNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter collection name',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Select Template:',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    // Template Options
                    _buildTemplateOption(
                      'Blank Template',
                      selectedTemplate,
                      setState,
                      (value) => selectedTemplate = value,
                    ),
                    _buildTemplateOption(
                      'REST API Basics',
                      selectedTemplate,
                      setState,
                      (value) => selectedTemplate = value,
                    ),
                    _buildTemplateOption(
                      'Integration Testing Basic',
                      selectedTemplate,
                      setState,
                      (value) => selectedTemplate = value,
                    ),
                    _buildTemplateOption(
                      'API Documentation',
                      selectedTemplate,
                      setState,
                      (value) => selectedTemplate = value,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _collectionNameController.clear();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_collectionNameController.text.isNotEmpty) {
                      setState(() {
                        // Add both collection name and template type
                        collections.add(
                            '${_collectionNameController.text} ($selectedTemplate)');
                      });
                      Navigator.pop(context);
                      _collectionNameController.clear();
                    }
                  },
                  child: const Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTemplateOption(
    String title,
    String selectedTemplate,
    StateSetter setState,
    Function(String) onChanged,
  ) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      value: title,
      groupValue: selectedTemplate,
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            onChanged(value);
          });
        }
      },
      activeColor: Colors.blue,
      fillColor: WidgetStateProperty.all(Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewCollection,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Container(
        color: Colors.grey[850],
        child: collections.isEmpty
            ? const Center(
                child: Text(
                  'No Collections Yet',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      collections[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: const Icon(
                      Icons.folder,
                      color: Colors.white,
                    ),
                    onTap: () {
                      // Handle collection tap
                    },
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    _collectionNameController.dispose();
    super.dispose();
  }
}
