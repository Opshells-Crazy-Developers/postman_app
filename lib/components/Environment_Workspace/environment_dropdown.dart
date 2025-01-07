// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:postman_app/firebaseServices/firestore_services.dart';

class EnvironmentDropdown extends StatefulWidget {
  final String? selectedEnvironment;
  final List<String> environments;
  final Function(String?) onEnvironmentChanged;

  const EnvironmentDropdown({
    super.key,
    this.selectedEnvironment,
    required this.environments,
    required this.onEnvironmentChanged,
  });

  @override
  State<EnvironmentDropdown> createState() => _EnvironmentDropdownState();
}

class _EnvironmentDropdownState extends State<EnvironmentDropdown> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController environmentNameController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: _firestoreService.getEnvironment(),
      builder: (context, snapshot) {
        List<String> Environments = ['My Environment'];
        if (snapshot.hasData) {
          Environments.addAll(
              snapshot.data!.where((w) => w != 'My Environments'));
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[600]!, width: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(Icons.crop_landscape_outlined,
              //     color: Colors.grey[400], size: 18),
              // SizedBox(width: 6),
              DropdownButton<String>(
                value: widget.selectedEnvironment ?? Environments[0],
                dropdownColor: Colors.grey[850],
                style: TextStyle(color: Colors.white),
                underline: Container(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
                items: [
                  ...Environments.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }),
                  DropdownMenuItem<String>(
                    value: 'Create New Environment',
                    child: Text('Create New Environment',
                        style: TextStyle(color: Colors.orange)),
                  ),
                ],
                onChanged: (String? newValue) {
                  if (newValue == 'Create New Environment') {
                    _showCreateWorkspaceDialog();
                  } else {
                    widget.onEnvironmentChanged(newValue);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateWorkspaceDialog() {
    environmentNameController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text('Create New Environment',
              style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: environmentNameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'environment Name',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.public, color: Colors.grey[400], size: 20),
                  SizedBox(width: 8),
                  Text('Personal environment',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Only you can access this environment',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.orange)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create', style: TextStyle(color: Colors.orange)),
              onPressed: () async {
                if (environmentNameController.text.isNotEmpty) {
                  try {
                    await _firestoreService.addEnvironment(
                      environmentNameController.text,
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    // Show error message to user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to create workspace')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
