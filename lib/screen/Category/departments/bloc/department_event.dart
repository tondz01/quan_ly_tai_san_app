import 'package:equatable/equatable.dart';
import '../models/department.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();
  @override
  List<Object?> get props => [];
}

class LoadDepartments extends DepartmentEvent {
  final List<Department> departments;
  const LoadDepartments(this.departments);
  @override
  List<Object?> get props => [departments];
}

class AddDepartment extends DepartmentEvent {
  final Department department;
  const AddDepartment(this.department);
  @override
  List<Object?> get props => [department];
}

class UpdateDepartment extends DepartmentEvent {
  final Department department;
  const UpdateDepartment(this.department);
  @override
  List<Object?> get props => [department];
}

class DeleteDepartment extends DepartmentEvent {
  final Department department;
  const DeleteDepartment(this.department);
  @override
  List<Object?> get props => [department];
} 