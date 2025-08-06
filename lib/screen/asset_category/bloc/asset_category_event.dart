import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AssetCategoryEvent extends Equatable {
  const AssetCategoryEvent();
}

class GetListAssetCategoryEvent extends AssetCategoryEvent {
  final BuildContext context;

  const GetListAssetCategoryEvent(this.context);

  @override
  List<Object?> get props => [context];
}
