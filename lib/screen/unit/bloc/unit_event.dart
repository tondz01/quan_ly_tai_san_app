import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';

abstract class UnitEvent extends Equatable {
  const UnitEvent();
}

class GetListUnitEvent extends UnitEvent {
  final BuildContext context;

  const GetListUnitEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CreateUnitEvent extends UnitEvent {
  final BuildContext context;
  final UnitDto params;

  const CreateUnitEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
}

class CreateUnitBatchEvent extends UnitEvent {
  final List<UnitDto> params;

  const CreateUnitBatchEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateUnitEvent extends UnitEvent {
  final BuildContext context;
  final UnitDto params;
  final String id;

  const UpdateUnitEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class DeleteUnitEvent extends UnitEvent {
  final BuildContext context;
  final String id;

  const DeleteUnitEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}

class DeleteUnitBatchEvent extends UnitEvent {
  final List<String> ids;

  const DeleteUnitBatchEvent(this.ids);

  @override
  List<Object?> get props => [ids];
}