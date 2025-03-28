import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:clean_energy_rewards/pages/components/sideBar.dart';
import 'package:clean_energy_rewards/pages/components/navBar.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  var _selectedIndex = 3;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: [
                Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 82, 49, 31),
                  ),
                ),
                SizedBox(height: 15),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/bag.jpg'),
                ),
                SizedBox(height: 15),

                Text(
                  "Navadol Somboonkul",
                  style: TextStyle(
                    fontSize: 19,
                    color: Color.fromARGB(255, 82, 49, 31),
                  ),
                ),
                SizedBox(height: 15),

                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: const Color.fromARGB(255, 61, 143, 65),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 45, 110, 56),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
