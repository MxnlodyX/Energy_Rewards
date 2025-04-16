import 'package:flutter/material.dart';
//Gateway
import 'package:clean_energy_rewards/pages/choose_lg_type.dart';
import 'package:clean_energy_rewards/pages/login_page.dart';
import 'package:clean_energy_rewards/pages/add_login_page.dart';
import 'package:clean_energy_rewards/pages/register_page.dart';
//user-side
//navbar-page
import 'package:clean_energy_rewards/pages/user-side/home_page.dart';
import 'package:clean_energy_rewards/pages/user-side/user_behavior.dart';
import 'package:clean_energy_rewards/pages/user-side/all_rewards.dart';
import 'package:clean_energy_rewards/pages/user-side/user_info.dart';
//
import 'package:clean_energy_rewards/pages/user-side/how_to_use.dart';
import 'package:clean_energy_rewards/pages/user-side/reward_history.dart';

//user-action-page
import 'package:clean_energy_rewards/pages/user-side/add_new_beh.dart';
import 'package:clean_energy_rewards/pages/user-side/edit_beh.dart';
import 'package:clean_energy_rewards/pages/user-side/detail_reward.dart';

//admin-side
import 'package:clean_energy_rewards/pages/admin-side/admin_homepage.dart';

void main() async {
  runApp(CleanEnergy());
}

class CleanEnergy extends StatelessWidget {
  const CleanEnergy({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Energy Rewards',
      initialRoute: '/LoginGateWay',
      routes: {
        //Entry gateway
        '/LoginGateWay': (context) => LoginGateway(),
        '/LoginPage': (context) => LoginPage(),
        '/AdminLoginPage': (context) => AddminLoginPage(),
        '/register_page': (context) => RegisterPage(),
        //userSide
        '/userhomePage': (context) => userHomepage(),
        '/userBehaviorPage': (context) => UserBehavior(),
        '/allReward': (context) => AllRewards(),
        '/userInfo': (context) => UserInfo(),
        '/howtousePage': (context) => howToUse(),
        '/rewardHistory': (context) => RewardHistory(),
        //userActionPage
        '/addNewBehavior': (context) => addBehavior(),
        '/editBehavior': (context) => EditBehavior(),
        '/detailReward': (context) => DetailReward(),
        //adminSide
        '/Dashboard': (context) => AdminHomepage(),
      },
    );
  }
}
