import 'package:flutter/material.dart';
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

  void _getRewards() {
    rewards = RewardModel.getRewards();
    filteredRewards = rewards;
    setState(() {});
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
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Reward 100 ", // ค่านี้อาจจะเชื่อมต่อกับฐานข้อมูลหรือ API
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
                      padding: EdgeInsets.all(10),
                    ),
                    child: Text(
                      'Reward History',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your Point: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(225, 112, 72, 51),
                    ),
                  ),
                  Image.asset('assets/Energy_Coin.png', width: 45, height: 45),
                  Text(
                    " 2500", // ค่านี้อาจจะใช้ตัวแปรจากฐานข้อมูลหรือ API
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(225, 112, 72, 51),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(rewards[index].iconPath),
                          fit: BoxFit.cover,
                        ),
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
                      Image(
                        image: AssetImage('assets/Energy_Coin.png'),
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        " " + rewards[index].total_point.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
