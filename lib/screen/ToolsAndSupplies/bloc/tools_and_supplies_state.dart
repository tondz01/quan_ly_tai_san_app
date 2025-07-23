import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/model/tools_and_supplies_dto.dart';

abstract class ToolsAndSuppliesState extends Equatable {
  const ToolsAndSuppliesState();

  @override
  List<Object?> get props => [];
}

class ToolsAndSuppliesInitialState extends ToolsAndSuppliesState {}

class ToolsAndSuppliesLoadingState extends ToolsAndSuppliesState {}

class ToolsAndSuppliesLoadingDismissState extends ToolsAndSuppliesState {}

class GetListToolsAndSuppliesSuccessState extends ToolsAndSuppliesState {
  final List<ToolsAndSuppliesDto> data;

  const GetListToolsAndSuppliesSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListToolsAndSuppliesFailedState extends ToolsAndSuppliesState {
  final String title;
  final int? code;
  final String message;

  const GetListToolsAndSuppliesFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
