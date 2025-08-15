import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/chi_tiet_dieu_dong_request.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/lenh_dieu_dong_request.dart';

abstract class DieuDongTaiSanEvent extends Equatable {
  const DieuDongTaiSanEvent();
}

class GetListDieuDongTaiSanEvent extends DieuDongTaiSanEvent {
  final BuildContext context;
  final int typeAssetTransfer;
  final String idCongTy;

  const GetListDieuDongTaiSanEvent(
    this.context,
    this.typeAssetTransfer,
    this.idCongTy,
  );

  @override
  List<Object?> get props => [context, typeAssetTransfer];
}

class GetListAssetEvent extends DieuDongTaiSanEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListAssetEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

class GetDataDropdownEvent extends DieuDongTaiSanEvent {
  final BuildContext context;
  final String idCongTy;

  const GetDataDropdownEvent(this.context, this.idCongTy);

  @override
  List<Object?> get props => [context, idCongTy];
}

//TẠO BẢN ĐIỀU ĐỘNG
class CreateDieuDongEvent extends DieuDongTaiSanEvent {
  final BuildContext context;
  final LenhDieuDongRequest request;
  final List<ChiTietDieuDongRequest> requestDetail;

  const CreateDieuDongEvent(this.context, this.request, this.requestDetail);

  @override
  List<Object> get props => [context, request, requestDetail];
}

class UpdateDieuDongEvent extends DieuDongTaiSanEvent {
  final BuildContext context;
  final LenhDieuDongRequest params;
  final String id;

  const UpdateDieuDongEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class DeleteDieuDongEvent extends DieuDongTaiSanEvent {
  final BuildContext context;
  final String id;

  const DeleteDieuDongEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}
