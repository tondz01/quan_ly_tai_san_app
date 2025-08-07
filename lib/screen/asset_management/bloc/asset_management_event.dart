import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AssetManagementEvent extends Equatable {
  const AssetManagementEvent();
}

// Tài sản
class GetListAssetManagementEvent extends AssetManagementEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListAssetManagementEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

// Nhóm tài sản
class GetListAssetGroupEvent extends AssetManagementEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListAssetGroupEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

//Dự án
class GetListProjectEvent extends AssetManagementEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListProjectEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

//Nguồn kinh phí
class GetListCapitalSourceEvent extends AssetManagementEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListCapitalSourceEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

