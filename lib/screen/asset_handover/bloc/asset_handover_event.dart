import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AssetHandoverEvent extends Equatable {
  const AssetHandoverEvent();
}

class GetListAssetHandoverEvent extends AssetHandoverEvent {
  final BuildContext context;

  const GetListAssetHandoverEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CreateAssetHandoverEvent extends AssetHandoverEvent {
  final BuildContext context;
  final Map<String, dynamic> request;

  const CreateAssetHandoverEvent(this.context, this.request);

  @override
  List<Object?> get props => [context, request];
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

  const UpdateSigningStatusEvent(this.context, this.id, this.userId);

  @override
  List<Object?> get props => [context, id, userId];
}

//Hủy phiếu ký nội sinh
class CancelAssetHandoverEvent extends AssetHandoverEvent {
  final BuildContext context;
  final String id;

  const CancelAssetHandoverEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}
