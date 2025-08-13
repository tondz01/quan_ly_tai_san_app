import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AssetHandoverEvent extends Equatable {
  const AssetHandoverEvent();
}

class GetListAssetHandoverEvent extends AssetHandoverEvent {
  final BuildContext context;

  const GetListAssetHandoverEvent(this.context);

  @override
  List<Object?> get props => [context];
}
