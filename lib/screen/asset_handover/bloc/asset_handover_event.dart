import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';

abstract class AssetHandoverEvent extends Equatable {
  const AssetHandoverEvent();
}

class GetListAssetHandoverEvent extends AssetHandoverEvent {
  final BuildContext context;

  const GetListAssetHandoverEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CreateAssetHandoverEvent extends AssetHandoverEvent {
  final BuildContext context;
  final Map<String, dynamic> request;

  const CreateAssetHandoverEvent(this.context, this.request);

  @override
  List<Object?> get props => [context, request];
}
