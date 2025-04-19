import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clean_energy_rewards/pages/components/appBar.dart';
import 'package:clean_energy_rewards/pages/components/navBar.dart';
import 'package:clean_energy_rewards/pages/components/sideBar.dart';
import 'package:clean_energy_rewards/pages/user-side/user_behavior.dart';

class addBehavior extends StatefulWidget {
  @override
  State<addBehavior> createState() => _addBehaviorState();
}

class _addBehaviorState extends State<addBehavior> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _behaviorController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  File? _imageFile;
  bool _isSubmitting = false;
  bool _isPickerActive = false;

  Future<void> _pickDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> _pickImage() async {
    if (_isPickerActive) return;

    setState(() => _isPickerActive = true);

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isPickerActive = false);
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add New Behavior Successfully!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Color.fromARGB(255, 142, 180, 134),
      ),
    );
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> _addBehavior() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please upload an image')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      const url = "https://energy-rewards.onrender.com/api/add_behavior";
      String? userId = await getUserId();
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['behavior_description'] = _behaviorController.text;
      request.fields['behavior_date'] = _dateController.text;
      request.fields['user_id'] = userId ?? '';
      request.files.add(
        await http.MultipartFile.fromPath('image', _imageFile!.path),
      );
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        _showSuccessSnackbar();
        Navigator.pushNamed(context, "/userBehaviorPage");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonResponse['message'] ?? 'Add behavior failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _behaviorController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(),
      drawer: menuDrawer(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 135),
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.6,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Energy Record Form",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Behavior Description
                    const Text(
                      "How do you help reduce your impact on the environment?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _behaviorController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Example: Using EV Car",
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please describe your energy behavior';
                        }
                        return null;
                      },
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
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Tap to select date",
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    const Text(
                      "Upload your picture to prove",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.width * 0.3,
                              decoration:
                                  _imageFile != null
                                      ? BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(_imageFile!),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                      : null,
                              child:
                                  _imageFile == null
                                      ? const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image,
                                            color: Color.fromARGB(
                                              255,
                                              116,
                                              79,
                                              64,
                                            ),
                                            size: 40,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Choose a file here',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                255,
                                                116,
                                                79,
                                                64,
                                              ),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                      : null,
                            ),
                            if (_imageFile != null) ...[
                              const SizedBox(height: 10),
                              const Text(
                                'Image selected',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons
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
                                builder: (context) => UserBehavior(),
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
                          onPressed: _addBehavior,
                          child:
                              _isSubmitting
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text('Submit'),
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
