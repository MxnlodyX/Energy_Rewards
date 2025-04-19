import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class AddminLoginPage extends StatefulWidget {
  const AddminLoginPage({super.key});

  @override
  State<AddminLoginPage> createState() => _AddminLoginPageState();
}

class _AddminLoginPageState extends State<AddminLoginPage> {
  final TextEditingController _adminEmail = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _adminEmail.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    try {
      const url = "https://energy-rewards.onrender.com/api/adminLogin";
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'admin_email': _adminEmail.text,
          'admin_password': _passwordController.text,
        }),
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        _showSuccessSnackbar();
        final adminId = jsonResponse['admin_id'];
        final adminEmail = jsonResponse['admin_email'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('admin_id', adminId.toString());
        await prefs.setString('admin_email', adminEmail);
        Navigator.pushNamed(context, "/Dashboard");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonResponse['error'] ?? 'Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {}
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login successfully!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Color.fromARGB(255, 142, 180, 134),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LogoApp(),
              const SizedBox(height: 25),
              const Text(
                "Admin Sign In",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              AdminID_Input(controller: _adminEmail),
              const SizedBox(height: 15),
              PasswdInput(controller: _passwordController),
              const SizedBox(height: 25),
              SignInBtn(
                onPressed: () {
                  _signIn();
                },
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Do you need back to Gateway?",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/LoginGateWay');
                        },
                        child: const Text(
                          " Tap here",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 47, 66, 151),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Center SignInBtn({required VoidCallback onPressed}) {
  return Center(
    child: ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 142, 180, 134),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
      ),
      label: const Text(
        "SIGN IN",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      icon: const Icon(Icons.login),
    ),
  );
}

TextField PasswdInput({required TextEditingController controller}) {
  return TextField(
    controller: controller,
    obscureText: true,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 142, 180, 134),
          width: 2,
        ),
      ),
      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
      hintText: 'Enter your Password',
    ),
  );
}

TextField AdminID_Input({required TextEditingController controller}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 142, 180, 134),
          width: 2,
        ),
      ),
      prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
      hintText: 'Enter your Email',
    ),
  );
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
