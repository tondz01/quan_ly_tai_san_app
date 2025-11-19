import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();
}

class GetListDepartmentEvent extends DepartmentEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListDepartmentEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

class CreateDepartmentEvent extends DepartmentEvent {
  final PhongBan params;

  const CreateDepartmentEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class CreateDepartmentBatchEvent extends DepartmentEvent {
  final List<PhongBan> params;

  const CreateDepartmentBatchEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateDepartmentEvent extends DepartmentEvent {
  final PhongBan params;

  const UpdateDepartmentEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class DeleteDepartmentEvent extends DepartmentEvent {
  final String id;

  const DeleteDepartmentEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteDepartmentBatchEvent extends DepartmentEvent {
  final List<String> id;

  const DeleteDepartmentBatchEvent(this.id);

  @override
  List<Object?> get props => [id];
}
