import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';

abstract class AssetTransferState extends Equatable {
  const AssetTransferState();

  @override
  List<Object?> get props => [];
}

class AssetTransferInitialState extends AssetTransferState {}

class AssetTransferLoadingState extends AssetTransferState {}

class AssetTransferLoadingDismissState extends AssetTransferState {}

class GetListAssetTransferSuccessState extends AssetTransferState {
  final List<AssetTransferDto> data;

  const GetListAssetTransferSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListAssetTransferFailedState extends AssetTransferState {
  final String title;
  final int? code;
  final String message;

  const GetListAssetTransferFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
