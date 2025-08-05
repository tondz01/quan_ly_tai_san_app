import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/repository/request/asset_group_request.dart';

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
  final AssetGroupRequest params;

  const CreateAssetGroupEvent(this.params);

  @override
  List<Object?> get props => [params];
}
