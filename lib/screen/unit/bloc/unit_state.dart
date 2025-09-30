import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';

abstract class AssetGroupState extends Equatable {
  const AssetGroupState();

  @override
  List<Object?> get props => [];
}

class AssetGroupInitialState extends AssetGroupState {}

class AssetGroupLoadingState extends AssetGroupState {}

class AssetGroupLoadingDismissState extends AssetGroupState {}

class GetListAssetGroupSuccessState extends AssetGroupState {
  final List<AssetGroupDto> data;

  const GetListAssetGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateAssetGroupSuccessState extends AssetGroupState {

  const CreateAssetGroupSuccessState();

  @override
  List<Object> get props => [];
}

class GetListAssetGroupFailedState extends AssetGroupState {
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

class CreateAssetGroupFailedState extends AssetGroupState {
  final String title;
  final int? code;
  final String message;

  const CreateAssetGroupFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//UPDATE
class UpdateAssetGroupSuccessState extends AssetGroupState {
  final String data;

  const UpdateAssetGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//DELETE
class DeleteAssetGroupSuccessState extends AssetGroupState {
  final String data;

  const DeleteAssetGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends AssetGroupState {
  final String title;
  final int? code;
  final String message;

  const PutPostDeleteFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
