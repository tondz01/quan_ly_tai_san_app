import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/request/asset_group_request.dart';

abstract class AssetGroupEvent extends Equatable {
  const AssetGroupEvent();
}

class GetListAssetGroupEvent extends AssetGroupEvent {
  final BuildContext context;

  const GetListAssetGroupEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CreateAssetGroupEvent extends AssetGroupEvent {
  final BuildContext context;
  final AssetGroupRequest params;

  const CreateAssetGroupEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
}

class CreateAssetGroupBatchEvent extends AssetGroupEvent {
  final List<AssetGroupDto> params;

  const CreateAssetGroupBatchEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateAssetGroupEvent extends AssetGroupEvent {
  final BuildContext context;
  final AssetGroupRequest params;
  final String id;

  const UpdateAssetGroupEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class DeleteAssetGroupEvent extends AssetGroupEvent {
  final BuildContext context;
  final String id;

  const DeleteAssetGroupEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}

class DeleteAssetGroupBatchEvent extends AssetGroupEvent {
  final Map<String, dynamic> id;

  const DeleteAssetGroupBatchEvent(this.id);

  @override
  List<Object?> get props => [id];
}