import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/repository/role_repository.dart';

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
    emit(RolesInitialState());
    emit(RolesLoadingState());
    Map<String, dynamic> result = await RoleRepository().getListRole(
      event.idCongTy,
    );
    emit(RolesLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetListRoleSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetListRoleFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _createRole(CreateRoleEvent event, Emitter emit) async {
    emit(RolesLoadingState());

    final Map<String, dynamic> result = await RoleRepository().createRole(
      event.params,
    );

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(CreateRoleSuccessState(data: (result['data'] ?? '').toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'Tạo chức vụ',
          code: statusCode,
          message: 'Thất bại khi tạo chức vụ',
        ),
      );
    }
    emit(RolesLoadingDismissState());
  }
  Future<void> _createRoleBatch(CreateRoleBatchEvent event, Emitter emit) async {
    emit(RolesLoadingState());

    final Map<String, dynamic> result = await RoleRepository().saveRoleBatch(
      event.params,
    );

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(CreateRoleSuccessState(data: (result['data'] ?? '').toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'Tạo chức vụ',
          code: statusCode,
          message: 'Thất bại khi tạo chức vụ',
        ),
      );
    }
    emit(RolesLoadingDismissState());
  }

  Future<void> _updateRole(UpdateRoleEvent event, Emitter emit) async {
    emit(RolesLoadingState());

    final Map<String, dynamic> result = await RoleRepository().updateRole(
      event.params
    );

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(UpdateRoleSuccessState(data: (result['data'] ?? '').toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'Cập nhật chức vụ',
          code: statusCode,
          message: 'Thất bại khi cập nhật chức vụ',
        ),
      );
    }
    emit(RolesLoadingDismissState());
  }

  Future<void> _deleteRole(DeleteRoleEvent event, Emitter emit) async {
    emit(RolesLoadingState());

    final Map<String, dynamic> result = await RoleRepository().deleteRole(
      event.id,
    );

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(DeleteRoleSuccessState(data: (result['data'] ?? '').toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'Xóa chức vụ',
          code: statusCode,
          message: 'Thất bại khi xóa chức vụ',
        ),
      );
    }
    emit(RolesLoadingDismissState());
  }

  Future<void> _deleteRoleBatch(DeleteRoleBatchEvent event, Emitter emit) async {
    emit(RolesLoadingState());

    final Map<String, dynamic> result = await RoleRepository().deleteRoleBatch(
      event.id,
    );

    final int? statusCode = result['status_code'] as int?;
    if (statusCode == Numeral.STATUS_CODE_SUCCESS) {
      emit(DeleteRoleSuccessState(data: (result['data'] ?? '').toString()));
    } else {
      emit(
        PutPostDeleteFailedState(
          title: 'Xóa chức vụ',
          code: statusCode,
          message: 'Thất bại khi xóa chức vụ',
        ),
      );
    }
    emit(RolesLoadingDismissState());
  }
}
