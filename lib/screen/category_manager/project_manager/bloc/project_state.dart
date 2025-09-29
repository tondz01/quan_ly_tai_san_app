import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitialState extends ProjectState {}

class ProjectLoadingState extends ProjectState {}

class ProjectLoadingDismissState extends ProjectState {}

class GetListProjectSuccessState extends ProjectState {
  final List<DuAn> data;

  const GetListProjectSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListProjectFailedState extends ProjectState {
  final String title;
  final int? code;
  final String message;

  const GetListProjectFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code ?? 0, message];
}

//CREATE
class CreateProjectSuccessState extends ProjectState {
  final String data;

  const CreateProjectSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateProjectFailedState extends ProjectState {
  final String title;
  final int? code;
  final String message;

  const CreateProjectFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code ?? 0, message];
}

//UPDATE
class UpdateProjectSuccessState extends ProjectState {
  final String data;

  const UpdateProjectSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//DELETE
class DeleteProjectSuccessState extends ProjectState {
  final String data;

  const DeleteProjectSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends ProjectState {
  final String title;
  final int? code;
  final String message;

  const PutPostDeleteFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code ?? 0, message];
}

// Additional states for better error handling
class DeleteProjectBatchSuccess extends ProjectState {
  final String message;
  const DeleteProjectBatchSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class DeleteProjectBatchFailure extends ProjectState {
  final String message;
  const DeleteProjectBatchFailure(this.message);
  @override
  List<Object?> get props => [message];
}
