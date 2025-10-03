import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/repository/role_repository.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/constants/role_constants.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import 'role_event.dart';
import 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  RoleBloc() : super(RolesInitialState()) {
    on<GetListRoleEvent>(_getListRole);
    on<CreateRoleEvent>(_createRole);
    on<CreateRoleBatchEvent>(_createRoleBatch);
    on<UpdateRoleEvent>(_updateRole);
    on<DeleteRoleEvent>(_deleteRole);
    on<DeleteRoleBatchEvent>(_deleteRoleBatch);
  }
  Future<void> _getListRole(GetListRoleEvent event, Emitter emit) async {
    emit(RolesLoadingState());
    try {
      Map<String, dynamic> result = await RoleRepository().getListRole(
        event.idCongTy,
      );
      emit(RolesLoadingDismissState());
      if (checkStatusCodeDone(result)) {
        emit(GetListRoleSuccessState(data: result['data']));
      } else {
        emit(
          GetListRoleFailedState(
            title: "notice",
            code: result['status_code'],
            message: result['message'] ?? RoleConstants.errorLoadRoles,
          ),
        );
      }
    } catch (e) {
      SGLog.error('RoleBloc', 'GetListRole error: $e');
      emit(RolesLoadingDismissState());
      emit(
        GetListRoleFailedState(
          title: "notice",
          code: Numeral.STATUS_CODE_DEFAULT,
          message: RoleConstants.errorLoadRoles,
        ),
      );
    }
  }

  Future<void> _createRole(CreateRoleEvent event, Emitter emit) async {
    emit(RolesLoadingState());
    try {
      final Map<String, dynamic> result = await RoleRepository().createRole(
        event.params,
      );

      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result)) {
        emit(CreateRoleSuccessState(data: (result['data'] ?? '').toString()));
      } else {
        emit(
          PutPostDeleteFailedState(
            title: 'Tạo chức vụ',
            code: statusCode,
            message: result['message'] ?? RoleConstants.errorCreateRole,
          ),
        );
      }
    } catch (e) {
      SGLog.error('RoleBloc', 'CreateRole error: $e');
      emit(
        PutPostDeleteFailedState(
          title: 'Tạo chức vụ',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: RoleConstants.errorCreateRole,
        ),
      );
    }
    emit(RolesLoadingDismissState());
  }

  Future<void> _createRoleBatch(
    CreateRoleBatchEvent event,
    Emitter emit,
  ) async {
    emit(RolesLoadingState());
    try {
      final Map<String, dynamic> result = await RoleRepository().saveRoleBatch(
        event.params,
      );

      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result)) {
        emit(CreateRoleSuccessState(data: (result['data'] ?? '').toString()));
      } else {
        String msg =
            'Thất bại khi lưu danh sách chức vụ: ${result['message'] ?? RoleConstants.errorCreateRole}';
        emit(
          PutPostDeleteFailedState(
            title: 'Tạo chức vụ',
            code: statusCode,
            message: msg,
          ),
        );
      }
    } catch (e) {
      SGLog.error('RoleBloc', 'CreateRoleBatch error: $e');
      emit(
        PutPostDeleteFailedState(
          title: 'Tạo chức vụ',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: RoleConstants.errorCreateRole,
        ),
      );
    }
    emit(RolesLoadingDismissState());
  }

  Future<void> _updateRole(UpdateRoleEvent event, Emitter emit) async {
    emit(RolesLoadingState());
    try {
      final Map<String, dynamic> result = await RoleRepository().updateRole(
        event.params,
      );

      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result)) {
        emit(UpdateRoleSuccessState(data: (result['data'] ?? '').toString()));
      } else {
        emit(
          PutPostDeleteFailedState(
            title: 'Cập nhật chức vụ',
            code: statusCode,
            message: result['message'] ?? RoleConstants.errorUpdateRole,
          ),
        );
      }
    } catch (e) {
      SGLog.error('RoleBloc', 'UpdateRole error: $e');
      emit(
        PutPostDeleteFailedState(
          title: 'Cập nhật chức vụ',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: RoleConstants.errorUpdateRole,
        ),
      );
    }
    emit(RolesLoadingDismissState());
  }

  Future<void> _deleteRole(DeleteRoleEvent event, Emitter emit) async {
    emit(RolesLoadingState());
    try {
      final Map<String, dynamic> result = await RoleRepository().deleteRole(
        event.id,
      );

      final int? statusCode = result['status_code'] as int?;
      if (checkStatusCodeDone(result)) {
        emit(DeleteRoleSuccessState(data: (result['data'] ?? '').toString()));
      } else {
        emit(
          PutPostDeleteFailedState(
            title: 'Xóa chức vụ',
            code: statusCode,
            message: result['message'] ?? RoleConstants.errorDeleteRole,
          ),
        );
      }
    } catch (e) {
      SGLog.error('RoleBloc', 'DeleteRole error: $e');
      emit(
        PutPostDeleteFailedState(
          title: 'Xóa chức vụ',
          code: Numeral.STATUS_CODE_DEFAULT,
          message: RoleConstants.errorDeleteRole,
        ),
      );
    }
    emit(RolesLoadingDismissState());
  }

  Future<void> _deleteRoleBatch(
    DeleteRoleBatchEvent event,
    Emitter emit,
  ) async {
    emit(RolesLoadingState());
    try {
      final Map<String, dynamic> result = await RoleRepository()
          .deleteRoleBatch(event.id);

      if (checkStatusCodeDone(result)) {
        emit(DeleteRoleBatchSuccess(RoleConstants.successDeleteRoleBatch));
      } else {
        emit(
          DeleteRoleBatchFailure(
            result['message'] ?? RoleConstants.errorDeleteRole,
          ),
        );
      }
    } catch (e) {
      SGLog.error('RoleBloc', 'DeleteRoleBatch error: $e');
      emit(DeleteRoleBatchFailure(RoleConstants.errorDeleteRole));
    }
    emit(RolesLoadingDismissState());
  }
}
