import 'package:flutter/material.dart';
import 'package:clean_energy_rewards/pages/components/sideBar.dart';
import 'package:clean_energy_rewards/pages/components/navBar.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';


class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: menuDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "     Clean Energy Dashboard",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 82, 49, 31),
                        letterSpacing: 1.2,
                      ),
                    ),
                    
                  ]
                  
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Color(0xFFEB5E55),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.stars, // เลือกไอคอนที่ต้องการ เช่น star
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20), // เพิ่มระยะห่างระหว่างไอคอนและข้อความ
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: "Total Energy Reward\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              TextSpan(
                                text: "150 pieces",
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
                    SizedBox(height: 5),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Color(0xFFFF8F57),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.add_circle_outline, // เลือกไอคอนที่ต้องการ เช่น star
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20), // เพิ่มระยะห่างระหว่างไอคอนและข้อความ
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: "Total User Behavior\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              TextSpan(
                                text: "59 times",
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
                    SizedBox(height: 5),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Color(0xFF6ECF8B),
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
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.account_circle_sharp, // เลือกไอคอนที่ต้องการ เช่น star
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20), // เพิ่มระยะห่างระหว่างไอคอนและข้อความ
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: "Total User Account\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              TextSpan(
                                text: "29 Account",
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
                    SizedBox(height: 5),
                  ],
                ),
              )
            ]  
      ),
        )
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}