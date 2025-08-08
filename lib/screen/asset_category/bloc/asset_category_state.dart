import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';

abstract class AssetCategoryState extends Equatable {
  const AssetCategoryState();

  @override
  List<Object?> get props => [];
}

class AssetCategoryInitialState extends AssetCategoryState {}

class AssetCategoryLoadingState extends AssetCategoryState {}

class AssetCategoryLoadingDismissState extends AssetCategoryState {}

class GetListAssetCategorySuccessState extends AssetCategoryState {
  final List<AssetCategoryDto> data;

  const GetListAssetCategorySuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListAssetCategoryFailedState extends AssetCategoryState {
  final String title;
  final int? code;
  final String message;

  const GetListAssetCategoryFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class CreateAssetCategorySuccessState extends AssetCategoryState {
  final String data;

  const CreateAssetCategorySuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateAssetCategoryFailedState extends AssetCategoryState {
  final String title;
  final int? code;
  final String message;

  const CreateAssetCategoryFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//UPDATE
class UpdateAssetCategorySuccessState extends AssetCategoryState {
  final String data;

  const UpdateAssetCategorySuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//DELETE
class DeleteAssetCategorySuccessState extends AssetCategoryState {
  final String data;

  const DeleteAssetCategorySuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends AssetCategoryState {
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
