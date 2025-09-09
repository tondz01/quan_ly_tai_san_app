import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/request/detail_tool_and_material_transfer_request.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/request/tool_and_material_transfer_request.dart';

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
  final ToolAndMaterialTransferRequest request;
  final List<ChiTietBanGiaoRequest> requestDetail;
  final List<SignatoryDto> requestSignatory;

  const CreateToolAndMaterialTransferEvent(
    this.context,
    this.request,
    this.requestDetail,
    this.requestSignatory,
  );

  @override
  List<Object> get props => [context, request, requestDetail, requestSignatory];
}

class UpdateToolAndMaterialTransferEvent extends ToolAndMaterialTransferEvent {
  final BuildContext context;
  final ToolAndMaterialTransferRequest params;
  final String id;

  const UpdateToolAndMaterialTransferEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class SendToSignerTAMTEvent extends ToolAndMaterialTransferEvent {
  final BuildContext context;
  final List<ToolAndMaterialTransferDto> params;

  const SendToSignerTAMTEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
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
