// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:postman_app/firebase/firestore_services.dart';

class WorkspaceDropdown extends StatefulWidget {
  final String? selectedWorkspace;
  final Function(String?) onWorkspaceChanged;

  const WorkspaceDropdown({
    super.key,
    this.selectedWorkspace,
    required this.onWorkspaceChanged,
  });

  @override
  _WorkspaceDropdownState createState() => _WorkspaceDropdownState();
}

class _WorkspaceDropdownState extends State<WorkspaceDropdown> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController workspaceNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: _firestoreService.getWorkspaces(),
      builder: (context, snapshot) {
        List<String> workspaces = ['My Workspace'];
        if (snapshot.hasData) {
          workspaces.addAll(snapshot.data!.where((w) => w != 'My Workspace'));
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
                value: widget.selectedWorkspace ?? workspaces[0],
                dropdownColor: Colors.grey[850],
                style: TextStyle(color: Colors.white),
                underline: Container(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
                items: [
                  ...workspaces.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }),
                  DropdownMenuItem<String>(
                    value: 'Create New Workspace',
                    child: Text('Create New Workspace',
                        style: TextStyle(color: Colors.orange)),
                  ),
                ],
                onChanged: (String? newValue) {
                  if (newValue == 'Create New Workspace') {
                    _showCreateWorkspaceDialog();
                  } else {
                    widget.onWorkspaceChanged(newValue);
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
    workspaceNameController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text('Create New Workspace',
              style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: workspaceNameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Workspace Name',
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
                  Text('Personal Workspace',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Only you can access this workspace',
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
                if (workspaceNameController.text.isNotEmpty) {
                  try {
                    await _firestoreService.addWorkspace(
                      workspaceNameController.text,
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
