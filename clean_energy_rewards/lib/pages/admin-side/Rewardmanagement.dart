import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clean_energy_rewards/pages/components/sideBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/navBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';
import 'package:clean_energy_rewards/pages/admin-side/add_new_reward.dart';
import 'package:clean_energy_rewards/pages/model_for_test/reward_model.dart';
import 'package:http/http.dart' as http;

class Rewardmanagement extends StatefulWidget {
  @override
  State<Rewardmanagement> createState() => _RewardmanagementState();
}

class _RewardmanagementState extends State<Rewardmanagement> {
  int _selectedIndex = 2;
  List<RewardModel> rewards = [];

  @override
  void initState() {
    super.initState();
    _getRewards();
  }

  Future<void> _getRewards() async {
    final url = "https://energy-rewards.onrender.com/api/get_rewards";
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
        final List<dynamic> data = decoded['data'];
        setState(() {
          rewards = data.map((json) => RewardModel.fromJson(json)).toList();
        });
      } else {
        print("Failed to load rewards: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching rewards: $error");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _deleteReward(String behaviorId) async {
    final url =
        "https://energy-rewards.onrender.com/api/delete_reward/$behaviorId";

    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        _showDeleteSnackBar(context);
        _getRewards();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Delete failed: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting behavior: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Delete successfully!'),
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
      appBar: CustomAppBar(),
      drawer: menuDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "All Reward",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 82, 49, 31),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNewReward(),
                              ),
                            );
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              224,
                              82,
                              49,
                              31,
                            ),
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon(Icons.add, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    if (rewards.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No rewards found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children:
                            rewards.map((item) {
                              return Card(
                                color: Colors.white,
                                margin: EdgeInsets.only(bottom: 16),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            item.iconPath,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                          ),
                                        ),

                                        SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              SizedBox(height: 4),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                          4,
                                                        ),

                                                        child: Image.asset(
                                                          'assets/Energy_Coin.png',
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        "${item.total_point} points",
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
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                            context,
                                                            '/editRewards',
                                                            arguments: {
                                                              'reward_id':
                                                                  item.id
                                                                      .toString(),
                                                            },
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.edit,
                                                          size: 18,
                                                          color: Colors.blue,
                                                        ),
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            BoxConstraints(),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (
                                                              BuildContext
                                                              context,
                                                            ) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                  "Confirm Delete",
                                                                ),

                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () => Navigator.pop(
                                                                          context,
                                                                        ),
                                                                    child: Text(
                                                                      "Cancel",
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () async {
                                                                      Navigator.pop(
                                                                        context,
                                                                      );
                                                                      await _deleteReward(
                                                                        item.id
                                                                            .toString(),
                                                                      );
                                                                    },

                                                                    child: Text(
                                                                      "Confirm",
                                                                      style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                          255,
                                                                          248,
                                                                          71,
                                                                          71,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          size: 18,
                                                        ),
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            BoxConstraints(),
                                                        iconSize: 18,
                                                        color: Colors.red,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
