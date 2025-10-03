import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/constants/project_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/repository/project_repository.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
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
    emit(ProjectLoadingState());
    try {
      Map<String, dynamic> result = await repository.fetchProjects(
        event.idCongTy,
      );
      emit(ProjectLoadingDismissState());
      
      if (checkStatusCodeDone(result)) {
        emit(GetListProjectSuccessState(data: result['data']));
      } else {
        emit(
          GetListProjectFailedState(
            title: "notice",
            code: result['status_code'],
            message: result['message'] ?? ProjectConstants.errorLoadProjects,
          ),
        );
      }
    } catch (e) {
      SGLog.error('ProjectBloc', 'LoadProjects error: $e');
      emit(ProjectLoadingDismissState());
      emit(
        GetListProjectFailedState(
          title: "notice",
          code: Numeral.STATUS_CODE_DEFAULT,
          message: ProjectConstants.errorLoadProjects,
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
    try {
      final result = await repository.addProject(event.project);
      emit(ProjectLoadingDismissState());
      
      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result)) {
        emit(CreateProjectSuccessState(data: (result['data'] ?? '').toString()));
      } else {
        emit(
          PutPostDeleteFailedState(
            title: 'Tạo dự án',
            code: statusCode,
            message: result['message'] ?? ProjectConstants.errorCreateProject,
          ),
        );
      }
    } catch (e) {
      SGLog.error('ProjectBloc', 'AddProject error: $e');
      emit(
        PutPostDeleteFailedState(
          title: 'Tạo dự án',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: ProjectConstants.errorCreateProject,
        ),
      );
    }
    emit(ProjectLoadingDismissState());
  }

  Future<void> _createProjectBatch(
    CreateProjectBatchEvent event,
    Emitter emit,
  ) async {
    emit(ProjectLoadingState());
    try {
      final result = await repository.saveProjectBatch(event.params);
      emit(ProjectLoadingDismissState());
      
      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result) ||
          statusCode == Numeral.STATUS_CODE_SUCCESS_CREATE) {
        emit(CreateProjectSuccessState(data: (result['data'] ?? '').toString()));
      } else {
        String msg =
            'Thất bại khi lưu danh sách dự án: ${result['message'] ?? ProjectConstants.errorCreateProject}';
        emit(
          PutPostDeleteFailedState(
            title: 'Tạo dự án',
            code: statusCode,
            message: msg,
          ),
        );
      }
    } catch (e) {
      SGLog.error('ProjectBloc', 'CreateProjectBatch error: $e');
      emit(
        PutPostDeleteFailedState(
          title: 'Tạo dự án',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: ProjectConstants.errorCreateProject,
        ),
      );
    }
    emit(ProjectLoadingDismissState());
  }

  Future<void> _updateProject(UpdateProjectEvent event, Emitter emit) async {
    emit(ProjectLoadingState());
    try {
      final result = await repository.updateProject(event.project);
      emit(ProjectLoadingDismissState());
      
      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result)) {
        emit(UpdateProjectSuccessState(data: (result['data'] ?? '').toString()));
      } else {
        emit(
          PutPostDeleteFailedState(
            title: 'Cập nhật dự án',
            code: statusCode,
            message: result['message'] ?? ProjectConstants.errorUpdateProject,
          ),
        );
      }
    } catch (e) {
      SGLog.error('ProjectBloc', 'UpdateProject error: $e');
      emit(
        PutPostDeleteFailedState(
          title: 'Cập nhật dự án',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: ProjectConstants.errorUpdateProject,
        ),
      );
    }
    emit(ProjectLoadingDismissState());
  }

  Future<void> _deleteProject(DeleteProjectEvent event, Emitter emit) async {
    emit(ProjectLoadingState());
    try {
      final result = await repository.deleteProject(event.project.id ?? '');
      emit(ProjectLoadingDismissState());
      
      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result)) {
        emit(DeleteProjectSuccessState(data: (result['data'] ?? '').toString()));
      } else {
        emit(
          PutPostDeleteFailedState(
            title: 'Xóa dự án',
            code: statusCode,
            message: result['message'] ?? ProjectConstants.errorDeleteProject,
          ),
        );
      }
    } catch (e) {
      SGLog.error('ProjectBloc', 'DeleteProject error: $e');
      emit(
        PutPostDeleteFailedState(
          title: 'Xóa dự án',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: ProjectConstants.errorDeleteProject,
        ),
      );
    }
    emit(ProjectLoadingDismissState());
  }

  Future<void> _deleteProjectBatch(
    DeleteProjectBatchEvent event,
    Emitter emit,
  ) async {
    emit(ProjectLoadingState());
    try {
      final result = await repository.deleteProjectBatch(event.id);
      emit(ProjectLoadingDismissState());
      
      if (checkStatusCodeDone(result)) {
        emit(DeleteProjectBatchSuccess(ProjectConstants.successDeleteProjectBatch));
      } else {
        emit(
          DeleteProjectBatchFailure(
            result['message'] ?? ProjectConstants.errorDeleteProject,
          ),
        );
      }
    } catch (e) {
      SGLog.error('ProjectBloc', 'DeleteProjectBatch error: $e');
      emit(DeleteProjectBatchFailure(ProjectConstants.errorDeleteProject));
    }
    emit(ProjectLoadingDismissState());
  }
}
