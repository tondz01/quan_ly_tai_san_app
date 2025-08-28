import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/request/asset_group_request.dart';

abstract class CcdcGroupEvent extends Equatable {
  const CcdcGroupEvent();
}

class GetListAssetGroupEvent extends CcdcGroupEvent {
  final BuildContext context;

  const GetListAssetGroupEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CreateAssetGroupEvent extends CcdcGroupEvent {
  final BuildContext context;
  final AssetGroupRequest params;

  const CreateAssetGroupEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
}

class UpdateAssetGroupEvent extends CcdcGroupEvent {
  final BuildContext context;
  final AssetGroupRequest params;
  final String id;

  const UpdateAssetGroupEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class DeleteAssetGroupEvent extends CcdcGroupEvent {
  final BuildContext context;
  final String id;

  const DeleteAssetGroupEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}
