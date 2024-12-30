import 'package:flutter/material.dart';
import 'package:postman_app/components/environment_dropdown.dart';
import 'package:postman_app/components/workspace_dropdown.dart';

class WorkspaceEnvironment extends StatelessWidget {
  final String? selectedWorkspace;
  final String? selectedEnvironment;
  final Function(String?) onWorkspaceChanged;
  final Function(String?) onEnvironmentChanged;
  final List<String> environments;

  const WorkspaceEnvironment({
    super.key,
    this.selectedWorkspace,
    this.selectedEnvironment,
    required this.onWorkspaceChanged,
    required this.onEnvironmentChanged,
    required this.environments,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WorkspaceDropdown(
          selectedWorkspace: selectedWorkspace,
          onWorkspaceChanged: onWorkspaceChanged,
        ),
        SizedBox(width: 8),
        Expanded(
          child: EnvironmentDropdown(
            selectedEnvironment: selectedEnvironment,
            environments: environments,
            onEnvironmentChanged: onEnvironmentChanged,
          ),
        ),
      ],
    );
  }
}
