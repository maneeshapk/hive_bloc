
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_bloc/src/presentation/cubit/bloc/hive_event.dart';
import 'package:hive_bloc/src/presentation/cubit/bloc/hive_state.dart';
import 'package:hive_bloc/src/domain/functions/hive_functions.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentLoadingState()) {
    on<LoadStudentsEvent>((event, emit) async {
      try {
        final students = await getstudentinfo(); // Fetch students from Hive
        emit(StudentLoadedState(students.toList()));
      } catch (error) {
        emit(StudentErrorState(error.toString()));
      }
    });

    on<AddStudentEvent>((event, emit) async {
      try {
        await addstudentinfo(event.student); // Add student to Hive
        final students = await getstudentinfo(); // Fetch updated students
        emit(StudentLoadedState(students.toList()));
      } catch (error) {
        emit(StudentErrorState(error.toString()));
      }
    });

    on<UpdateStudentEvent>((event, emit) async {
      try {
        await updatestudentinfo(event.student); // Update student in Hive
        final students = await getstudentinfo(); // Fetch updated students
        emit(StudentLoadedState(students.toList()));
      } catch (error) {
        emit(StudentErrorState(error.toString()));
      }
    });

    on<DeleteStudentEvent>((event, emit) async {
      try {
        await deletestudentinfo(event.studentId); // Delete student from Hive
        final students = await getstudentinfo(); // Fetch updated students
        emit(StudentLoadedState(students.toList()));
      } catch (error) {
        emit(StudentErrorState(error.toString()));
      }
    });
  }
}

