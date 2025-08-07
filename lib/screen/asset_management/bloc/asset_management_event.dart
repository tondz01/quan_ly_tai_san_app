import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AssetManagementEvent extends Equatable {
  const AssetManagementEvent();
}

class GetListAssetManagementEvent extends AssetManagementEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListAssetManagementEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}
class GetListAssetGroupEvent extends AssetManagementEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListAssetGroupEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}
class GetListProjectEvent extends AssetManagementEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListProjectEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}