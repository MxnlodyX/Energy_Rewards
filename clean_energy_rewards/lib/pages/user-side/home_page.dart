import 'package:clean_energy_rewards/pages/user-side/how_to_use.dart';
import 'package:flutter/material.dart';
import 'package:clean_energy_rewards/pages/components/sideBar.dart';
import 'package:clean_energy_rewards/pages/components/navBar.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';
import 'package:clean_energy_rewards/pages/model_for_test/reward_model.dart';
import 'dart:math';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class userHomepage extends StatefulWidget {
  const userHomepage({super.key});

  @override
  State<userHomepage> createState() => _userHomepageState();
}

class _userHomepageState extends State<userHomepage> {
  int _selectedIndex = 0;
  List<RewardModel> rewards = [];
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _getRewards();
    _userInfomation();
  }

  void _getRewards() {
    setState(() {
      rewards = RewardModel.getRewards();
    });
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> _userInfomation() async {
    String? id = await getUserId();
    final url = "http://192.168.56.1:4001/api/getInfo/$id";
    try {
      var response = await http.get(
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
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }

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
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF5D8A66), // Green
                      Color(0xFFA5D6A7), // Light Green
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(text: "Welcome "),
                          TextSpan(
                            text: _userData?['firstname'],
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                          TextSpan(text: "\nLet's save the world with\n"),
                          TextSpan(
                            text: "Clean Energy Rewards",
                            style: TextStyle(
                              fontSize: 22,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.eco, color: Colors.white, size: 16),
                        SizedBox(width: 5),
                        Text(
                          "Supporting SGD 7: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFC8E6C9), Color(0xFFF1F8E9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(
                        255,
                        248,
                        186,
                        153,
                      ).withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "YOUR ENERGY POINTS",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 82, 49, 31),
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),

                          child: Image.asset(
                            'assets/Energy_Coin.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          (_userData?['total_point'] ?? 0).toString(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 82, 49, 31),
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// **แก้ไขการแสดง Reward**
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.38,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'LATEST REWARDS',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 82, 49, 31),
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/allReward");
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "See All",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                            255,
                                            82,
                                            49,
                                            31,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: Color.fromARGB(255, 82, 49, 31),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              separatorBuilder:
                                  (context, index) => SizedBox(width: 16),
                              itemCount: min(4, rewards.length),
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/detailReward",
                                      arguments: rewards[index],
                                    );
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 350,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Color.fromARGB(
                                          255,
                                          82,
                                          49,
                                          31,
                                        ).withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Image with rounded top corners
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                          child: Image.asset(
                                            rewards[index].iconPath,
                                            height: 110,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter,
                                          ),
                                        ),
                                        // Reward details
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                rewards[index].name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                    255,
                                                    82,
                                                    49,
                                                    31,
                                                  ),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.amber[100],
                                                    ),
                                                    child: Image.asset(
                                                      'assets/Energy_Coin.png',
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "${rewards[index].total_point} points",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color.fromARGB(
                                                        255,
                                                        82,
                                                        49,
                                                        31,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                    255,
                                                    82,
                                                    49,
                                                    31,
                                                  ).withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  "See Detail",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color.fromARGB(
                                                      255,
                                                      82,
                                                      49,
                                                      31,
                                                    ),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => howToUse()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    color:
                        Colors.white, // Optional if you want a fallback color
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 82, 49, 31),
                        offset: Offset(0, 4),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/how_to_use.png',
                      ), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
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
