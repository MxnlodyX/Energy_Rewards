import 'dart:convert';
import 'package:clean_energy_rewards/pages/admin-side/CheckUserBehavior.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:clean_energy_rewards/pages/components/sideBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/navBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';

class ConfirmBehavior extends StatefulWidget {
  @override
  State<ConfirmBehavior> createState() => _ConfirmBehaviorState();
}

class _ConfirmBehaviorState extends State<ConfirmBehavior> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _behaviorController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _existingImageUrl;
  String? _behaviorId;
  String? _selectedStatus;
  final TextEditingController _pointController = TextEditingController();

  @override
  void dispose() {
    _behaviorController.dispose();
    _dateController.dispose();
    _pointController.dispose(); // add this
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _behaviorId = args['behavior_id']?.toString();

    if (_behaviorId != null) {
      _loadBehaviorDetail();
    }
  }

  Future<void> _loadBehaviorDetail() async {
    final url =
        "https://energy-rewards.onrender.com/api/get_behavior_id/$_behaviorId";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final behavior = data['data'];

        setState(() {
          _behaviorController.text = behavior['behavior_description'] ?? '';
          _dateController.text = behavior['behavior_date'] ?? '';
          if (behavior['image_path'] != null && behavior['image_path'] != '') {
            _existingImageUrl =
                "https://energy-rewards.onrender.com/${behavior['image_path']}"
                    .replaceAll('\\', '/');
          }
        });
      } else {
        print('Failed to load behavior detail: ${response.body}');
      }
    } catch (e) {
      print("Error loading behavior detail: $e");
    }
  }

  Future<void> _confirmBehavior() async {
    if (!_formKey.currentState!.validate()) return;

    final url =
        "https://energy-rewards.onrender.com/api/verify_behavior/$_behaviorId";

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "behavior_status": _selectedStatus,
          "total_point": int.tryParse(_pointController.text),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Behavior verified successfully!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Checkuserbehavior()),
        );
      } else {
        print("Verify failed: ${response.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(),
      drawer: menuDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 135),
            width: MediaQuery.of(context).size.width * 0.85,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 82, 49, 31),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Confirm Behavior",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "How do you use clean energy?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: Text(
                        _behaviorController.text,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text(
                      "On which date?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: Text(
                        _dateController.text,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text(
                      "Behavior image:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100],
                        image:
                            _existingImageUrl != null
                                ? DecorationImage(
                                  image: NetworkImage(_existingImageUrl!),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Behavior Status:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      items:
                          ['success', 'pending', 'rejected'].map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(
                                status[0].toUpperCase() + status.substring(1),
                              ),
                            );
                          }).toList(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 142, 180, 134),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select status';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),
                    const Text(
                      "Total Point:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _pointController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 142, 180, 134),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter point';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              164,
                              116,
                              106,
                              106,
                            ),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Checkuserbehavior(),
                              ),
                            );
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              142,
                              180,
                              134,
                            ),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _confirmBehavior,
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: null,
        onItemTapped: null,
      ),
    );
  }
}
