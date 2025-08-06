import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';

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
