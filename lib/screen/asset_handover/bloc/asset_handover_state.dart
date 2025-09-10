import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';

abstract class AssetHandoverState extends Equatable {
  const AssetHandoverState();

  @override
  List<Object?> get props => [];
}

class AssetHandoverInitialState extends AssetHandoverState {}

class AssetHandoverLoadingState extends AssetHandoverState {}

class AssetHandoverLoadingDismissState extends AssetHandoverState {}

class GetListAssetHandoverSuccessState extends AssetHandoverState {
  final List<AssetHandoverDto> data;
  final List<PhongBan> dataDepartment;
  final List<NhanVien> dataStaff;
  final List<DieuDongTaiSanDto> dataAssetTransfer;

  const GetListAssetHandoverSuccessState({
    required this.data,
    required this.dataDepartment,
    required this.dataStaff,
    required this.dataAssetTransfer,
  });

  @override
  List<Object> get props => [data];
}

class CreateAssetHandoverSuccessState extends AssetHandoverState {
  final String data;

  const CreateAssetHandoverSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class UpdateAssetHandoverSuccessState extends AssetHandoverState {
  final String data;

  const UpdateAssetHandoverSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteAssetHandoverSuccessState extends AssetHandoverState {
  final String data;

  const DeleteAssetHandoverSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//Cập nhập trạng thái phiếu ký nội sinh success
class UpdateSigningStatusSuccessState extends AssetHandoverState {
  final bool isUpdateOwnershipUnit;
  const UpdateSigningStatusSuccessState({required this.isUpdateOwnershipUnit});

  @override
  List<Object> get props => [isUpdateOwnershipUnit];
}

class CancelAssetHandoverSuccessState extends AssetHandoverState {
  const CancelAssetHandoverSuccessState();

  @override
  List<Object> get props => [];
}

class ErrorState extends AssetHandoverState {
  final String title;
  final int? code;
  final String message;

  const ErrorState({required this.title, this.code, required this.message});

  @override
  List<Object> get props => [title, code ?? 0, message];
}
