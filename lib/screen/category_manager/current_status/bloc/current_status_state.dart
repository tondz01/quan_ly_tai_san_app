import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/model/current_status.dart';

abstract class CurrentStatusState extends Equatable {
  const CurrentStatusState();

  @override
  List<Object?> get props => [];
}

class CurrentStatusInitialState extends CurrentStatusState {}

class CurrentStatusLoadingState extends CurrentStatusState {}

class CurrentStatusLoadingDismissState extends CurrentStatusState {}

class GetListCurrentStatusSuccessState extends CurrentStatusState {
  final List<CurrentStatus> data;

  const GetListCurrentStatusSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateCurrentStatusSuccessState extends CurrentStatusState {
  final String data;

  const CreateCurrentStatusSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListCurrentStatusFailedState extends CurrentStatusState {
  final String title;
  final int? code;
  final String message;

  const GetListCurrentStatusFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class CreateCurrentStatusFailedState extends CurrentStatusState {
  final String title;
  final int? code;
  final String message;

  const CreateCurrentStatusFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class UpdateCurrentStatusSuccessState extends CurrentStatusState {
  final String data;

  const UpdateCurrentStatusSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteCurrentStatusSuccessState extends CurrentStatusState {
  final String data;

  const DeleteCurrentStatusSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends CurrentStatusState {
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


