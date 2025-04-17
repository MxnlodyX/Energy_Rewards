import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class menuDrawer extends StatelessWidget {
  Future<void> _logOut(BuildContext context) async {
    const url = "http://127.0.0.1:4001/api/signOut";
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout Successfully!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Color.fromARGB(255, 142, 180, 134),
        ),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/LoginPage",
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logout failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 82, 62, 55),
        child: ListView(
          padding: EdgeInsets.only(top: 150),
          children: [
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: Icon(Icons.home),
              title: Text('Homepage'),
              onTap: () {
                Navigator.pushNamed(context, "/userhomePage");
              },
            ),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: Icon(Icons.business),
              title: Text('My Behavior'),
              onTap: () {
                Navigator.pushNamed(context, "/userBehaviorPage");
              },
            ),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: Icon(Icons.star),
              title: Text('Rewards'),
              onTap: () {
                Navigator.pushNamed(context, "/allReward");
              },
            ),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, "/userInfo");
              },
            ),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign out'),
              onTap: () async {
                await _logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
