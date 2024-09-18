import 'package:equatable/equatable.dart';
import 'package:hive_bloc/src/domain/models/hivemodel.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object?> get props => [];
}

class StudentInitialState extends StudentState {}

class StudentLoadingState extends StudentState {}

class StudentLoadedState extends StudentState {
  final List<HiveModel> students;

  const StudentLoadedState(this.students);

  @override
  List<Object?> get props => [students];
}

class StudentErrorState extends StudentState {
  final String error;
  const StudentErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
