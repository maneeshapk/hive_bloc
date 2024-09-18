import 'package:bloc/bloc.dart';
import 'package:hive_bloc/src/domain/functions/hive_functions.dart';
import 'package:hive_bloc/src/presentation/cubit/bloc/hive_event.dart';
import 'package:hive_bloc/src/presentation/cubit/bloc/hive_state.dart';


class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitialState()) {
    on<LoadStudentsEvent>(_onLoadStudents);
    on<AddStudentEvent>(_onAddStudent);
    on<UpdateStudentEvent>(_onUpdateStudent);
    on<DeleteStudentEvent>(_onDeleteStudent);
  }

  Future<void> _onLoadStudents(
    LoadStudentsEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoadingState());
    try {
      final students = await getstudentinfo();
      emit(StudentLoadedState(students.toList()));
    } catch (e) {
      emit(StudentErrorState('Failed to load students'));
    }
  }

  Future<void> _onAddStudent(
    AddStudentEvent event,
    Emitter<StudentState> emit,
  ) async {
    try {
      await addstudentinfo(event.student);
      add(LoadStudentsEvent()); // Reload students after adding
    } catch (e) {
      emit(StudentErrorState('Failed to add student'));
    }
  }

  Future<void> _onUpdateStudent(
    UpdateStudentEvent event,
    Emitter<StudentState> emit,
  ) async {
    try {
      await updatestudentinfo(event.student);
      add(LoadStudentsEvent()); // Reload students after updating
    } catch (e) {
      emit(StudentErrorState('Failed to update student'));
    }
  }

  Future<void> _onDeleteStudent(
    DeleteStudentEvent event,
    Emitter<StudentState> emit,
  ) async {
    try {
      await deletestudentinfo(event.studentId);
      add(LoadStudentsEvent()); // Reload students after deletion
    } catch (e) {
      emit(StudentErrorState('Failed to delete student'));
    }
  }
}
