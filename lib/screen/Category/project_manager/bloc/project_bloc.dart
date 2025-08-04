import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/project.dart';
import 'project_event.dart';
import 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  List<Project> _allProjects = [];
  ProjectBloc() : super(ProjectInitial()) {
    on<LoadProjects>((event, emit) {
      _allProjects = List.from(event.projects);
      emit(ProjectLoaded(_allProjects));
    });
    on<SearchProject>((event, emit) {
      final searchLower = event.keyword.toLowerCase();
      final filtered =
          _allProjects.where((item) {
            bool nameMatch = AppUtility.fuzzySearch(
              item.name.toLowerCase(),
              searchLower,
            );

            bool staffIdMatch = item.code.toLowerCase().contains(searchLower);

            bool staffOwnerMatch = AppUtility.fuzzySearch(
              item.note.toLowerCase(),
              searchLower,
            );

            return nameMatch || staffIdMatch || staffOwnerMatch;
          }).toList();
      emit(ProjectLoaded(filtered));
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
        final index = projects.indexWhere(
          (element) => element.code == event.project.code,
        );
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
