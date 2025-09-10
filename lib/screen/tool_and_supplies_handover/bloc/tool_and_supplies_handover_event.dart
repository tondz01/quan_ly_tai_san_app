import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';

abstract class ToolAndSuppliesHandoverEvent extends Equatable {
  const ToolAndSuppliesHandoverEvent();
}

class GetListToolAndSuppliesHandoverEvent extends ToolAndSuppliesHandoverEvent {
  final BuildContext context;

  const GetListToolAndSuppliesHandoverEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class SendToSignerAsetHandoverEvent extends ToolAndSuppliesHandoverEvent {
  final BuildContext context;
  final List<ToolAndSuppliesHandoverDto> params;

  const SendToSignerAsetHandoverEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
}

class CreateToolAndSuppliesHandoverEvent extends ToolAndSuppliesHandoverEvent {
  final Map<String, dynamic> request;
  final List<SignatoryDto> listSignatory;

  const CreateToolAndSuppliesHandoverEvent(this.request, this.listSignatory);

  @override
  List<Object?> get props => [request, listSignatory];
}

class UpdateToolAndSuppliesHandoverEvent extends ToolAndSuppliesHandoverEvent {
  final BuildContext context;
  final Map<String, dynamic> request;

  const UpdateToolAndSuppliesHandoverEvent(this.context, this.request);

  @override
  List<Object?> get props => [context, request];
}

class DeleteToolAndSuppliesHandoverEvent extends ToolAndSuppliesHandoverEvent {
  final BuildContext context;
  final String id;

  const DeleteToolAndSuppliesHandoverEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}

//Cập nhập trạng thái phiếu ký nội sinh
class UpdateSigningStatusCcdcEvent extends ToolAndSuppliesHandoverEvent {
  final BuildContext context;
  final String id;
  final String userId;
  final List<Map<String, dynamic>> request;
  final List<Map<String, dynamic>> requestQuantity;
  final String idDieuChuyen;

  const UpdateSigningStatusCcdcEvent(this.context, this.id, this.userId, this.request, this.requestQuantity, this.idDieuChuyen);

  @override
  List<Object?> get props => [context, id, userId, request, requestQuantity, idDieuChuyen];
}

//Hủy phiếu ký nội sinh
class CancelToolAndSuppliesHandoverEvent extends ToolAndSuppliesHandoverEvent {
  final BuildContext context;
  final String id;

  const CancelToolAndSuppliesHandoverEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}
