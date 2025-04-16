import 'package:flutter/material.dart';

class menuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 142, 180, 134),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('Homepage'),
            onTap: () {
              Navigator.pushNamed(context, '/page1');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('My Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/page2');
            },
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text('User behavior'),
            onTap: () {
              Navigator.pushNamed(context, '/page3');
            },
          ),
          ListTile(
            leading: Icon(Icons.stars),
            title: Text('Reward Management'),
            onTap: () {
              Navigator.pushNamed(context, '/page4');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushNamed(context, '/LoginPage');
            },
          ),
        ],
      ),
    );
  }
}
