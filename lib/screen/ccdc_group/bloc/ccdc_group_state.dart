import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';

abstract class CcdcGroupState extends Equatable {
  const CcdcGroupState();

  @override
  List<Object?> get props => [];
}

class AssetGroupInitialState extends CcdcGroupState {}

class AssetGroupLoadingState extends CcdcGroupState {}

class AssetGroupLoadingDismissState extends CcdcGroupState {}

class GetListAssetGroupSuccessState extends CcdcGroupState {
  final List<AssetGroupDto> data;

  const GetListAssetGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateAssetGroupSuccessState extends CcdcGroupState {
  final String data;

  const CreateAssetGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListAssetGroupFailedState extends CcdcGroupState {
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

class CreateAssetGroupFailedState extends CcdcGroupState {
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
class UpdateAssetGroupSuccessState extends CcdcGroupState {
  final String data;

  const UpdateAssetGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//DELETE
class DeleteAssetGroupSuccessState extends CcdcGroupState {
  final String data;

  const DeleteAssetGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends CcdcGroupState {
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
