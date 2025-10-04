import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/capital_source_by_asset_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/request/asset_request.dart';

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

class GetListKhauHaoEvent extends AssetManagementEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListKhauHaoEvent(this.context, this.idCongTy);

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

//Danh sách tài sản con
class GetListChildAssetsEvent extends AssetManagementEvent {
  final BuildContext context;
  final String idTaiSan;

  const GetListChildAssetsEvent(this.context, this.idTaiSan);

  @override
  List<Object?> get props => [context, idTaiSan];
}

class GetListDepartmentEvent extends AssetManagementEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListDepartmentEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

// GET ALL TÀI SẢN CON
class GetAllChildAssetsEvent extends AssetManagementEvent {
  final BuildContext context;
  final String idCongTy;

  const GetAllChildAssetsEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

class CreateAssetEvent extends AssetManagementEvent {
  final BuildContext context;
  final AssetRequest request;
  final List<ChildAssetDto> childAssets;

  const CreateAssetEvent(this.context, this.request, this.childAssets);

  @override
  List<Object> get props => [context, request, childAssets];
}

class CreateAssetBatchEvent extends AssetManagementEvent {
  final List<AssetManagementDto> params;

  const CreateAssetBatchEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateAssetEvent extends AssetManagementEvent {
  final AssetRequest request;
  final String id;

  const UpdateAssetEvent(this.request, this.id);

  @override
  List<Object> get props => [request];
}

class DeleteAssetEvent extends AssetManagementEvent {
  final BuildContext context;
  final String id;

  const DeleteAssetEvent(this.context, this.id);

  @override
  List<Object> get props => [context, id];
}

class DeleteAssetBatchEvent extends AssetManagementEvent {
  final List<String> id;

  const DeleteAssetBatchEvent(this.id);

  @override
  List<Object?> get props => [id];
}
