import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart';

abstract class ReasonIncreaseState extends Equatable {
  const ReasonIncreaseState();

  @override
  List<Object?> get props => [];
}

class ReasonIncreaseInitialState extends ReasonIncreaseState {}

class ReasonIncreaseLoadingState extends ReasonIncreaseState {}

class ReasonIncreaseLoadingDismissState extends ReasonIncreaseState {}

class GetListReasonIncreaseSuccessState extends ReasonIncreaseState {
  final List<ReasonIncrease> data;

  const GetListReasonIncreaseSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateReasonIncreaseSuccessState extends ReasonIncreaseState {
  final String data;

  const CreateReasonIncreaseSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateReasonIncreaseBatchSuccessState extends ReasonIncreaseState {
  final String message;
  const CreateReasonIncreaseBatchSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

class CreateReasonIncreaseBatchFailedState extends ReasonIncreaseState {
  final String title;
  final int? code;
  final String message;
  const CreateReasonIncreaseBatchFailedState({required this.title, required this.code, required this.message});
  @override
  List<Object> get props => [title, code!, message];
}

class GetListReasonIncreaseFailedState extends ReasonIncreaseState {
  final String title;
  final int? code;
  final String message;

  const GetListReasonIncreaseFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class CreateReasonIncreaseFailedState extends ReasonIncreaseState {
  final String title;
  final int? code;
  final String message;

  const CreateReasonIncreaseFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//UPDATE
class UpdateReasonIncreaseSuccessState extends ReasonIncreaseState {
  final String data;

  const UpdateReasonIncreaseSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//DELETE
class DeleteReasonIncreaseSuccessState extends ReasonIncreaseState {
  final String data;

  const DeleteReasonIncreaseSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends ReasonIncreaseState {
  final String title;
  final int? code;
  final String message;

  const PutPostDeleteFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}
