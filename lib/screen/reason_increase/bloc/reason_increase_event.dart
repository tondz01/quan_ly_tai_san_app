import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart';

abstract class ReasonIncreaseEvent extends Equatable {
  const ReasonIncreaseEvent();
}

class GetListReasonIncreaseEvent extends ReasonIncreaseEvent {
  final BuildContext context;

  const GetListReasonIncreaseEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CreateReasonIncreaseEvent extends ReasonIncreaseEvent {
  final BuildContext context;
  final ReasonIncrease params;

  const CreateReasonIncreaseEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
}

class CreateReasonIncreaseBatchEvent extends ReasonIncreaseEvent {
  final List<ReasonIncrease> params;

  const CreateReasonIncreaseBatchEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateReasonIncreaseEvent extends ReasonIncreaseEvent {
  final BuildContext context;
  final ReasonIncrease params;
  final String id;

  const UpdateReasonIncreaseEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class DeleteReasonIncreaseEvent extends ReasonIncreaseEvent {
  final BuildContext context;
  final String id;

  const DeleteReasonIncreaseEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}

class DeleteReasonIncreaseBatchEvent extends ReasonIncreaseEvent {
  final List<String> ids;

  const DeleteReasonIncreaseBatchEvent(this.ids);

  @override
  List<Object?> get props => [ids];
}
