import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/project.dart';
import 'project_event.dart';
import 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc() : super(ProjectInitial()) {
    on<LoadProjects>((event, emit) {
      emit(ProjectLoaded(List.from(event.projects)));
    });
    on<AddProject>((event, emit) {
      if (state is ProjectLoaded) {
        final projects = List<Project>.from((state as ProjectLoaded).projects);
        projects.add(event.project);
        emit(ProjectLoaded(projects));
      } else {
        emit(ProjectLoaded([event.project]));
      }
    });
    on<UpdateProject>((event, emit) {
      if (state is ProjectLoaded) {
        final projects = List<Project>.from((state as ProjectLoaded).projects);
        final index = projects.indexWhere((element) => element.code == event.project.code);
        if (index != -1) {
          projects[index] = event.project;
        }
        emit(ProjectLoaded(projects));
      }
    });
    on<DeleteProject>((event, emit) {
      if (state is ProjectLoaded) {
        final projects = List<Project>.from((state as ProjectLoaded).projects);
        projects.removeWhere((element) => element.code == event.project.code);
        emit(ProjectLoaded(projects));
      }
    });
  }
} 