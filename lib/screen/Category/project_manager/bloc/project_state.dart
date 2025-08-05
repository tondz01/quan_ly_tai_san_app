import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/duan.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();
  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<DuAn> projects;
  const ProjectLoaded(this.projects);
  @override
  List<Object?> get props => [projects];
}

class ProjectError extends ProjectState {
  final String message;
  const ProjectError(this.message);
  @override
  List<Object?> get props => [message];
} 