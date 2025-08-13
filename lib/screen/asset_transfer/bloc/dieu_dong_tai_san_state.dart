import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';

import '../model/dieu_dong_tai_san_dto.dart';

abstract class DieuDongTaiSanState extends Equatable {
  const DieuDongTaiSanState();

  @override
  List<Object?> get props => [];
}

class DieuDongTaiSanInitialState extends DieuDongTaiSanState {}

class DieuDongTaiSanLoadingState extends DieuDongTaiSanState {}

class DieuDongTaiSanLoadingDismissState extends DieuDongTaiSanState {}

class GetListDieuDongTaiSanSuccessState extends DieuDongTaiSanState {
  final List<DieuDongTaiSanDto> data;

  const GetListDieuDongTaiSanSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListDieuDongTaiSanFailedState extends DieuDongTaiSanState {
  final String title;
  final int? code;
  final String message;

  const GetListDieuDongTaiSanFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//Get List Asset
class GetListAssetSuccessState extends DieuDongTaiSanState {
  final List<AssetManagementDto> data;
  const GetListAssetSuccessState({required this.data});
}

class GetListAssetFailedState extends DieuDongTaiSanState {
  final String title;
  final int? code;
  final String message;

  const GetListAssetFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
