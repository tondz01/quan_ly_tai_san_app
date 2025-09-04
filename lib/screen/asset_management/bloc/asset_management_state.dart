import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_depreciation_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';

abstract class AssetManagementState extends Equatable {
  const AssetManagementState();

  @override
  List<Object?> get props => [];
}

class AssetManagementInitialState extends AssetManagementState {}

class AssetManagementLoadingState extends AssetManagementState {}

class AssetManagementLoadingDismissState extends AssetManagementState {}

class GetListAssetManagementSuccessState extends AssetManagementState {
  final List<AssetManagementDto> data;
  const GetListAssetManagementSuccessState({required this.data});
}

class AssetManagementFailedState extends AssetManagementState {
  final String title;
  final int? code;
  final String message;

  const AssetManagementFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

// Danh sách tài sản con
class GetListChildAssetsSuccessState extends AssetManagementState {
  final List<ChildAssetDto> data;
  const GetListChildAssetsSuccessState({required this.data});
}

class GetListChildAssetsFailedState extends AssetManagementState {
  final String title;
  final int? code;
  final String message;

  const GetListChildAssetsFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class GetListAssetManagementFailedState extends AssetManagementState {
  final String title;
  final int? code;
  final String message;

  const GetListAssetManagementFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class GetListAssetGroupSuccessState extends AssetManagementState {
  final List<AssetGroupDto> data;

  const GetListAssetGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListAssetGroupFailedState extends AssetManagementState {
  final String title;
  final int? code;
  final String message;

  const GetListAssetGroupFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

// KHẤU HAO
class GetListKhauHaoSuccessState extends AssetManagementState {
  final List<AssetDepreciationDto> data;

  const GetListKhauHaoSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListKhauHaoFailedState extends AssetManagementState {
  final String title;
  final int? code;
  final String message;

  const GetListKhauHaoFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
class GetListProjectSuccessState extends AssetManagementState {
  final List<DuAn> data;

  const GetListProjectSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListProjectFailedState extends AssetManagementState {
  final String title;
  final int? code;
  final String message;

  const GetListProjectFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//NGUỒN KINH PHÍ
class GetListCapitalSourceSuccessState extends AssetManagementState {
  final List<NguonKinhPhi> data;

  const GetListCapitalSourceSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListCapitalSourceFailedState extends AssetManagementState {
  final String title;
  final int? code;
  final String message;

  const GetListCapitalSourceFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class GetListDepartmentSuccessState extends AssetManagementState {
  final List<PhongBan> data;

  const GetListDepartmentSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}
class GetAllChildAssetsSuccessState extends AssetManagementState {
  final List<ChildAssetDto> data;

  const GetAllChildAssetsSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListDepartmentFailedState extends AssetManagementState {
  final String title;
  final int? code;
  final String message;

  const GetListDepartmentFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
class GetAllChildAssetsFailedState extends AssetManagementState {
  final String title;
  final int? code;
  final String message;

  const GetAllChildAssetsFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//CREATED
class CreateAssetSuccessState extends AssetManagementState {
  const CreateAssetSuccessState();

  @override
  List<Object> get props => [];
}
class UpdateAssetSuccessState extends AssetManagementState {
  const UpdateAssetSuccessState();

  @override
  List<Object> get props => [];
}
class DeleteAssetSuccessState extends AssetManagementState {
  const DeleteAssetSuccessState();

  @override
  List<Object> get props => [];
}

class CreateAssetFailedState extends AssetManagementState {
  final String title;
  final int? code;
  final String message;

  const CreateAssetFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
class UpdateAndDeleteAssetFailedState extends AssetManagementState {
  final String title;
  final int? code;
  final String message;

  const UpdateAndDeleteAssetFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
