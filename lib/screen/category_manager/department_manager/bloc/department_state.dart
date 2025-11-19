import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object?> get props => [];
}

class DepartmentsInitialState extends DepartmentState {}

class DepartmentsLoadingState extends DepartmentState {}

class DepartmentsLoadingDismissState extends DepartmentState {}

class GetListDepartmentSuccessState extends DepartmentState {
  final List<PhongBan> data;

  const GetListDepartmentSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListDepartmentFailedState extends DepartmentState {
  final String title;
  final int? code;
  final String message;

  const GetListDepartmentFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code ?? 0, message];
}

//CREATE
class CreateDepartmentSuccessState extends DepartmentState {
  final String data;

  const CreateDepartmentSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateDepartmentFailedState extends DepartmentState {
  final String title;
  final int? code;
  final String message;

  const CreateDepartmentFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code ?? 0, message];
}

//UPDATE
class UpdateDepartmentSuccessState extends DepartmentState {
  final String data;

  const UpdateDepartmentSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//DELETE
class DeleteDepartmentSuccessState extends DepartmentState {
  final String data;

  const DeleteDepartmentSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends DepartmentState {
  final String title;
  final int? code;
  final String message;

  const PutPostDeleteFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code ?? 0, message];
}

// Additional states for better error handling
class DeleteDepartmentBatchSuccess extends DepartmentState {
  final String message;
  const DeleteDepartmentBatchSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class DeleteDepartmentBatchFailure extends DepartmentState {
  final String message;
  const DeleteDepartmentBatchFailure(this.message);
  @override
  List<Object?> get props => [message];
}
