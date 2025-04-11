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
      drawer: menuDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(225, 112, 72, 51),
                  ),
                ),
                SizedBox(height: 15),
                CircleAvatar(
                  radius: 75,
                  backgroundImage: AssetImage('assets/bag.jpg'),
                ),
                SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Name: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'Nice lnwza\n'),
                      TextSpan(
                        text: 'Age: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '45\n'),
                      TextSpan(
                        text: 'Gender: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'Male\n'),
                      TextSpan(
                        text: 'Address: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '606-3727 Ullamcorper.\n'),
                      TextSpan(text: 'Street Roseville NH 11523'),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(225, 112, 72, 51),
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
