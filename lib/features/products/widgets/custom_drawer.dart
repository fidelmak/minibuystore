import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String profileImage;
  final String userName;
  final List<DrawerItem> items;
  final Function(int) onItemSelected;

  const CustomDrawer({
    super.key,
    required this.profileImage,
    required this.userName,
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFF17547)),
            accountName: Text(userName),
            accountEmail: Text('user@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(profileImage),
            ),
          ),
          ...items.map(
            (item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.label),
              onTap: () => onItemSelected(item.index),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem {
  final String label;
  final IconData icon;
  final int index;

  DrawerItem({required this.label, required this.icon, required this.index});
}
