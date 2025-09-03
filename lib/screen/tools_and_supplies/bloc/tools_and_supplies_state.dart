import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

abstract class ToolsAndSuppliesState extends Equatable {
  const ToolsAndSuppliesState();

  @override
  List<Object?> get props => [];
}

class ToolsAndSuppliesInitialState extends ToolsAndSuppliesState {}

class ToolsAndSuppliesLoadingState extends ToolsAndSuppliesState {}

class ToolsAndSuppliesLoadingDismissState extends ToolsAndSuppliesState {}

class GetListToolsAndSuppliesSuccessState extends ToolsAndSuppliesState {
  final List<ToolsAndSuppliesDto> data;
  final List<CcdcGroup> dataGroupCCDC;

  const GetListToolsAndSuppliesSuccessState({
    required this.data,
    required this.dataGroupCCDC,
  });

  @override
  List<Object> get props => [data];
}

class GetListToolsAndSuppliesFailedState extends ToolsAndSuppliesState {
  final String title;
  final int? code;
  final String message;

  const GetListToolsAndSuppliesFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//GET LIST PHONG BAN
class GetListPhongBanSuccessState extends ToolsAndSuppliesState {
  final List<PhongBan> data;

  const GetListPhongBanSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListPhongBanFailedState extends ToolsAndSuppliesState {
  final String title;
  final int? code;
  final String message;

  const GetListPhongBanFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//CREATE
class CreateToolsAndSuppliesSuccessState extends ToolsAndSuppliesState {
  final String data;

  const CreateToolsAndSuppliesSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateToolsAndSuppliesFailedState extends ToolsAndSuppliesState {
  final String title;
  final int? code;
  final String message;

  const CreateToolsAndSuppliesFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//UPDATE
class UpdateToolsAndSuppliesSuccessState extends ToolsAndSuppliesState {
  final String data;

  const UpdateToolsAndSuppliesSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//DELETE
class DeleteToolsAndSuppliesSuccessState extends ToolsAndSuppliesState {
  final String data;

  const DeleteToolsAndSuppliesSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends ToolsAndSuppliesState {
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
