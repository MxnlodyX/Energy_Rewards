import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

Future<Map<String, dynamic>?> registerUser({
  required String fullname,
  required String email,
  required String password,
  required String address,
  required String tel,
}) async {
  final url = Uri.parse('http://10.0.2.2:3000/register');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullname': fullname,
        'email': email,
        'password': password,
        'address': address,
        'tel': tel,
      }),
    );

    if (response.statusCode == 201) {
      // Decode the JSON into a Map
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('Error during registration: ${response.body}');
      return null;
    }
  } catch (error) {
    print('Exception during registration: $error');
    return null;
  }
}

Future<UserCredential?> loginUser({
  required String email,
  required String password,
}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  } on FirebaseAuthException catch (e) {
    print('Error during login: ${e.message}');
    return null;
  }
}
