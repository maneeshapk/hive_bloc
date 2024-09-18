import 'package:equatable/equatable.dart';
import 'package:hive_bloc/src/domain/models/hivemodel.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudentsEvent extends StudentEvent {}

class AddStudentEvent extends StudentEvent {
  final HiveModel student;
  const AddStudentEvent(this.student);

  @override
  List<Object?> get props => [student];
}

class UpdateStudentEvent extends StudentEvent {
  final HiveModel student;
  const UpdateStudentEvent(this.student);

  @override
  List<Object?> get props => [student];
}

class DeleteStudentEvent extends StudentEvent {
  final int studentId;
  const DeleteStudentEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}
