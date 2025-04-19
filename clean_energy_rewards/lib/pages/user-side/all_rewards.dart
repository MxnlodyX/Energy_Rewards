import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:clean_energy_rewards/pages/components/sideBar.dart';
import 'package:clean_energy_rewards/pages/components/navBar.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';
import 'package:clean_energy_rewards/pages/model_for_test/reward_model.dart';

class AllRewards extends StatefulWidget {
  const AllRewards({super.key});

  @override
  State<AllRewards> createState() => _AllRewardsState();
}

class _AllRewardsState extends State<AllRewards> {
  int _selectedIndex = 2;
  List<RewardModel> rewards = [];
  List<RewardModel> filteredRewards = [];

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _getRewards();
  }

  Future<void> _getRewards() async {
    final url = Uri.parse(
      "https://energy-rewards.onrender.com/api/get_rewards",
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> rewardsJson = jsonData['data'];

        rewards =
            rewardsJson.map((item) => RewardModel.fromJson(item)).toList();
        filteredRewards = rewards;
        setState(() {});
      } else {
        print("Failed to load rewards: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching rewards: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _filterRewards(String query) {
    setState(() {
      searchQuery = query;
      filteredRewards =
          rewards
              .where(
                (reward) =>
                    reward.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Reward ${filteredRewards.length} ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(225, 112, 72, 51),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/rewardHistory");
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 142, 180, 134),
                      padding: EdgeInsets.all(5),
                    ),
                    child: Text(
                      'Reward History',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                onChanged: (value) {
                  _filterRewards(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search rewards...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 142, 180, 134),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            if (filteredRewards.isEmpty)
              Expanded(child: _buildNoResultsFound())
            else
              Expanded(child: _buildReward(filteredRewards)),
          ],
        ),
      ),
      drawer: menuDrawer(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildReward(List<RewardModel> rewards) {
    return GridView.builder(
      padding: EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              "/detailReward",
              arguments: rewards[index],
            );
          },
          child: Card(
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        rewards[index].iconPath,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    rewards[index].name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                          color: Color.fromARGB(255, 82, 49, 31),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 82, 49, 31).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "See Detail",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 82, 49, 31),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildNoResultsFound() {
  return Padding(
    padding: const EdgeInsets.all(32.0),
    child: Column(
      children: [
        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'No rewards match your search',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      ],
    ),
  );
}
