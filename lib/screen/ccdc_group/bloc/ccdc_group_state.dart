import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';

abstract class CcdcGroupState extends Equatable {
  const CcdcGroupState();

  @override
  List<Object?> get props => [];
}

class CcdcGroupInitialState extends CcdcGroupState {}

class CcdcGroupLoadingState extends CcdcGroupState {}

class CcdcGroupLoadingDismissState extends CcdcGroupState {}

class GetListCcdcGroupSuccessState extends CcdcGroupState {
  final List<CcdcGroup> data;

  const GetListCcdcGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateCcdcGroupSuccessState extends CcdcGroupState {
  final String data;

  const CreateCcdcGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateCcdcGroupBatchSuccessState extends CcdcGroupState {
  final String message;
  const CreateCcdcGroupBatchSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

class CreateCcdcGroupBatchFailedState extends CcdcGroupState {
  final String title;
  final int? code;
  final String message;
  const CreateCcdcGroupBatchFailedState({required this.title, required this.code, required this.message});
  @override
  List<Object> get props => [title, code!, message];
}

class GetListCcdcGroupFailedState extends CcdcGroupState {
  final String title;
  final int? code;
  final String message;

  const GetListCcdcGroupFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class CreateCcdcGroupFailedState extends CcdcGroupState {
  final String title;
  final int? code;
  final String message;

  const CreateCcdcGroupFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//UPDATE
class UpdateCcdcGroupSuccessState extends CcdcGroupState {
  final String data;

  const UpdateCcdcGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//DELETE
class DeleteCcdcGroupSuccessState extends CcdcGroupState {
  final String data;

  const DeleteCcdcGroupSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends CcdcGroupState {
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
