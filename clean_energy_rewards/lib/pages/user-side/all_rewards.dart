import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  void _getRewards() {
    setState(() {
      rewards = RewardModel.getRewards();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getRewards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.9,
            color: Colors.red,
          ),
        ),
      ),
      drawer: menuDrawer(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
