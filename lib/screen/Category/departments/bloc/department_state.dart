import 'package:equatable/equatable.dart';
import '../models/department.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();
  @override
  List<Object?> get props => [];
}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoaded extends DepartmentState {
  final List<Department> departments;
  const DepartmentLoaded(this.departments);
  @override
  List<Object?> get props => [departments];
}

class DepartmentError extends DepartmentState {
  final String message;
  const DepartmentError(this.message);
  @override
  List<Object?> get props => [message];
} 