import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';
import 'package:clean_energy_rewards/pages/components/navBar.dart';
import 'package:clean_energy_rewards/pages/components/sideBar.dart';
import 'package:clean_energy_rewards/pages/model_for_test/reward_model.dart';

class RewardHistory extends StatefulWidget {
  const RewardHistory({super.key});

  @override
  State<RewardHistory> createState() => _RewardHistoryState();
}

class _RewardHistoryState extends State<RewardHistory> {
  List<RewardModel> allRewards = [];
  List<RewardModel> displayedRewards = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<List<RewardModel>> getRewards(String userId) async {
    final url = Uri.parse('http://127.0.0.1:4001/api/reward_history/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List rewards = data['data'];
        return rewards.map((json) => RewardModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reward history');
      }
    } catch (e) {
      print('Error fetching rewards: $e');
      return [];
    }
  }

  void _loadRewards() async {
    setState(() => isLoading = true);
    final userId = await getUserId();
    if (userId != null) {
      final loadedRewards = await getRewards(userId);
      setState(() {
        allRewards = loadedRewards;
        isLoading = false;
        _applyFilters();
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void _applyFilters() {
    List<RewardModel> filtered =
        allRewards.where((reward) {
          return searchQuery.isEmpty ||
              reward.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              reward.total_point.toString().contains(searchQuery);
        }).toList();

    setState(() {
      displayedRewards = filtered;
    });
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(rawDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: menuDrawer(),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : allRewards.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Your Rewards History",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 82, 49, 31),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Showing ${displayedRewards.length}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                              _applyFilters();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search rewards...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 142, 180, 134),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children:
                            displayedRewards
                                .map((reward) => _buildRewardCard(reward))
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: null,
        onItemTapped: null,
      ),
    );
  }

  Widget _buildRewardCard(RewardModel reward) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                reward.iconPath,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                errorBuilder:
                    (_, __, ___) => const Icon(Icons.broken_image, size: 60),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset(
                        'assets/Energy_Coin.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Points: ${reward.total_point}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Exchanged on: ${_formatDate(reward.exchangeDate)}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No rewards available',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: _loadRewards, child: const Text('Refresh')),
        ],
      ),
    );
  }
}
