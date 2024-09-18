
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_bloc/src/domain/functions/hive_functions.dart';
import 'package:hive_bloc/src/domain/models/hivemodel.dart';

class ShowStudentInfo extends StatefulWidget {
  const ShowStudentInfo({super.key});

  @override
  _ShowStudentInfoState createState() => _ShowStudentInfoState();
}

class _ShowStudentInfoState extends State<ShowStudentInfo> {
  late Future<Iterable<HiveModel>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = _fetchStudents();
  }

  Future<Iterable<HiveModel>> _fetchStudents() async {
    return await getstudentinfo();
  }

  Future<void> _refreshStudents() async {
    setState(() {
      _studentsFuture = _fetchStudents();
    });
  }

  // Method to show the update dialog
  void _showUpdateDialog(HiveModel student) {
    TextEditingController nameController =
        TextEditingController(text: student.studentname);
    TextEditingController ageController =
        TextEditingController(text: student.studentage);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Student Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Student Name'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(hintText: 'Student Age'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                student.studentname = nameController.text.trim();
                student.studentage = ageController.text.trim();
                await updatestudentinfo(student);
                Navigator.of(context).pop();
                _refreshStudents();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Student info updated successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Information"),
      ),
      body: FutureBuilder<Iterable<HiveModel>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found.'));
          }

          final students = snapshot.data!.toList();

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.studentname,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        student.studentage,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      // Displaying the image

                      Image.file(File(student.imagepath)),

                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showUpdateDialog(student);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await deletestudentinfo(student.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Student deleted successfully'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              _refreshStudents();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
