import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';

abstract class TypeAssetEvent extends Equatable {
  const TypeAssetEvent();
}

class GetListTypeAssetEvent extends TypeAssetEvent {
  final BuildContext context;

  const GetListTypeAssetEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CreateTypeAssetEvent extends TypeAssetEvent {
  final BuildContext context;
  final TypeAsset params;

  const CreateTypeAssetEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
}

class CreateTypeAssetBatchEvent extends TypeAssetEvent {
  final List<TypeAsset> params;

  const CreateTypeAssetBatchEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateTypeAssetEvent extends TypeAssetEvent {
  final BuildContext context;
  final TypeAsset params;
  final String id;

  const UpdateTypeAssetEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class DeleteTypeAssetEvent extends TypeAssetEvent {
  final BuildContext context;
  final String id;

  const DeleteTypeAssetEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}

class DeleteTypeAssetBatchEvent extends TypeAssetEvent {
  final List<String> ids;

  const DeleteTypeAssetBatchEvent(this.ids);

  @override
  List<Object?> get props => [ids];
}


