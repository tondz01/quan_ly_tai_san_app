import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
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
  final List<SignatoryDto> listSignatory;

  const CreateDieuDongEvent(this.context, this.request, this.requestDetail, this.listSignatory);

  @override
  List<Object> get props => [context, request, requestDetail, listSignatory];
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

//Cập nhập trạng thái phiếu ký nội sinh
class UpdateSigningStatusEvent extends DieuDongTaiSanEvent {
  final BuildContext context;
  final String id;
  final String userId;

  const UpdateSigningStatusEvent(this.context, this.id, this.userId);

  @override
  List<Object?> get props => [context, id, userId];
}

//Hủy phiếu ký nội sinh
class CancelDieuDongTaiSanEvent extends DieuDongTaiSanEvent {
  final BuildContext context;
  final String id;

  const CancelDieuDongTaiSanEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}
