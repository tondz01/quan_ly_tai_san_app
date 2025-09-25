import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/model/permission_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/request/auth/auth_request.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class PostLoginEvent extends LoginEvent {
  final AuthRequest params;

  const PostLoginEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class GetUsersEvent extends LoginEvent {
  final BuildContext context;
  const GetUsersEvent(this.context);

  @override
  List<Object> get props => [context];
}
class GetNhanVienEvent extends LoginEvent {
  final BuildContext context;
  final String idCongTy;
  const GetNhanVienEvent(this.context, this.idCongTy);

  @override
  List<Object> get props => [context, idCongTy];
}

class CreateAccountEvent extends LoginEvent {
  final UserInfoDTO user;
  const CreateAccountEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateUserEvent extends LoginEvent {
  final String id;
  final UserInfoDTO user;
  const UpdateUserEvent(this.id, this.user);

  @override
  List<Object?> get props => [id, user];
}

class UpdatePermissionEvent extends LoginEvent {
  final List<PermissionDto> permissions;
  const UpdatePermissionEvent(this.permissions);

  @override
  List<Object?> get props => [permissions];
}

class DeleteUserEvent extends LoginEvent {
  final String id;
  const DeleteUserEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteUserBatchEvent extends LoginEvent {
  final List<String> ids;
  const DeleteUserBatchEvent(this.ids);

  @override
  List<Object?> get props => [ids];
}
