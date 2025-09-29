import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/nhom_don_vi.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();
  @override
  List<Object?> get props => [];
}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentLoaded extends DepartmentState {
  final List<PhongBan> departments;
  final List<NhomDonVi> departmentGroups;
  
  const DepartmentLoaded(this.departments, this.departmentGroups);
  
  DepartmentLoaded copyWith({
    List<PhongBan>? departments,
    List<NhomDonVi>? departmentGroups,
  }) {
    return DepartmentLoaded(
      departments ?? this.departments,
      departmentGroups ?? this.departmentGroups,
    );
  }
  
  @override
  List<Object?> get props => [departments, departmentGroups];
}

class DepartmentError extends DepartmentState {
  final String message;
  const DepartmentError(this.message);
  @override
  List<Object?> get props => [message];
}

class AddDepartmentSuccess extends DepartmentState {
  final String message;
  const AddDepartmentSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class UpdateDepartmentSuccess extends DepartmentState {
  final String message;
  const UpdateDepartmentSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class DeleteDepartmentSuccess extends DepartmentState {
  final String message;
  const DeleteDepartmentSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class DeleteDepartmentBatchSuccess extends DepartmentState {}

class DeleteDepartmentBatchFailure extends DepartmentState {
  final String message;
  const DeleteDepartmentBatchFailure(this.message);
  @override
  List<Object?> get props => [message];
} 