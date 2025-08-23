import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';

abstract class ToolAndMaterialTransferEvent extends Equatable {
  const ToolAndMaterialTransferEvent();
}

class GetListToolAndMaterialTransferEvent extends ToolAndMaterialTransferEvent {
  final BuildContext context;
  final int typeAssetTransfer;
  final String idCongTy;

  const GetListToolAndMaterialTransferEvent(
    this.context,
    this.typeAssetTransfer,
    this.idCongTy,
  );

  @override
  List<Object?> get props => [context, typeAssetTransfer];
}

class GetListAssetEvent extends ToolAndMaterialTransferEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListAssetEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

class GetDataDropdownEvent extends ToolAndMaterialTransferEvent {
  final BuildContext context;
  final String idCongTy;

  const GetDataDropdownEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

//TẠO BẢN ĐIỀU ĐỘNG
class CreateToolAndMaterialTransferEvent extends ToolAndMaterialTransferEvent {
  final BuildContext context;
  final ToolAndMaterialTransferDto request;
  final List<DetailToolAndMaterialTransferDto> requestDetail;

  const CreateToolAndMaterialTransferEvent(this.context, this.request, this.requestDetail);

  @override
  List<Object> get props => [context, request, requestDetail];
}

class UpdateToolAndMaterialTransferEvent extends ToolAndMaterialTransferEvent {
  final BuildContext context;
  final ToolAndMaterialTransferDto params;
  final String id;

  const UpdateToolAndMaterialTransferEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class DeleteToolAndMaterialTransferEvent extends ToolAndMaterialTransferEvent {
  final BuildContext context;
  final String id;

  const DeleteToolAndMaterialTransferEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}

class UpdateSigningTAMTStatusEvent extends ToolAndMaterialTransferEvent {
  final BuildContext context;
  final String id;
  final String userId;

  const UpdateSigningTAMTStatusEvent(this.context, this.id, this.userId);

  @override
  List<Object?> get props => [context, id, userId];
}

class CancelToolAndMaterialTransferEvent extends ToolAndMaterialTransferEvent {
  final BuildContext context;
  final String id;

  const CancelToolAndMaterialTransferEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}

