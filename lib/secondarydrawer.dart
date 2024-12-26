import 'package:flutter/material.dart';

class SecondaryDrawer extends StatelessWidget {
  final String selectedItem;
  final VoidCallback onClose;

  const SecondaryDrawer({super.key, 
    required this.selectedItem,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[850],
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[900],
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: onClose,
                  ),
                  SizedBox(width: 16),
                  Text(
                    _getTitle(selectedItem),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildContent(selectedItem),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle(String item) {
    return item.substring(0, 1).toUpperCase() + item.substring(1);
  }
   Widget _buildContent(String item) {
    switch (item) {
      case 'web':
        return _buildWebContent();
      case 'workspace':
        return _buildWorkspaceContent();
      case 'collections':
        return _buildCollectionsContent();
      case 'apis':
        return _buildApisContent();
      case 'monitor':
        return _buildMonitorContent();
      case 'history':
        return _buildHistoryContent();
      case 'help':
        return _buildHelpContent();
      case 'settings':
        return _buildSettingsContent();
      default:
        return Center(
          child: Text(
            'Content for $item',
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }

  Widget _buildWebContent() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text('New Request', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
        ListTile(
          title: Text('New Collection', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildWorkspaceContent() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text('My Workspace', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
        ListTile(
          title: Text('Create Workspace', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildCollectionsContent() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text('All Collections', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildApisContent() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text('API Repository', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMonitorContent() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text('All Monitors', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildHistoryContent() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text('Recent Requests', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildHelpContent() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text('Documentation', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
        ListTile(
          title: Text('Support', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingsContent() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text('General', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
        ListTile(
          title: Text('Themes', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
        ListTile(
          title: Text('Shortcuts', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
      ],
    );
  }
}
