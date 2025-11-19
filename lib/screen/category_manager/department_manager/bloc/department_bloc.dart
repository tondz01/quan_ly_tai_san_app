import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/repository/departments_repository.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import 'department_event.dart';
import 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  DepartmentBloc() : super(DepartmentsInitialState()) {
    on<GetListDepartmentEvent>(_getListDepartment);
    on<CreateDepartmentEvent>(_createDepartment);
    on<CreateDepartmentBatchEvent>(_createDepartmentBatch);
    on<UpdateDepartmentEvent>(_updateDepartment);
    on<DeleteDepartmentEvent>(_deleteDepartment);
    on<DeleteDepartmentBatchEvent>(_deleteDepartmentBatch);
  }
  Future<void> _getListDepartment(
    GetListDepartmentEvent event,
    Emitter emit,
  ) async {
    emit(DepartmentsLoadingState());
    try {
      Map<String, dynamic> result = await DepartmentRepository()
          .getListDepartment(event.idCongTy);
      emit(DepartmentsLoadingDismissState());
      if (checkStatusCodeDone(result)) {
        emit(GetListDepartmentSuccessState(data: result['data']));
      } else {
        emit(
          GetListDepartmentFailedState(
            title: "notice",
            code: result['status_code'],
            message: result['message'],
          ),
        );
      }
    } catch (e) {
      SGLog.error('DepartmentBloc', 'GetListDepartment error: $e');
      String msg = 'Thất bại khi tải danh sách chức vụ: $e';
      emit(DepartmentsLoadingDismissState());
      emit(
        GetListDepartmentFailedState(
          title: "notice",
          code: Numeral.STATUS_CODE_DEFAULT,
          message: msg,
        ),
      );
    }
  }

  Future<void> _createDepartment(
    CreateDepartmentEvent event,
    Emitter emit,
  ) async {
    emit(DepartmentsLoadingState());
    try {
      final Map<String, dynamic> result = await DepartmentRepository()
          .createDepartment(event.params);

      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result)) {
        emit(
          CreateDepartmentSuccessState(data: (result['data'] ?? '').toString()),
        );
      } else {
        emit(
          PutPostDeleteFailedState(
            title: 'Tạo chức vụ',
            code: statusCode,
            message: result['message'],
          ),
        );
      }
    } catch (e) {
      SGLog.error('DepartmentBloc', 'CreateDepartment error: $e');
      String msg = 'Thất bại khi tạo chức vụ: $e';
      emit(
        PutPostDeleteFailedState(
          title: 'Tạo chức vụ',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: msg,
        ),
      );
    }
    emit(DepartmentsLoadingDismissState());
  }

  Future<void> _createDepartmentBatch(
    CreateDepartmentBatchEvent event,
    Emitter emit,
  ) async {
    emit(DepartmentsLoadingState());
    try {
      final Map<String, dynamic> result = await DepartmentRepository()
          .saveDepartmentBatch(event.params);

      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result)) {
        emit(
          CreateDepartmentSuccessState(data: (result['data'] ?? '').toString()),
        );
      } else {
        String msg = 'Thất bại khi lưu danh sách chức vụ: ${result['message']}';
        emit(
          PutPostDeleteFailedState(
            title: 'Tạo chức vụ',
            code: statusCode,
            message: msg,
          ),
        );
      }
    } catch (e) {
      SGLog.error('DepartmentBloc', 'CreateDepartmentBatch error: $e');
      String msg = 'Thất bại khi lưu danh sách chức vụ: $e}';
      emit(
        PutPostDeleteFailedState(
          title: 'Tạo chức vụ',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: msg,
        ),
      );
    }
    emit(DepartmentsLoadingDismissState());
  }

  Future<void> _updateDepartment(
    UpdateDepartmentEvent event,
    Emitter emit,
  ) async {
    emit(DepartmentsLoadingState());
    try {
      final Map<String, dynamic> result = await DepartmentRepository()
          .updateDepartment(event.params);

      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result)) {
        emit(
          UpdateDepartmentSuccessState(data: (result['data'] ?? '').toString()),
        );
      } else {
        emit(
          PutPostDeleteFailedState(
            title: 'Cập nhật chức vụ',
            code: statusCode,
            message: result['message'],
          ),
        );
      }
    } catch (e) {
      SGLog.error('DepartmentBloc', 'UpdateDepartment error: $e');
      String msg = 'Thất bại khi cập nhật chức vụ: $e}';
      emit(
        PutPostDeleteFailedState(
          title: 'Cập nhật chức vụ',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: msg,
        ),
      );
    }
    emit(DepartmentsLoadingDismissState());
  }

  Future<void> _deleteDepartment(
    DeleteDepartmentEvent event,
    Emitter emit,
  ) async {
    emit(DepartmentsLoadingState());
    try {
      final Map<String, dynamic> result = await DepartmentRepository()
          .deleteDepartment(event.id);

      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result)) {
        emit(
          DeleteDepartmentSuccessState(data: (result['data'] ?? '').toString()),
        );
      } else {
        emit(
          PutPostDeleteFailedState(
            title: 'Xóa chức vụ',
            code: statusCode,
            message: result['message'],
          ),
        );
      }
    } catch (e) {
      SGLog.error('DepartmentBloc', 'DeleteDepartment error: $e');
      String msg = 'Thất bại khi cập nhật chức vụ: $e}';
      emit(
        PutPostDeleteFailedState(
          title: 'Xóa chức vụ',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: msg,
        ),
      );
    }
    emit(DepartmentsLoadingDismissState());
  }

  Future<void> _deleteDepartmentBatch(
    DeleteDepartmentBatchEvent event,
    Emitter emit,
  ) async {
    emit(DepartmentsLoadingState());
    try {
      final Map<String, dynamic> result = await DepartmentRepository()
          .deleteDepartmentBatch(event.id);

      if (checkStatusCodeDone(result)) {
        emit(DeleteDepartmentBatchSuccess("Xóa danh sách chức vụ thành công"));
      } else {
        emit(DeleteDepartmentBatchFailure(result['message']));
      }
    } catch (e) {
      SGLog.error('DepartmentBloc', 'DeleteDepartmentBatch error: $e');
      emit(
        DeleteDepartmentBatchFailure('Thất bại khi xóa danh sách chức vụ: $e'),
      );
    }
    emit(DepartmentsLoadingDismissState());
  }
}
