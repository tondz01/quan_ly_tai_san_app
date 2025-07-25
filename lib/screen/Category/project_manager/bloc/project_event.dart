import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/project.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();
  @override
  List<Object?> get props => [];
}

class LoadProjects extends ProjectEvent {
  final List<Project> projects;
  const LoadProjects(this.projects);
  @override
  List<Object?> get props => [projects];
}

class AddProject extends ProjectEvent {
  final Project project;
  const AddProject(this.project);
  @override
  List<Object?> get props => [project];
}

class UpdateProject extends ProjectEvent {
  final Project project;
  const UpdateProject(this.project);
  @override
  List<Object?> get props => [project];
}

class DeleteProject extends ProjectEvent {
  final Project project;
  const DeleteProject(this.project);
  @override
  List<Object?> get props => [project];
}

class SearchProject extends ProjectEvent {
  final String keyword;
  const SearchProject(this.keyword);
  @override
  List<Object?> get props => [keyword];
} 