import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/request/tools_and_suppliest_request.dart';

abstract class ToolsAndSuppliesEvent extends Equatable {
  const ToolsAndSuppliesEvent();
}

class GetListToolsAndSuppliesEvent extends ToolsAndSuppliesEvent {
  final BuildContext context;

  const GetListToolsAndSuppliesEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CreateToolsAndSuppliesEvent extends ToolsAndSuppliesEvent {
  final ToolsAndSuppliesRequest params;

  const CreateToolsAndSuppliesEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateToolsAndSuppliesEvent extends ToolsAndSuppliesEvent {
  final ToolsAndSuppliesRequest params;

  const UpdateToolsAndSuppliesEvent(this.params);

  @override
  List<Object?> get props => [params];
}