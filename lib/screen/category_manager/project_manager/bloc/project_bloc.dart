import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/providers/project_provider.dart';
import 'project_event.dart';
import 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  List<DuAn> _allProjects = [];
  final provider = ProjectProvider();
  ProjectBloc() : super(ProjectInitial()) {
    on<LoadProjects>((event, emit) async {
      _allProjects = await provider.fetchProjects();
      emit(ProjectLoaded(_allProjects));
    });
    on<SearchProject>((event, emit) {
      final searchLower = event.keyword.toLowerCase();
      final filtered =
          _allProjects.where((item) {
            bool nameMatch = AppUtility.fuzzySearch(
              item.tenDuAn?.toLowerCase() ?? '',
              searchLower,
            );

            bool staffIdMatch = item.id?.toLowerCase().contains(searchLower) ?? false;

            bool staffOwnerMatch = AppUtility.fuzzySearch(
              item.ghiChu?.toLowerCase() ?? '',
              searchLower,
            );

            return nameMatch || staffIdMatch || staffOwnerMatch;
          }).toList();
      emit(ProjectLoaded(filtered));
    });
    on<AddProject>((event, emit) async {
      if (state is ProjectLoaded) {
        await provider.addProject(event.project);
        add(LoadProjects());
      } else {
        emit(ProjectLoaded([event.project]));
      }
    });
    on<UpdateProject>((event, emit) async {
      if (state is ProjectLoaded) {
        await provider.updateProject(event.project);
        add(LoadProjects());
      } else {
        emit(ProjectLoaded([event.project]));
      }
    });
    on<DeleteProject>((event, emit) async {
      if (state is ProjectLoaded) {
        await provider.deleteProject(event.project.id ?? '');
        add(LoadProjects());
      } else {
        emit(ProjectLoaded([event.project]));
      }
    });
  }
}
