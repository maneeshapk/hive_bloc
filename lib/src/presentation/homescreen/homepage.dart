

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_bloc/src/domain/functions/hive_functions.dart';
import 'package:hive_bloc/src/domain/models/hivemodel.dart';
import 'package:hive_bloc/src/presentation/homescreen/showstudentinfo.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController studentnamecontroller = TextEditingController();
  final TextEditingController studentagecontroller = TextEditingController();
  String? imagePath;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ShowStudentInfo())
          );
        },
        label: const Text('Show Students Info'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: TextFormField(
              controller: studentnamecontroller,
              decoration: const InputDecoration(hintText: "Student Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: TextFormField(
              controller: studentagecontroller,
              decoration: const InputDecoration(hintText: "Student Age"),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text("Pick Image"),
          ),
         
          ElevatedButton(
            onPressed: () {
              // Hive add details code
              HiveModel data = HiveModel(
                imagepath: imagePath ?? "", // Use the image path if available
                studentname: studentnamecontroller.text.trim(),
                studentage: studentagecontroller.text.trim(),
              );
              addstudentinfo(data);

              // Student info added
              print("ok");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Student info added successfully'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}

