import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';

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
