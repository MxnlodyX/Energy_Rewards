import 'package:clean_energy_rewards/pages/login_page.dart';
import 'package:flutter/material.dart';

class LoginGateway extends StatefulWidget {
  const LoginGateway({super.key});

  @override
  State<LoginGateway> createState() => _LoginGatewayState();
}

class _LoginGatewayState extends State<LoginGateway> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            LogoApp(),
            Text(
              "Log in using your account on :",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  padding: EdgeInsets.all(16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.black),
                    SizedBox(width: 15),
                    Text(
                      'User Account',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed((context), '/AdminLoginPage');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 142, 180, 134),
                  padding: EdgeInsets.all(16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    SizedBox(width: 15),
                    Text(
                      'Instructor Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Center LogoApp() {
  return Center(
    child: CircleAvatar(
      backgroundImage: const AssetImage("assets/Logo/Logo.png"),
      radius: 110,
      backgroundColor: Colors.white,
    ),
  );
}
