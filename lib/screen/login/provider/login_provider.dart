import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_event.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_state.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/request/auth/auth_request.dart';

class LoginProvider with ChangeNotifier {
  get authRequest => _authRequest;
  get users => _users;
  get nhanViens => _nhanViens;
  get userInfo => _userInfo;
  get isLoading => _isLoading;
  get error => _error;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;

  List<UserInfoDTO>? _users;
  UserInfoDTO? _userInfo;
  List<NhanVien>? _nhanViens;

  AuthRequest _authRequest = AuthRequest(tenDangNhap: "", matKhau: "");
  String? _error;

  // onInit method
  onInit(BuildContext context) {
    // AppLog.d("onInit LoginProvider");
    _isLoading = true;
    _userInfo = AccountHelper.instance.getUserInfo();
    getDataAll(context);
    notifyListeners();
  }

  void getDataAll(BuildContext context) {
    try {
      final bloc = context.read<LoginBloc>();
      // Gọi song song, không cần delay
      bloc.add(GetUsersEvent(context));
      bloc.add(GetNhanVienEvent(context, userInfo?.idCongTy ?? ''));
    } catch (e) {
      log('Error adding AssetManagement events: $e');
    }
  }

  // onDispose method
  onDispose() {}

  // onPressLogin method
  onPressLogin(BuildContext context, AuthRequest data) {
    Get.focusScope?.unfocus();
    _authRequest = data;
    if (context.mounted) {
      context.read<LoginBloc>().add(PostLoginEvent(_authRequest));
    }
    notifyListeners();
  }

  // onLoginSuccess method
  onLoginSuccess(BuildContext context, PostLoginSuccessState data) async {
    _error = null;
    _isLoggedIn = true;
    notifyListeners();
    context.go(AppRoute.dashboard.path);
  }

  // onLoginFailed method
  onLoginFailed(PostLoginFailedState state) {
    _error =
        state.message.contains("The connection errored")
            ? "message.error_call_fail_api".tr
            : state.message;
    notifyListeners();
  }

  // Logout method
  void logout(BuildContext context) {
    try {
      // Reset trạng thái đăng nhập
      _isLoggedIn = false;
      _userInfo = null;
      _users = null;
      _nhanViens = null;
      _error = null;
      _isLoading = false;
      
      // Xóa thông tin user khỏi storage
      AccountHelper.instance.setUserInfo(null);
      AccountHelper.instance.setAuthInfo(null);
      AccountHelper.instance.setToken('');
      AccountHelper.instance.setRememberLogin(false);
      
      // Thông báo cho UI cập nhật
      notifyListeners();
      
      // Chuyển về màn hình login
      if (context.mounted) {
        context.go(AppRoute.login.path);
      }
      
      log('Logout thành công');
    } catch (e) {
      log('Lỗi khi logout: $e');
      _error = 'Có lỗi xảy ra khi đăng xuất';
      notifyListeners();
    }
  }

  // Force logout (khi token hết hạn hoặc có lỗi)
  void forceLogout(BuildContext context, {String? reason}) {
    try {
      // Reset trạng thái đăng nhập
      _isLoggedIn = false;
      _userInfo = null;
      _users = null;
      _nhanViens = null;
      _error = reason ?? 'Phiên đăng nhập đã hết hạn';
      _isLoading = false;
      
      // Xóa thông tin user khỏi storage
      AccountHelper.instance.setUserInfo(null);
      AccountHelper.instance.setAuthInfo(null);
      AccountHelper.instance.setToken('');
      AccountHelper.instance.setRememberLogin(false);
      
      // Thông báo cho UI cập nhật
      notifyListeners();
      
      // Chuyển về màn hình login
      if (context.mounted) {
        context.go(AppRoute.login.path);
      }
      
      log('Force logout: ${reason ?? "Phiên đăng nhập đã hết hạn"}');
    } catch (e) {
      log('Lỗi khi force logout: $e');
      _error = 'Có lỗi xảy ra khi đăng xuất';
      notifyListeners();
    }
  }

  getUsersSuccess(BuildContext context, GetUsersSuccessState state) {
    _error = null;
    if (state.data.isEmpty) {
      _users = [];
    } else {
      _users = state.data;
    }
    _isLoading = false;

    notifyListeners();
  }
  createUserSuccess(BuildContext context, CreateAccountSuccessState state) {
    _error = null;
    getDataAll(context);
    AppUtility.showSnackBar(context, 'Tạo account thành công');
    notifyListeners();
  }
  deleteUserSuccess(BuildContext context, DeleteUserSuccessState state) {
    _error = null;
    getDataAll(context);
    AppUtility.showSnackBar(context, 'Xóa account thành công');
    notifyListeners();
  }

  getNhanVienSuccess(BuildContext context, GetNhanVienSuccessState state) {
    _error = null;
    if (state.data.isEmpty) {
      _nhanViens = [];
    } else {
      _nhanViens = state.data;
    }
    _isLoading = false;

    notifyListeners();
  }

  void getUsersFailed(BuildContext context, GetUsersFailedState state) {
    AppUtility.showSnackBar(context, state.message);
    notifyListeners();
  }

  void getNhanVienFailed(BuildContext context, GetNhanVienFailedState state) {
    AppUtility.showSnackBar(context, state.message);
    notifyListeners();
  }
}
