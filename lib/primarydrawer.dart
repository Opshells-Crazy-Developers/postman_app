import 'package:flutter/material.dart';

class PrimaryDrawer extends StatelessWidget {
  final double width;
  final Function(String) onItemSelected;
  final String selectedItem;

  const PrimaryDrawer({super.key, 
    required this.width,
    required this.onItemSelected,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Drawer(
        child: Builder( // Wrap with Builder here too
          builder: (BuildContext context) {
            return Container(
              color: Colors.grey[900],
              child: Column(
                children: [
                  SizedBox(height: 60),
                  DrawerIconButton(
                    icon: Icons.web,
                    isSelected: selectedItem == 'web',
                    onTap: () {
                      onItemSelected('web');
                      Navigator.pop(context); // Close the primary drawer
                    },
                  ),
                  // ... Rest of your drawer items with the same pattern
                  DrawerIconButton(
                    icon: Icons.crop_landscape_outlined,
                    isSelected: selectedItem == 'workspace',
                    onTap: () {
                      onItemSelected('workspace');
                      Navigator.pop(context);
                    },
                  ),
                  // ... Add all other drawer items following the same pattern
                  Spacer(),
                  DrawerIconButton(
                    icon: Icons.help_outline,
                    isSelected: selectedItem == 'help',
                    onTap: () {
                      onItemSelected('help');
                      Navigator.pop(context);
                    },
                  ),
                  DrawerIconButton(
                    icon: Icons.settings_outlined,
                    isSelected: selectedItem == 'settings',
                    onTap: () {
                      onItemSelected('settings');
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class DrawerIconButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerIconButton({super.key, 
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isSelected ? Colors.orange : Colors.white,
        ),
        onPressed: onTap,
      ),
    );
  }
}
