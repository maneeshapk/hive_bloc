import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_bloc/src/domain/models/hivemodel.dart';
import 'package:hive_bloc/src/presentation/cubit/bloc/hive_bloc.dart';
import 'package:hive_bloc/src/presentation/cubit/bloc/hive_event.dart';
import 'package:hive_bloc/src/presentation/cubit/bloc/hive_state.dart';

class ShowStudentInfo extends StatefulWidget {
  const ShowStudentInfo({super.key});

  @override
  _ShowStudentInfoState createState() => _ShowStudentInfoState();
}

class _ShowStudentInfoState extends State<ShowStudentInfo> {
  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(LoadStudentsEvent());
  }

  void _showUpdateDialog(BuildContext context, HiveModel student) {
    final TextEditingController nameController = TextEditingController(text: student.studentname);
    final TextEditingController ageController = TextEditingController(text: student.studentage);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Student Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
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
              onPressed: () {
                final updatedStudent = HiveModel(
                  id: student.id, 
                  studentname: nameController.text.trim(),
                  studentage: ageController.text.trim(),
                  imagepath: student.imagepath, 
                );
                context.read<StudentBloc>().add(UpdateStudentEvent(updatedStudent));
                Navigator.of(context).pop();
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
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentLoadedState) {
            return ListView.builder(
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final student = state.students[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.studentname,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          student.studentage,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Image.file(File(student.imagepath)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showUpdateDialog(context, student); 
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                context.read<StudentBloc>().add(DeleteStudentEvent(student.id!));
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
          } else if (state is StudentErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('No students found.'));
          }
        },
      ),
    );
  }
}
