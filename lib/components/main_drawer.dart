import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.orange.withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.api, size: 40, color: Colors.orange),
                  SizedBox(height: 8),
                  Text(
                    'Postman Clone',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    'No environment',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Spacer(),
                  Icon(Icons.expand_more, color: Colors.grey[400]),
                ],
              ),
            ),
            Divider(color: Colors.grey[800]),
            DrawerListTile(
              icon: Icons.home,
              title: 'Home',
              onTap: () => Navigator.pushNamed(context, '/'),
            ),
            DrawerListTile(
              icon: Icons.web,
              title: 'Web',
              onTap: () => Navigator.pushNamed(context, '/web'),
            ),
            DrawerListTile(
              icon: Icons.crop_landscape_outlined,
              title: 'Workspace',
              onTap: () => Navigator.pushNamed(context, '/workspace'),
            ),
            DrawerListTile(
              icon: Icons.event_note_outlined,
              title: 'Collections',
              onTap: () => Navigator.pushNamed(context, '/collections'),
            ),
            DrawerListTile(
              icon: Icons.api_outlined,
              title: 'APIs (VPN Networks)',
              onTap: () => Navigator.pushNamed(context, '/apis'),
            ),
            // DrawerListTile(
            //   icon: Icons.monitor_heart,
            //   title: 'Monitor',
            //   onTap: () => Navigator.pushNamed(context, '/monitor'),
            // ),
            // DrawerListTile(
            //   icon: Icons.history,
            //   title: 'History',
            //   onTap: () => Navigator.pushNamed(context, '/history'),
            // ),
            Divider(color: Colors.grey[800]),
            DrawerListTile(
              icon: Icons.help_outline,
              title: 'Help',
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
            DrawerListTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
    );
  }
}
class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
      // ignore: deprecated_member_use
      hoverColor: Colors.orange.withOpacity(0.1),
    );
  }
}

