import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';

abstract class RoleEvent extends Equatable {
  const RoleEvent();
}

class GetListRoleEvent extends RoleEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListRoleEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

class CreateRoleEvent extends RoleEvent {
  final ChucVu params;

  const CreateRoleEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class CreateRoleBatchEvent extends RoleEvent {
  final List<ChucVu> params;

  const CreateRoleBatchEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateRoleEvent extends RoleEvent {
  final ChucVu params;

  const UpdateRoleEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class DeleteRoleEvent extends RoleEvent {
  final String id;

  const DeleteRoleEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteRoleBatchEvent extends RoleEvent {
  final Map<String, dynamic> id;

  const DeleteRoleBatchEvent(this.id);

  @override
  List<Object?> get props => [id];
}
