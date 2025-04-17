import 'dart:convert';

import 'package:clean_energy_rewards/pages/admin-side/Rewardmanagement.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:clean_energy_rewards/pages/components/sideBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/navBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';

class AddNewReward extends StatefulWidget {
  @override
  State<AddNewReward> createState() => _AddNewRewardState();
}

class _AddNewRewardState extends State<AddNewReward> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _imageFile;
  bool _isSubmitting = false;
  bool _isPickerActive = false;

  Future<void> _pickImage() async {
    if (_isPickerActive) return;

    setState(() => _isPickerActive = true);

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    } finally {
      setState(() => _isPickerActive = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _pointController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please upload an image')));
      return;
    }

    setState(() => _isSubmitting = true);

    final uri = Uri.parse('http://127.0.0.1:4001/api/add_rewards');
    final request = http.MultipartRequest('POST', uri);

    request.fields['reward_name'] = _nameController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['exchange_point'] = _pointController.text;
    request.fields['quantity'] = _quantityController.text;

    request.files.add(
      await http.MultipartFile.fromPath('image', _imageFile!.path),
    );

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        _showSuccessSnackbar();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Rewardmanagement()),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add reward: $errorMessage')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add New rewards Successfully!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Color.fromARGB(255, 142, 180, 134),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                      "Add New Reward",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Behavior Description
                    const Text(
                      "Name:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Example Input: Doll",
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please describe Name Reward';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Description:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Example: Special sneaker \nfrom adidas",
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Date Picker
                    const Text(
                      "Quantity:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Example Input: 999",
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please describe Quantity Reward';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Total point:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _pointController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Example Input: 3000",
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please describe Point Reward';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Image Upload
                    const Text(
                      "Upload rewards image",
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
                                builder: (context) => Rewardmanagement(),
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
                          onPressed: _isSubmitting ? null : _submitForm,
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
