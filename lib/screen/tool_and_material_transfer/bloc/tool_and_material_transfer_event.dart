import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ToolAndMaterialTransferEvent extends Equatable {
  const ToolAndMaterialTransferEvent();
}

class GetListToolAndMaterialTransferEvent extends ToolAndMaterialTransferEvent {
  final BuildContext context;

  const GetListToolAndMaterialTransferEvent(this.context);

  @override
  List<Object?> get props => [context];
}
