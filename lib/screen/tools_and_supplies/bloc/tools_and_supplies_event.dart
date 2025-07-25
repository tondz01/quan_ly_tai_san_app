import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ToolsAndSuppliesEvent extends Equatable {
  const ToolsAndSuppliesEvent();
}

class GetListToolsAndSuppliesEvent extends ToolsAndSuppliesEvent {
  final BuildContext context;

  const GetListToolsAndSuppliesEvent(this.context);

  @override
  List<Object?> get props => [context];
}
