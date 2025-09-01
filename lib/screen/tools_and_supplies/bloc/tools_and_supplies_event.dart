import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/request/tools_and_suppliest_request.dart';

abstract class ToolsAndSuppliesEvent extends Equatable {
  const ToolsAndSuppliesEvent();
}

class GetListToolsAndSuppliesEvent extends ToolsAndSuppliesEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListToolsAndSuppliesEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

//GET LIST PHONG BAN
class GetListPhongBanEvent extends ToolsAndSuppliesEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListPhongBanEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

class CreateToolsAndSuppliesEvent extends ToolsAndSuppliesEvent {
  final ToolsAndSuppliesRequest params;

  final String listAssetDetail;

  const CreateToolsAndSuppliesEvent(this.params, this.listAssetDetail);

  @override
  List<Object?> get props => [params, listAssetDetail];
}

class UpdateToolsAndSuppliesEvent extends ToolsAndSuppliesEvent {
  final ToolsAndSuppliesRequest params;
  final String listAssetDetail;

  const UpdateToolsAndSuppliesEvent(this.params, this.listAssetDetail);

  @override
  List<Object?> get props => [params, listAssetDetail];
}

class DeleteToolsAndSuppliesEvent extends ToolsAndSuppliesEvent {
  final String id;
  final String listIdAssetDetail;

  const DeleteToolsAndSuppliesEvent(this.id, this.listIdAssetDetail);

  @override
  List<Object?> get props => [id, listIdAssetDetail];
}
