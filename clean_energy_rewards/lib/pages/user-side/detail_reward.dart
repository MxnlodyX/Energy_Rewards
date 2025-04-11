import 'package:flutter/material.dart';
import 'package:clean_energy_rewards/pages/model_for_test/reward_model.dart';
import 'package:clean_energy_rewards/pages/components/sideBar.dart';
import 'package:clean_energy_rewards/pages/components/navBar.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';

class DetailReward extends StatefulWidget {
  const DetailReward({super.key});

  @override
  State<DetailReward> createState() => _DetailRewardState();
}

class _DetailRewardState extends State<DetailReward> {
  @override
  Widget build(BuildContext context) {
    final reward = ModalRoute.of(context)!.settings.arguments as RewardModel;

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: menuDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reward Image with Card and Shadow
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 24, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      reward.iconPath,
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              Text(
                reward.name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text("Quantity: 5", style: TextStyle(fontSize: 19)),
              const SizedBox(height: 8),
              Divider(color: Colors.black, thickness: 1),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/Energy_Coin.png', width: 45, height: 45),
                  Text(
                    " ${reward.total_point} ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(225, 112, 72, 51),
                    ),
                  ),
                  Text(
                    "Point Required ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(225, 112, 72, 51),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(context, reward),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, RewardModel reward) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          // Cancel Button
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Color.fromARGB(255, 142, 180, 134),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () => _showSimpleExchangeConfirmation(context, reward),
              child: const Text('Exchange Now'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSimpleExchangeConfirmation(
    BuildContext context,
    RewardModel reward,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Exchange"),
          content: Text(
            "Exchange ${reward.total_point} points for ${reward.name}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _showExchangeSuccessSnackbar(context);
                Navigator.pop(context); // Go back to previous screen
              },
              child: Text(
                "Confirm",
                style: TextStyle(color: Color.fromARGB(255, 142, 180, 134)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showExchangeSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reward exchanged successfully!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Color.fromARGB(255, 142, 180, 134),
      ),
    );
  }
}
