import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/request/asset_category_request.dart';

abstract class AssetCategoryEvent extends Equatable {
  const AssetCategoryEvent();
}

class GetListAssetCategoryEvent extends AssetCategoryEvent {
  final BuildContext context;
  final String idCongty;

  const GetListAssetCategoryEvent(this.context, this.idCongty);

  @override
  List<Object?> get props => [context, idCongty];
}

class CreateAssetCategoryEvent extends AssetCategoryEvent {
  final BuildContext context;
  final AssetCategoryRequest params;

  const CreateAssetCategoryEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
}

class UpdateAssetCategoryEvent extends AssetCategoryEvent {
  final BuildContext context;
  final AssetCategoryRequest params;
  final String id;

  const UpdateAssetCategoryEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class DeleteAssetCategoryEvent extends AssetCategoryEvent {
  final BuildContext context;
  final String id;

  const DeleteAssetCategoryEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}
