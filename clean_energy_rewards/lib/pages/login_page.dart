import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for capturing email and password input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // You can also add a loading indicator state if needed.
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
            EmailInput(controller: _emailController),
            const SizedBox(height: 15),
            PasswdInput(controller: _passwordController),
            const SizedBox(height: 25),
            SignInBtn(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                // Call loginUser function from api_server.dart

                setState(() {});
              },
            ),
            RegisterRedirect(context),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
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

TextField EmailInput({required TextEditingController controller}) {
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
