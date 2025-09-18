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

class AddProjectSuccessState extends ProjectState {
  final dynamic data;
  const AddProjectSuccessState(this.data);
}

class UpdateProjectSuccessState extends ProjectState {
  final dynamic data;
  const UpdateProjectSuccessState(this.data);
}

class DeleteProjectSuccessState extends ProjectState {
  final dynamic data;
  const DeleteProjectSuccessState(this.data);
}

class GetListProjectSuccsessState extends ProjectState {
  final List<DuAn> data;
  const GetListProjectSuccsessState(this.data);
  @override
  List<Object?> get props => [data];
}

class ProjectErrorState extends ProjectState {
  final String message;
  const ProjectErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
