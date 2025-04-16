import 'package:clean_energy_rewards/pages/admin-side/Rewardmanagement.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:clean_energy_rewards/pages/components/sideBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/navBarAdmin.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';
import 'package:clean_energy_rewards/pages/admin-side/Rewardmanagement.dart';
import 'package:clean_energy_rewards/pages/user-side/user_behavior.dart';
import 'package:clean_energy_rewards/pages/admin-side/CheckUserBehavior.dart';

class ApproveBehavior extends StatefulWidget {
  @override
  State<ApproveBehavior> createState() => _ApproveBehaviorState();
}

class _ApproveBehaviorState extends State<ApproveBehavior> {
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

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please upload an image')));
      return;
    }

    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Behavior recorded successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Rewardmanagement()),
      );
    });
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
                      "Approve Behavior",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Behavior Description
                    const Text(
                      "How do you use clean energy?",
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
                        labelText: "Wind Energy",
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please describe Name Reward';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 15),

                    // Date Picker
                    const Text(
                      "On Date",
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
                        labelText: "MAY-SAT-3.00 PM",
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please describe Quantity Reward';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "POINT:",
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
                        labelText: "Example Input: 600",
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
                      "Upload your picture to prove",
                      style: TextStyle(
                        color: Color.fromARGB(255, 116, 79, 64),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset('assets/bag.jpg', alignment: Alignment.center),
                    // GestureDetector(
                    //   onTap: _pickImage,
                    //   child: Container(
                    //     padding: const EdgeInsets.all(10),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.grey),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Container(
                    //           width: MediaQuery.of(context).size.width * 0.8,
                    //           height: MediaQuery.of(context).size.width * 0.3,
                    //           decoration:
                    //               _imageFile != null
                    //                   ? BoxDecoration(
                    //                     image: DecorationImage(
                    //                       image: FileImage(_imageFile!),
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //                   )
                    //                   : null,
                    //           child:
                    //               _imageFile == null
                    //                   ? const Column(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     children: [
                    //                       Icon(
                    //                         Icons.image,
                    //                         color: Color.fromARGB(
                    //                           255,
                    //                           116,
                    //                           79,
                    //                           64,
                    //                         ),
                    //                         size: 40,
                    //                       ),
                    //                       SizedBox(height: 10),
                    //                       Text(
                    //                         'Choose a file here',
                    //                         style: TextStyle(
                    //                           color: Color.fromARGB(
                    //                             255,
                    //                             116,
                    //                             79,
                    //                             64,
                    //                           ),
                    //                           fontSize: 16,
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   )
                    //                   : null,
                    //         ),
                    //         if (_imageFile != null) ...[
                    //           const SizedBox(height: 10),
                    //           const Text(
                    //             'Image selected',
                    //             style: TextStyle(
                    //               color: Colors.green,
                    //               fontSize: 14,
                    //             ),
                    //           ),
                    //         ],
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
                          onPressed: _isSubmitting ? null : _submitForm,
                          child:
                              _isSubmitting
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text('APPROVE'),
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
