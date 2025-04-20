import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:clean_energy_rewards/pages/components/sideBar.dart';
import 'package:clean_energy_rewards/pages/components/navBar.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  int _selectedIndex = 3;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> _fetchUserInfo() async {
    final userId = await _getUserId();
    if (userId == null) return;

    final url = "http://10.0.2.2:4001/api/getInfo/$userId";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        setState(() {
          _userData = decoded['data'];
        });
      } else {
        print("Failed to load user info: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }

  Widget _buildUserInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(value ?? '', style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? firstName = _userData?['firstname'];
    final String? lastName = _userData?['lastname'];

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: menuDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(225, 112, 72, 51),
                  ),
                ),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      _userData?['imagePath'] != null && _userData?['imagePath']
                          ? NetworkImage(_userData?['imagePath'])
                          : const AssetImage('assets/null_profile.jpg')
                              as ImageProvider,
                  onBackgroundImageError: (_, __) {},
                ),

                const SizedBox(height: 25),
                _buildUserInfoRow("Name", "$firstName $lastName"),
                _buildUserInfoRow("Email", _userData?['email']),
                _buildUserInfoRow("Telephone", _userData?['tel_number']),
                _buildUserInfoRow("Address", _userData?['address']),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
