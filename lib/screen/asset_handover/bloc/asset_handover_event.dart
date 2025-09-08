import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';

abstract class AssetHandoverEvent extends Equatable {
  const AssetHandoverEvent();
}

class GetListAssetHandoverEvent extends AssetHandoverEvent {
  final BuildContext context;

  const GetListAssetHandoverEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class SendToSignerAsetHandoverEvent extends AssetHandoverEvent {
  final BuildContext context;
  final List<AssetHandoverDto> params;

  const SendToSignerAsetHandoverEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
}

class CreateAssetHandoverEvent extends AssetHandoverEvent {
  final Map<String, dynamic> request;
  final List<SignatoryDto> listSignatory;

  const CreateAssetHandoverEvent(this.request, this.listSignatory);

  @override
  List<Object?> get props => [request, listSignatory];
}

class UpdateAssetHandoverEvent extends AssetHandoverEvent {
  final BuildContext context;
  final Map<String, dynamic> request;
  final String id;

  const UpdateAssetHandoverEvent(this.context, this.request, this.id);

  @override
  List<Object?> get props => [context, request];
}

class DeleteAssetHandoverEvent extends AssetHandoverEvent {
  final BuildContext context;
  final String id;

  const DeleteAssetHandoverEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}

//Cập nhập trạng thái phiếu ký nội sinh
class UpdateSigningStatusEvent extends AssetHandoverEvent {
  final BuildContext context;
  final String id;
  final String userId;
  final List<Map<String, dynamic>> request;

  const UpdateSigningStatusEvent(this.context, this.id, this.userId, this.request);

  @override
  List<Object?> get props => [context, id, userId, request];
}

//Hủy phiếu ký nội sinh
class CancelAssetHandoverEvent extends AssetHandoverEvent {
  final BuildContext context;
  final String id;

  const CancelAssetHandoverEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}
