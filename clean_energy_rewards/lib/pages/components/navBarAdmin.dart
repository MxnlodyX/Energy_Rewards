import 'package:clean_energy_rewards/pages/admin-side/admin_homepage.dart';
import 'package:flutter/material.dart';
import 'package:clean_energy_rewards/pages/admin-side/CheckUserBehavior.dart';
import 'package:clean_energy_rewards/pages/admin-side/Rewardmanagement.dart';

class BottomNavBar extends StatelessWidget {
  final int? selectedIndex;
  final Function(int)? onItemTapped;

  const BottomNavBar({Key? key, this.selectedIndex, this.onItemTapped})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: const Color.fromARGB(228, 82, 49, 31),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context: context,
            index: 0,
            icon: Icons.home,
            label: 'Home',
            destination: AdminHomepage(),
          ),
          _buildNavItem(
            context: context,
            index: 1,
            icon: Icons.add_circle_outline,
            label: 'Behavior',
            destination: Checkuserbehavior(),
          ),
          _buildNavItem(
            context: context,
            index: 2,
            icon: Icons.stars,
            label: 'Rewards',
            destination: Rewardmanagement(),
          ),
          _buildNavItem(
            context: context,
            index: 3,
            icon: Icons.person,
            label: 'Profile',
            destination: AdminHomepage(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    Widget? destination,
  }) {
    final bool isSelected = selectedIndex == index;
    final Color activeColor = const Color.fromARGB(255, 255, 184, 148);
    final Color inactiveColor = Colors.white;

    return GestureDetector(
      onTap: () {
        onItemTapped?.call(index);
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? activeColor : inactiveColor, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : inactiveColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
