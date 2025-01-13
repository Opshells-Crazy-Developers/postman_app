// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (user?.photoURL != null)
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user!.photoURL!),
                      backgroundColor: Colors.orange.withOpacity(0.2),
                    )
                  else
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.orange.withOpacity(0.2),
                      child: const Icon(Icons.person,
                          size: 35, color: Colors.white),
                    ),
                  const SizedBox(height: 8),
                  // Show user's name if available, otherwise show 'Guest'
                  Text(
                    user?.displayName ?? 'Guest',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  // Show user's email
                  if (user?.email != null)
                    Text(
                      user!.email!,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            DrawerListTile(
              icon: Icons.home,
              title: 'Home',
              onTap: () => Navigator.pushNamed(context, '/main'),
            ),
            // DrawerListTile(
            //   icon: Icons.web,
            //   title: 'Web',
            //   onTap: () => Navigator.pushNamed(context, '/web'),
            // ),
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
              icon: Icons.account_tree_rounded,
              title: 'Workflow',
              onTap: () => Navigator.pushNamed(context, '/workflow'),
            ),
            DrawerListTile(
              icon: Icons.history_outlined,
              title: 'History',
              onTap: () => Navigator.pushNamed(context, '/history'),
            ),
            DrawerListTile(
              icon: Icons.api_outlined,
              title: 'APIs (VPN Networks)',
              onTap: () => Navigator.pushNamed(context, '/apis'),
            ),
            Divider(color: Colors.grey[800]),
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
      hoverColor: Colors.orange.withOpacity(0.1),
    );
  }
}
