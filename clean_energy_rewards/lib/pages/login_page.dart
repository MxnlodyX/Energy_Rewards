import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      const url = "http://192.168.56.1:4001/api/userLogin";
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        _showSuccessSnackbar();
        Navigator.pushNamed(context, "/userhomePage");
        final data = json.decode(response.body);
        final user_id = data['user_id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user_id.toString());
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
    } finally {
      setState(() => _isLoading = false);
    }
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
                "SIGN IN",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    EmailInput(controller: _emailController),
                    const SizedBox(height: 15),
                    PasswdInput(controller: _passwordController),
                    const SizedBox(height: 25),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _signIn();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            142,
                            180,
                            134,
                          ),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 70,
                            vertical: 15,
                          ),
                        ),
                        label: const Text(
                          "SIGN IN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        icon: const Icon(Icons.login),
                      ),
                    ),
                  ],
                ),
              ),

              RegisterRedirect(context),
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
              if (_isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}

Center RegisterRedirect(BuildContext context) {
  return Center(
    child: Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/register_page');
            },
            child: const Text(
              " Sign up",
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

TextFormField PasswdInput({required TextEditingController controller}) {
  return TextFormField(
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
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your password';
      } else if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
      return null; // Return null when validation is successful
    },
  );
}

TextFormField EmailInput({required TextEditingController controller}) {
  return TextFormField(
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
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your email';
      } else if (!RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
      ).hasMatch(value)) {
        return 'Please enter a valid email address';
      }
      return null; // Return null when validation is successful
    },
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
