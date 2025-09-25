import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';

abstract class TypeAssetState extends Equatable {
  const TypeAssetState();

  @override
  List<Object?> get props => [];
}

class TypeAssetInitialState extends TypeAssetState {}

class TypeAssetLoadingState extends TypeAssetState {}

class TypeAssetLoadingDismissState extends TypeAssetState {}

class GetListTypeAssetSuccessState extends TypeAssetState {
  final List<TypeAsset> data;

  const GetListTypeAssetSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateTypeAssetSuccessState extends TypeAssetState {
  final String data;

  const CreateTypeAssetSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListTypeAssetFailedState extends TypeAssetState {
  final String title;
  final int? code;
  final String message;

  const GetListTypeAssetFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class CreateTypeAssetFailedState extends TypeAssetState {
  final String title;
  final int? code;
  final String message;

  const CreateTypeAssetFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class UpdateTypeAssetSuccessState extends TypeAssetState {
  final String data;

  const UpdateTypeAssetSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteTypeAssetSuccessState extends TypeAssetState {
  final String data;

  const DeleteTypeAssetSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends TypeAssetState {
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


