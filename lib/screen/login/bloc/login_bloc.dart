import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_reponsitory.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/repository/auth_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_event.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_state.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<PostLoginEvent>(_postLogin);
    on<GetUsersEvent>(_getListUser);
    on<CreateAccountEvent>(_createAccount);
    on<UpdateUserEvent>(_updateUser);
    on<DeleteUserEvent>(_deleteUser);
    on<DeleteUserBatchEvent>(_deleteUserBatch);
    on<GetNhanVienEvent>(_getListNhanVien);
    on<UpdatePermissionEvent>(_updatePermission);
  }

  // Handle PostLoginEvent.
  //
  // Call method postLogin(event) api in AuthRepository.
  // Handle LoginSuccessState or LoginFailedState.
  // Emit to view.
  Future<void> _postLogin(PostLoginEvent event, Emitter emit) async {
    emit(LoginInitialState());
    emit(LoginLoadingState());
    Map<String, dynamic> result = await AuthRepository().login(event.params);
    emit(LoginLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      final reponse = await AssetTransferRepository().getListDieuDongTaiSan();
      if (reponse['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        final data = reponse['data'];
        AccountHelper.instance.setAssetTransfer(data);
      }
      final reponseToolsHandover =
          await ToolAndSuppliesHandoverRepository()
              .getListToolAndSuppliesHandover();
      if (reponseToolsHandover['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        final data = reponseToolsHandover['data'];
        AccountHelper.instance.setToolAndMaterialHandover(data);
      }
      final reponseAssetHandover =
          await AssetHandoverRepository().getListAssetHandover();
      if (reponseAssetHandover['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        final data = reponseAssetHandover['data'];
        AccountHelper.instance.setAssetHandover(data);
      }
      final reponseToolAndMaterialTransfer =
          await ToolAndMaterialTransferRepository()
              .getAllToolAndMeterialTransferByCT();
      if (reponseToolAndMaterialTransfer.isNotEmpty) {
        final data = reponseToolAndMaterialTransfer;
        AccountHelper.instance.setToolAndMaterialHandover(data);
      }
      if (result['data'] != null) {
        emit(PostLoginSuccessState(data: result['data']));
      } else {
        emit(
          PostLoginFailedState(
            title: "notice",
            code: result['status_code'],
            message: "Tài khoản hoặc mật khẩu không chính xác",
          ),
        );
      }
    } else {
      emit(
        PostLoginFailedState(
          title: "notice",
          code: result['status_code'],
          message: result['message'],
        ),
      );
    }
  }

  Future<void> _getListUser(GetUsersEvent event, Emitter emit) async {
    emit(LoginInitialState());
    emit(LoginLoadingState());
    Map<String, dynamic> result = await AuthRepository().getListUser();
    emit(LoginLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetUsersSuccessState(result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetUsersFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _getListNhanVien(GetNhanVienEvent event, Emitter emit) async {
    emit(LoginInitialState());
    emit(LoginLoadingState());
    Map<String, dynamic> result = await AuthRepository().getListNhanVien(
      event.idCongTy,
    );
    emit(LoginLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(GetNhanVienSuccessState(result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu";
      emit(
        GetNhanVienFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }

  Future<void> _createAccount(CreateAccountEvent event, Emitter emit) async {
    emit(LoginLoadingState());
    try {
      final result = await AuthRepository().createAccount(event.user);

      emit(LoginLoadingDismissState());
      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        emit(CreateAccountSuccessState(result['data'].toString()));
      } else {
        emit(
          CreateAccountFailedState(
            title: "notice",
            code: result['status_code'] ?? -1,
            message: result['message'] ?? '',
          ),
        );
      }
    } catch (e) {
      emit(LoginLoadingDismissState());
      emit(
        CreateAccountFailedState(
          title: "error",
          code: -1,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _updateUser(UpdateUserEvent event, Emitter emit) async {
    emit(LoginLoadingState());
    try {
      final result = await AuthRepository().updateUser(event.id, event.user);
      emit(LoginLoadingDismissState());
      if (result.statusCode == 200 && result.data != null) {
        emit(UpdateUserSuccessState(result.data!));
      } else {
        emit(
          PostLoginFailedState(
            title: "notice",
            code: result.statusCode ?? -1,
            message: result.statusMessage ?? '',
          ),
        );
      }
    } catch (e) {
      emit(LoginLoadingDismissState());
      String errorMessage = "Cập nhập tài khoản thất bại";
      emit(
        PostLoginFailedState(title: "error", code: -1, message: errorMessage),
      );
    }
  }

  Future<void> _updatePermission(
    UpdatePermissionEvent event,
    Emitter emit,
  ) async {
    emit(LoginLoadingState());
    try {
      final result = await PermissionRepository().updatePermissionBatch(
        event.permissions,
      );
      emit(LoginLoadingDismissState());
      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        emit(UpdatePermissionSuccessState(result['data']));
      } else {
        emit(
          PostLoginFailedState(
            title: "notice",
            code: result['status_code'] ?? -1,
            message: result['message'] ?? 'Lỗi hệ thống',
          ),
        );
      }
    } catch (e) {
      emit(LoginLoadingDismissState());
      emit(
        PostLoginFailedState(title: "error", code: -1, message: e.toString()),
      );
    }
  }

  Future<void> _deleteUser(DeleteUserEvent event, Emitter emit) async {
    emit(LoginLoadingState());
    try {
      final result = await AuthRepository().deleteUser(event.id);
      emit(LoginLoadingDismissState());
      if (result.statusCode == 200) {
        emit(DeleteUserSuccessState());
      } else {
        emit(
          PostLoginFailedState(
            title: "notice",
            code: result.statusCode ?? -1,
            message: result.statusMessage ?? '',
          ),
        );
      }
    } catch (e) {
      emit(LoginLoadingDismissState());
      emit(
        PostLoginFailedState(title: "error", code: -1, message: e.toString()),
      );
    }
  }

  Future<void> _deleteUserBatch(
    DeleteUserBatchEvent event,
    Emitter emit,
  ) async {
    emit(LoginLoadingState());
    try {
      final result = await AuthRepository().deleteUserBatch(event.ids);
      emit(LoginLoadingDismissState());
      if (result.statusCode == 200) {
        emit(DeleteUserSuccessState());
      } else {
        emit(
          PostLoginFailedState(
            title: "notice",
            code: result.statusCode ?? -1,
            message: result.statusMessage ?? '',
          ),
        );
      }
    } catch (e) {
      emit(LoginLoadingDismissState());
      emit(
        PostLoginFailedState(title: "error", code: -1, message: e.toString()),
      );
    }
  }
}
