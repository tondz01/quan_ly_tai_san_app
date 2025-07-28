import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';

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

  const GetListAssetHandoverSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListAssetHandoverFailedState extends AssetHandoverState {
  final String title;
  final int? code;
  final String message;

  const GetListAssetHandoverFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
