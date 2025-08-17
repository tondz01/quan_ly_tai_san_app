import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

import '../model/tool_and_material_transfer_dto.dart';

abstract class ToolAndMaterialTransferState extends Equatable {
  const ToolAndMaterialTransferState();

  @override
  List<Object?> get props => [];
}

class ToolAndMaterialTransferInitialState extends ToolAndMaterialTransferState {}

class ToolAndMaterialTransferLoadingState extends ToolAndMaterialTransferState {}

class ToolAndMaterialTransferLoadingDismissState extends ToolAndMaterialTransferState {}

class GetListToolAndMaterialTransferSuccessState extends ToolAndMaterialTransferState {
  final List<ToolAndMaterialTransferDto> data;

  const GetListToolAndMaterialTransferSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListToolAndMaterialTransferFailedState extends ToolAndMaterialTransferState {
  final String title;
  final int? code;
  final String message;

  const GetListToolAndMaterialTransferFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//Get List Asset
class GetListAssetSuccessState extends ToolAndMaterialTransferState {
  final List<ToolsAndSuppliesDto> data;
  const GetListAssetSuccessState({required this.data});
}

class GetListAssetFailedState extends ToolAndMaterialTransferState {
  final String title;
  final int? code;
  final String message;

  const GetListAssetFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//Get List Asset
class GetDataDropdownSuccessState extends ToolAndMaterialTransferState {
  final List<PhongBan> dataPb;
  final List<NhanVien> dataNv;
  const GetDataDropdownSuccessState({
    required this.dataPb,
    required this.dataNv,
  });
}

class GetDataDropdownFailedState extends ToolAndMaterialTransferState {
  final String title;
  final int? code;
  final String message;

  const GetDataDropdownFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//CREATED
class CreateDieuDongSuccessState extends ToolAndMaterialTransferState {
  const CreateDieuDongSuccessState();

  @override
  List<Object> get props => [];
}

class CreateDieuDongFailedState extends ToolAndMaterialTransferState {
  final String title;
  final int? code;
  final String message;

  const CreateDieuDongFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//UPDATE
class UpdateDieuDongSuccessState extends ToolAndMaterialTransferState {
  final String data;

  const UpdateDieuDongSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//DELETE
class DeleteDieuDongSuccessState extends ToolAndMaterialTransferState {
  final String data;

  const DeleteDieuDongSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends ToolAndMaterialTransferState {
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
