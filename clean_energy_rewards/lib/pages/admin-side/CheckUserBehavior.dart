import 'package:flutter/material.dart';
import 'package:clean_energy_rewards/pages/components/sideBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/navBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';
import 'package:clean_energy_rewards/pages/model_for_test/behavior_model.dart';
import 'package:clean_energy_rewards/pages/user-side/add_new_beh.dart';

class Checkuserbehavior extends StatefulWidget {
  @override
  State<Checkuserbehavior> createState() => _CheckuserbehaviorState();
}

class _CheckuserbehaviorState extends State<Checkuserbehavior> {
  int _selectedIndex = 1;
  List<BehaviorModel> behavior = [];
  List<BehaviorModel> filteredBehavior = [];
  TextEditingController searchController = TextEditingController();
  String? statusFilter;
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _getBehavior();
  }

  void _getBehavior() {
    setState(() {
      behavior = BehaviorModel.getBehaviors();
      filteredBehavior = behavior;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _filterBehaviors() {
    setState(() {
      filteredBehavior =
          behavior.where((item) {
            final matchesSearch = item.name.toLowerCase().contains(
              searchController.text.toLowerCase(),
            );

            final matchesStatus =
                statusFilter == null ||
                item.status.toLowerCase() == statusFilter!.toLowerCase();

            return matchesSearch && matchesStatus;
          }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      searchController.clear();
      statusFilter = null;
      filteredBehavior = behavior;
      _isSearchExpanded = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return const Color.fromARGB(216, 76, 175, 79);
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return const Color.fromARGB(255, 251, 250, 248);
    }
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
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "User Behavior",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 82, 49, 31),
                          ),
                        )
                      ],
                    ),
                    // Behavior Cards
                    if (filteredBehavior.isEmpty)
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
                              'No matching behaviors found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            if (searchController.text.isNotEmpty ||
                                statusFilter != null)
                              TextButton(
                                onPressed: _resetFilters,
                                child: Text('Clear all filters'),
                              ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children:
                            filteredBehavior.map((item) {
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
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    item.iconPath,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'Date: ${item.date}',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            27,
                                                            23,
                                                            23,
                                                          ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              _getStatusColor(
                                                                item.status,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          item.status
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              Icons.edit,
                                                              size: 18,
                                                            ),
                                                            padding:
                                                                EdgeInsets.zero,
                                                            constraints:
                                                                BoxConstraints(),
                                                            iconSize: 18,
                                                            color: Colors.blue,
                                                          ),
                                                          IconButton(
                                                            onPressed: () {},
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
