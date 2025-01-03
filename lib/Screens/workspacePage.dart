

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:postman_app/firebase/firestore_services.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  _WorkspacePageState createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController workspaceNameController = TextEditingController();
  String? selectedWorkspace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text('Workspaces', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.orange),
            onPressed: () => _showCreateWorkspaceDialog(),
          ),
        ],
      ),
      body: StreamBuilder<List<String>>(
        stream: _firestoreService.getWorkspaces(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white)),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Colors.orange));
          }

          final workspaces = ['My Workspace'];
          if (snapshot.hasData) {
            workspaces.addAll(snapshot.data!.where((w) => w != 'My Workspace'));
          }

          return ListView.builder(
            itemCount: workspaces.length,
            itemBuilder: (context, index) {
              final workspace = workspaces[index];
              return ListTile(
                leading: Icon(Icons.crop_landscape_outlined,
                    color: Colors.grey[400]),
                title: Text(
                  workspace,
                  style: TextStyle(color: Colors.white),
                ),
                selected: selectedWorkspace == workspace,
                selectedTileColor: Colors.grey[850],
                onTap: () {
                  setState(() {
                    selectedWorkspace = workspace;
                  });
                  // Add any navigation or state management logic here
                },
                trailing: workspace != 'My Workspace'
                    ? IconButton(
                        icon:
                            Icon(Icons.delete_outline, color: Colors.grey[400]),
                        onPressed: () => _showDeleteConfirmation(workspace),
                      )
                    : null,
              );
            },
          );
        },
      ),
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
              onPressed: () => Navigator.of(context).pop(),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Workspace created successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create workspace'),
                        backgroundColor: Colors.red,
                      ),
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

  void _showDeleteConfirmation(String workspace) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title:
              Text('Delete Workspace', style: TextStyle(color: Colors.white)),
          content: Text('Are you sure you want to delete "$workspace"?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.orange)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  await _firestoreService.deleteWorkspace(workspace);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Workspace deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete workspace'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
