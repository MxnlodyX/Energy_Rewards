import 'package:flutter/material.dart';
import 'package:clean_energy_rewards/pages/components/sideBar.dart';
import 'package:clean_energy_rewards/pages/components/navBar.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picker
import 'package:intl/intl.dart'; // For formatting the date

class addBehavior extends StatefulWidget {
  @override
  State<addBehavior> createState() => _addBehaviorState();
}

class _addBehaviorState extends State<addBehavior> {
  TextEditingController dateController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  String imagePath = '';

  // Date Picker Method
  Future<void> _pickDate() async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  bool isPickerActive = false; // Flag to track if image picker is active

  // Image Picker Method
  Future<void> _pickImage() async {
    if (isPickerActive) {
      return; // Prevent picking an image if the picker is already active
    }

    setState(() {
      isPickerActive = true;
    });

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        // Handle picked image
      }
    } catch (e) {
      // Handle errors if any
    } finally {
      setState(() {
        isPickerActive = false; // Reset the flag after the image picker is done
      });
    }
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
          margin: EdgeInsets.only(top: 135),
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 82, 49, 31),
                offset: Offset(0, 4),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Energy Record Form",
                  style: TextStyle(
                    color: Color.fromARGB(255, 116, 79, 64),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "How do you use clean energy ?",
                  style: TextStyle(
                    color: Color.fromARGB(255, 116, 79, 64),
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: "Example Input : Use EV Car",
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "On which date ?",
                  style: TextStyle(
                    color: Color.fromARGB(255, 116, 79, 64),
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  readOnly: true, // Make it read-only to prevent manual input
                  onTap: _pickDate, // Tap to open the date picker
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: "Tap to Select Date",
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Upload your picture to prove ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 116, 79, 64),
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Icon(
                                Icons.image,
                                color: Color.fromARGB(255, 116, 79, 64),
                              ),
                              SizedBox(height: 10),
                              Text(
                                imagePath.isEmpty
                                    ? 'Choose a file here'
                                    : 'Image Selected',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 116, 79, 64),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(164, 116, 106, 106),

                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 142, 180, 134),

                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
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
