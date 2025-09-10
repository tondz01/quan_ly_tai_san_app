import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

abstract class ToolAndSuppliesHandoverState extends Equatable {
  const ToolAndSuppliesHandoverState();

  @override
  List<Object?> get props => [];
}

class ToolAndSuppliesHandoverInitialState extends ToolAndSuppliesHandoverState {}

class ToolAndSuppliesHandoverLoadingState extends ToolAndSuppliesHandoverState {}

class ToolAndSuppliesHandoverLoadingDismissState extends ToolAndSuppliesHandoverState {}

class GetListToolAndSuppliesHandoverSuccessState extends ToolAndSuppliesHandoverState {
  final List<ToolAndSuppliesHandoverDto> data;
  final List<PhongBan> dataDepartment;
  final List<NhanVien> dataStaff;
  final List<ToolAndMaterialTransferDto> dataCcdcransfer;
  final List<ToolsAndSuppliesDto> dataCcdc;

  const GetListToolAndSuppliesHandoverSuccessState({
    required this.data,
    required this.dataDepartment,
    required this.dataStaff,
    required this.dataCcdcransfer,
    required this.dataCcdc,
  });

  @override
  List<Object> get props => [data];
}

class CreateToolAndSuppliesHandoverSuccessState extends ToolAndSuppliesHandoverState {
  final String data;

  const CreateToolAndSuppliesHandoverSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class UpdateToolAndSuppliesHandoverSuccessState extends ToolAndSuppliesHandoverState {
  final String data;

  const UpdateToolAndSuppliesHandoverSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteToolAndSuppliesHandoverSuccessState extends ToolAndSuppliesHandoverState {
  final String data;

  const DeleteToolAndSuppliesHandoverSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//Cập nhập trạng thái phiếu ký nội sinh success
class UpdateSigningStatusSuccessState extends ToolAndSuppliesHandoverState {
  final bool isUpdateOwnershipUnit;
  const UpdateSigningStatusSuccessState({required this.isUpdateOwnershipUnit});

  @override
  List<Object> get props => [isUpdateOwnershipUnit];
}

class CancelToolAndSuppliesHandoverSuccessState extends ToolAndSuppliesHandoverState {
  const CancelToolAndSuppliesHandoverSuccessState();

  @override
  List<Object> get props => [];
}

class ErrorState extends ToolAndSuppliesHandoverState {
  final String title;
  final int? code;
  final String message;

  const ErrorState({required this.title, this.code, required this.message});

  @override
  List<Object> get props => [title, code ?? 0, message];
}
