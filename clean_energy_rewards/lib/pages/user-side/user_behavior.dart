import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:clean_energy_rewards/pages/components/sideBar.dart';
import 'package:clean_energy_rewards/pages/components/navBar.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';
import 'package:clean_energy_rewards/pages/model_for_test/behavior_model.dart';
import 'package:clean_energy_rewards/pages/user-side/add_new_beh.dart';

class UserBehavior extends StatefulWidget {
  @override
  State<UserBehavior> createState() => _UserBehaviorState();
}

class _UserBehaviorState extends State<UserBehavior> {
  int _selectedIndex = 1;
  List<BehaviorModel> behavior = [];
  List<BehaviorModel> filteredBehavior = [];
  TextEditingController searchController = TextEditingController();
  String? statusFilter;
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _getUserBehavior();
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

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> _getUserBehavior() async {
    String? id = await getUserId();
    final url = "https://energy-rewards.onrender.com/api/get_behavior/$id";
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
          behavior = data.map((json) => BehaviorModel.fromJson(json)).toList();
          filteredBehavior = behavior;
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Exception caught: $error");
    }
  }

  Future<void> _deleteBehavior(String behaviorId) async {
    final url =
        "https://energy-rewards.onrender.com/api/delete_behavior/$behaviorId";

    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        _showDeleteSnackBar(context);
        _getUserBehavior();
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
                          "Your Behavior History",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 82, 49, 31),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _isSearchExpanded ? Icons.close : Icons.search,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSearchExpanded = !_isSearchExpanded;
                                  if (!_isSearchExpanded) {
                                    _resetFilters();
                                  }
                                });
                              },
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => addBehavior(),
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
                              icon: Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_isSearchExpanded) ...[
                      SizedBox(height: 16),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Search Field
                                TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    hintText: 'Search by name...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    suffixIcon:
                                        searchController.text.isNotEmpty
                                            ? IconButton(
                                              icon: Icon(Icons.clear),
                                              onPressed: () {
                                                searchController.clear();
                                                _filterBehaviors();
                                              },
                                            )
                                            : null,
                                  ),
                                  onChanged: (value) => _filterBehaviors(),
                                ),
                                SizedBox(height: 12),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Filter by status:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        FilterChip(
                                          label: Text('All'),
                                          selected: statusFilter == null,
                                          onSelected: (selected) {
                                            setState(() {
                                              statusFilter = null;
                                              _filterBehaviors();
                                            });
                                          },
                                        ),
                                        FilterChip(
                                          label: Text('Success'),
                                          selected: statusFilter == 'success',
                                          onSelected: (selected) {
                                            setState(() {
                                              statusFilter = 'success';
                                              _filterBehaviors();
                                            });
                                          },
                                          selectedColor: _getStatusColor(
                                            'success',
                                          ),
                                          backgroundColor: _getStatusColor(
                                            'success',
                                          ).withOpacity(0.1),
                                          labelStyle: TextStyle(
                                            color:
                                                statusFilter == 'success'
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                        FilterChip(
                                          label: Text('Pending'),
                                          selected: statusFilter == 'pending',
                                          onSelected: (selected) {
                                            setState(() {
                                              statusFilter = 'pending';
                                              _filterBehaviors();
                                            });
                                          },
                                          selectedColor: _getStatusColor(
                                            'pending',
                                          ),
                                          backgroundColor: _getStatusColor(
                                            'pending',
                                          ).withOpacity(0.1),
                                          labelStyle: TextStyle(
                                            color:
                                                statusFilter == 'pending'
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                        FilterChip(
                                          label: Text('Rejected'),
                                          selected: statusFilter == 'rejected',
                                          onSelected: (selected) {
                                            setState(() {
                                              statusFilter = 'rejected';
                                              _filterBehaviors();
                                            });
                                          },
                                          selectedColor: _getStatusColor(
                                            'rejected',
                                          ),
                                          backgroundColor: _getStatusColor(
                                            'rejected',
                                          ).withOpacity(0.1),
                                          labelStyle: TextStyle(
                                            color:
                                                statusFilter == 'rejected'
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                if (searchController.text.isNotEmpty ||
                                    statusFilter != null)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: _resetFilters,
                                      child: Text(
                                        'Reset Filters',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 16),
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
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  item.iconPath,
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
                                                  SizedBox(height: 4),
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
                                                  if (item.status
                                                          .toLowerCase() ==
                                                      'success') ...[
                                                    SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          size: 16,
                                                          color: Colors.amber,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          'Earned ${item.total_point} points',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Color.fromARGB(
                                                                  255,
                                                                  59,
                                                                  101,
                                                                  34,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
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
                                                            onPressed: () {
                                                              Navigator.pushNamed(
                                                                context,
                                                                '/editBehavior',
                                                                arguments: {
                                                                  'behavior_id':
                                                                      item.id,
                                                                },
                                                              );
                                                            },
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
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
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
                                                                          await _deleteBehavior(
                                                                            item.id.toString(),
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
