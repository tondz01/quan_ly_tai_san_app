import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AssetTransferEvent extends Equatable {
  const AssetTransferEvent();
}

class GetListAssetTransferEvent extends AssetTransferEvent {
  final BuildContext context;
  final int typeAssetTransfer;  

  const GetListAssetTransferEvent(this.context, this.typeAssetTransfer);

  @override
  List<Object?> get props => [context, typeAssetTransfer];
}
