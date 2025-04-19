import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:clean_energy_rewards/pages/components/sideBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/navBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  int _selectedIndex = 0;
  int totalEnergyReward = 0;
  int totalUserBehavior = 0;
  int totalUserAccount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse('https://energy-rewards.onrender.com/admin_dashboard_stats'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalEnergyReward = data['total_energy_rewards'];
          totalUserBehavior = data['total_user_behavior'];
          totalUserAccount = data['total_user_account'];
          isLoading = false;
        });
      } else {
        print("Error fetching data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching dashboard data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: menuDrawer(),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "       Clean Energy Dashboard",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 82, 49, 31),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      buildCard(
                        color: Color(0xFFEB5E55),
                        icon: Icons.stars,
                        title: "Total Energy Reward",
                        value: "$totalEnergyReward pieces",
                        shadowColor: Colors.red,
                      ),
                      SizedBox(height: 25),
                      buildCard(
                        color: Color(0xFFFF8F57),
                        icon: Icons.add_circle_outline,
                        title: "Total User Behavior",
                        value: "$totalUserBehavior times",
                        shadowColor: Colors.orange,
                      ),
                      SizedBox(height: 25),
                      buildCard(
                        color: Color(0xFF6ECF8B),
                        icon: Icons.account_circle_sharp,
                        title: "Total User Account",
                        value: "$totalUserAccount Account",
                        shadowColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: BottomNavBar(selectedIndex: _selectedIndex),
    );
  }

  Widget buildCard({
    required Color color,
    required IconData icon,
    required String title,
    required String value,
    required Color shadowColor,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(icon, size: 50, color: Colors.white),
          SizedBox(width: 20),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.4,
              ),
              children: [
                TextSpan(text: "$title\n", style: TextStyle(fontSize: 20)),
                TextSpan(
                  text: value,
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
        ],
      ),
    );
  }
}
