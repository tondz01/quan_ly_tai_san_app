import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';

abstract class CcdcGroupEvent extends Equatable {
  const CcdcGroupEvent();
}

class GetListCcdcGroupEvent extends CcdcGroupEvent {
  final BuildContext context;

  const GetListCcdcGroupEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CreateCcdcGroupEvent extends CcdcGroupEvent {
  final BuildContext context;
  final CcdcGroup params;

  const CreateCcdcGroupEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
}

class UpdateCcdcGroupEvent extends CcdcGroupEvent {
  final BuildContext context;
  final CcdcGroup params;
  final String id;

  const UpdateCcdcGroupEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class DeleteCcdcGroupEvent extends CcdcGroupEvent {
  final BuildContext context;
  final String id;

  const DeleteCcdcGroupEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}
