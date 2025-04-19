import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class menuDrawer extends StatelessWidget {
  Future<void> _logOut(BuildContext context) async {
    const url = "https://energy-rewards.onrender.com/api/signOut";
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
        "/LoginGateWay",
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
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pushNamed(context, "/Dashboard");
              },
            ),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: Icon(Icons.add_circle_outline),
              title: Text('Behavior Management'),
              onTap: () {
                Navigator.pushNamed(context, "/allUserBehavior");
              },
            ),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: Icon(Icons.star),
              title: Text('Rewards Management'),
              onTap: () {
                Navigator.pushNamed(context, "/allRewards");
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
