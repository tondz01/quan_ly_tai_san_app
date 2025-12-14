import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/model/current_status.dart';

abstract class CurrentStatusEvent extends Equatable {
  const CurrentStatusEvent();
}

class GetListCurrentStatusEvent extends CurrentStatusEvent {
  final BuildContext context;

  const GetListCurrentStatusEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CreateCurrentStatusEvent extends CurrentStatusEvent {
  final BuildContext context;
  final CurrentStatus params;

  const CreateCurrentStatusEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
}

class CreateCurrentStatusBatchEvent extends CurrentStatusEvent {
  final List<CurrentStatus> params;

  const CreateCurrentStatusBatchEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateCurrentStatusEvent extends CurrentStatusEvent {
  final BuildContext context;
  final CurrentStatus params;
  final String id;

  const UpdateCurrentStatusEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class DeleteCurrentStatusEvent extends CurrentStatusEvent {
  final BuildContext context;
  final String id;

  const DeleteCurrentStatusEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}

class DeleteCurrentStatusBatchEvent extends CurrentStatusEvent {
  final List<String> ids;

  const DeleteCurrentStatusBatchEvent(this.ids);

  @override
  List<Object?> get props => [ids];
}


