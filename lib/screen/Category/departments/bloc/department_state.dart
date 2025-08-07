import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/nhom_don_vi.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();
  @override
  List<Object?> get props => [];
}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoaded extends DepartmentState {
  final List<PhongBan> departments;
  final List<NhomDonVi> departmentGroups;
  copyWith({
    List<PhongBan>? departments,
    List<NhomDonVi>? departmentGroups,
  }) {
    return DepartmentLoaded(
      departments ?? this.departments,
      departmentGroups ?? this.departmentGroups,
    );
  }
  const DepartmentLoaded(this.departments, this.departmentGroups);
  @override
  List<Object?> get props => [departments, departmentGroups];
}

class DepartmentError extends DepartmentState {
  final String message;
  const DepartmentError(this.message);
  @override
  List<Object?> get props => [message];
} 