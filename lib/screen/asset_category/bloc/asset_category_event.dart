import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
