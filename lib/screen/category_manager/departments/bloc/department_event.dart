import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();
  @override
  List<Object?> get props => [];
}

class LoadDepartments extends DepartmentEvent {
  const LoadDepartments();
  @override
  List<Object?> get props => [];
}

class AddDepartment extends DepartmentEvent {
  final PhongBan department;
  const AddDepartment(this.department);
  @override
  List<Object?> get props => [department];
}

class UpdateDepartment extends DepartmentEvent {
  final PhongBan department;
  const UpdateDepartment(this.department);
  @override
  List<Object?> get props => [department];
}

class DeleteDepartment extends DepartmentEvent {
  final PhongBan department;
  const DeleteDepartment(this.department);
  @override
  List<Object?> get props => [department];
}

class DeleteDepartmentBatch extends DepartmentEvent {
  final List<String> data;
  const DeleteDepartmentBatch(this.data);
  @override
  List<Object?> get props => [data];
}

class SearchDepartment extends DepartmentEvent {
  final String keyword;
  const SearchDepartment(this.keyword);
  @override
  List<Object?> get props => [keyword];
} 