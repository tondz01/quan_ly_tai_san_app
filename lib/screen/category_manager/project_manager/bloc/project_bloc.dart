import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/repository/project_repository.dart';
import 'project_event.dart';
import 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final repository = ProjectRepository();
  ProjectBloc() : super(ProjectInitialState()) {
    on<GetListProjectEvent>(_loadProjects);
    // on<SearchProject>(_searchProject);
    on<AddProjectEvent>(_addProject);
    on<CreateProjectBatchEvent>(_createProjectBatch);
    on<UpdateProjectEvent>(_updateProject);
    on<DeleteProjectEvent>(_deleteProject);
    on<DeleteProjectBatchEvent>(_deleteProjectBatch);
  }

  Future<void> _loadProjects(GetListProjectEvent event, Emitter emit) async {
    emit(ProjectInitialState());
    emit(ProjectLoadingState());
    Map<String, dynamic> result = await repository.fetchProjects(
      event.idCongTy,
    );
    emit(ProjectLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListProjectSuccsessState(result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListProjectFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  // void _searchProject(SearchProject event, Emitter emit) {
  //   final searchLower = event.keyword.toLowerCase();
  //   final filtered =
  //       _allProjects.where((item) {
  //         bool nameMatch = AppUtility.fuzzySearch(
  //           item.tenDuAn?.toLowerCase() ?? '',
  //           searchLower,
  //         );
  //         bool staffIdMatch =
  //             item.id?.toLowerCase().contains(searchLower) ?? false;
  //         bool staffOwnerMatch = AppUtility.fuzzySearch(
  //           item.ghiChu?.toLowerCase() ?? '',
  //           searchLower,
  //         );
  //         return nameMatch || staffIdMatch || staffOwnerMatch;
  //       }).toList();
  //   emit(GetListProjectState(filtered));
  // }

  Future<void> _addProject(AddProjectEvent event, Emitter emit) async {
    emit(ProjectLoadingState());
    final result = await repository.addProject(event.project);
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS ||
        result['status_code'] == Numeral.STATUS_CODE_SUCCESS_CREATE) {
      emit(AddProjectSuccessState(result['data']));
    } else {
      emit(ProjectErrorState('Thêm dự án thất bại: ${result['message']}'));
    }
    emit(ProjectLoadingDismissState());
  }

  Future<void> _createProjectBatch(
    CreateProjectBatchEvent event,
    Emitter emit,
  ) async {
    emit(ProjectLoadingState());
    final result = await repository.saveProjectBatch(event.params);
    emit(ProjectLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS ||
        result['status_code'] == Numeral.STATUS_CODE_SUCCESS_CREATE) {
      emit(AddProjectSuccessState(result['data']));
    } else {
      emit(
        ProjectErrorState(
          'Thêm danh sách dự án thất bại: ${result['message']}',
        ),
      );
    }
  }

  Future<void> _updateProject(UpdateProjectEvent event, Emitter emit) async {
    emit(ProjectLoadingState());
    final result = await repository.updateProject(event.project);
    emit(ProjectLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateProjectSuccessState(result['data']));
    } else {
      emit(ProjectErrorState('Cập nhật dự án thất bại: ${result['message']}'));
    }
  }

  Future<void> _deleteProject(DeleteProjectEvent event, Emitter emit) async {
    emit(ProjectLoadingState());
    final result = await repository.deleteProject(event.project.id ?? '');
    emit(ProjectLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(DeleteProjectSuccessState(result['data']));
    } else {
      emit(ProjectErrorState('Xóa dự án thất bại: ${result['message']}'));
    }
  }

  Future<void> _deleteProjectBatch(
    DeleteProjectBatchEvent event,
    Emitter emit,
  ) async {
    emit(ProjectLoadingState());
    final result = await repository.deleteProjectBatch(event.id);
    emit(ProjectLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(DeleteProjectSuccessState(result['data']));
    } else {
      emit(
        ProjectErrorState('Xóa danh sách dự án thất bại: ${result['message']}'),
      );
    }
  }
}
