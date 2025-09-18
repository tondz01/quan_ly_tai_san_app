import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();
  @override
  List<Object?> get props => [];
}

class GetListProjectEvent extends ProjectEvent {
  final String idCongTy;
  const GetListProjectEvent(this.idCongTy);
  @override
  List<Object?> get props => [idCongTy];
}

class AddProjectEvent extends ProjectEvent {
  final DuAn project;
  const AddProjectEvent(this.project);
  @override
  List<Object?> get props => [project];
}

class CreateProjectBatchEvent extends ProjectEvent {
  final List<DuAn> params;

  const CreateProjectBatchEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateProjectEvent extends ProjectEvent {
  final DuAn project;
  const UpdateProjectEvent(this.project);
  @override
  List<Object?> get props => [project];
}

class DeleteProjectEvent extends ProjectEvent {
  final DuAn project;
  const DeleteProjectEvent(this.project);
  @override
  List<Object?> get props => [project];
}

class DeleteProjectBatchEvent extends ProjectEvent {
  final List<String> id;

  const DeleteProjectBatchEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchProject extends ProjectEvent {
  final String keyword;
  const SearchProject(this.keyword);
  @override
  List<Object?> get props => [keyword];
}
