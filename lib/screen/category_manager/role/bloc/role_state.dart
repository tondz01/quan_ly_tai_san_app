import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';

abstract class RoleState extends Equatable {
  const RoleState();

  @override
  List<Object?> get props => [];
}

class RolesInitialState extends RoleState {}

class RolesLoadingState extends RoleState {}

class RolesLoadingDismissState extends RoleState {}

class GetListRoleSuccessState extends RoleState {
  final List<ChucVu> data;

  const GetListRoleSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListRoleFailedState extends RoleState {
  final String title;
  final int? code;
  final String message;

  const GetListRoleFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
//CREATE
class CreateRoleSuccessState extends RoleState {
  final String data;

  const CreateRoleSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateRoleFailedState extends RoleState {
  final String title;
  final int? code;
  final String message;

  const CreateRoleFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//UPDATE
class UpdateRoleSuccessState extends RoleState {
  final String data;

  const UpdateRoleSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//DELETE
class DeleteRoleSuccessState extends RoleState {
  final String data;

  const DeleteRoleSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends RoleState {
  final String title;
  final int? code;
  final String message;

  const PutPostDeleteFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
