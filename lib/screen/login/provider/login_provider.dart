import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/model/permission_dto.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_reponsitory.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/enum/role_code.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_event.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_state.dart';
import 'package:quan_ly_tai_san_app/screen/login/component/popup_setting_permission.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/request/auth/auth_request.dart';
import 'package:quan_ly_tai_san_app/screen/home/models/menu_data.dart';

class LoginProvider with ChangeNotifier {
  get authRequest => _authRequest;
  get users => _users;
  get nhanViens => _nhanViens;
  get userInfo => _userInfo;
  get dataPage => _dataPage;
  get filteredData => _filteredData;

  get isLoading => _isLoading;
  get error => _error;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;

  List<UserInfoDTO>? _users;
  UserInfoDTO? _userInfo;
  List<NhanVien>? _nhanViens;
  List<UserInfoDTO>? _dataPage;
  List<UserInfoDTO>? _filteredData;

  AuthRequest _authRequest = AuthRequest(tenDangNhap: "", matKhau: "");
  String? _error;

  // Setting Pagination
  late int totalEntries;
  late int totalPages = 1;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;
  TextEditingController? controllerDropdownPage;

  final List<DropdownMenuItem<int>> items = [
    const DropdownMenuItem(value: 5, child: Text('5')),
    const DropdownMenuItem(value: 10, child: Text('10')),
    const DropdownMenuItem(value: 20, child: Text('20')),
    const DropdownMenuItem(value: 50, child: Text('50')),
  ];

  // onInit method
  onInit(BuildContext context) {
    // AppLog.d("onInit LoginProvider");
    _isLoading = true;
    _userInfo = AccountHelper.instance.getUserInfo();
    controllerDropdownPage = TextEditingController(text: '10');
    getDataAll(context);
    notifyListeners();
  }

  void _updatePagination() {
    totalEntries = users?.length ?? 0;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    _dataPage =
        users.isNotEmpty
            ? users.sublist(
              startIndex < totalEntries ? startIndex : 0,
              endIndex < totalEntries ? endIndex : totalEntries,
            )
            : [];
  }

  void onPageChanged(int page) {
    currentPage = page;
    _updatePagination();
    notifyListeners();
  }

  void onRowsPerPageChanged(int? value) {
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
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
  onDispose() {
    if (controllerDropdownPage != null) {
      controllerDropdownPage!.dispose();
      controllerDropdownPage = null;
    }
  }

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
    _userInfo = data.data;
    notifyListeners();

    // Rebuild menu items after permissions are saved during login
    try {
      AppMenuData.instance.rebuildMenuItems();
    } catch (_) {
    }

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
    } catch (e) {
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
      _users = state.data.where((u) => u.tenDangNhap != 'admin').toList();
      _filteredData = _users;
      _updatePagination();
    }
    _isLoading = false;

    notifyListeners();
  }

  createUserSuccess(BuildContext context, CreateAccountSuccessState state) {
    _error = null;
    getDataAll(context);
    AppUtility.showSnackBar(context, 'Tạo tài khoản thành công');
    notifyListeners();
  }

  updateUserSuccess(BuildContext context, UpdateUserSuccessState state) {
    _error = null;
    getDataAll(context);
    AppUtility.showSnackBar(context, 'Cập nhật tài khoản thành công');
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

  void showPermission(BuildContext context, UserInfoDTO item) async {
    Map<String, dynamic> response = await PermissionRepository()
        .getAllPermissionsByUserId(item.id);
    List<PermissionDto> permissions = [];
    if (response['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      permissions = response['data'];
      if (!context.mounted) return;
      if (permissions.isEmpty) {
        AppUtility.showSnackBar(
          context,
          'Tài khoản ${item.tenDangNhap} chưa có quyền nào,',
          isError: true,
        );
        return;
      }
      // Chuyển đổi danh sách permissions thành danh sách categories
      List<PermissionCategory> categories = [
        ...permissions.map(
          (e) => PermissionCategory.createWithDefaults(
            categoryName: getLablePermission(e.permissionCode),
            categoryValue: e.permissionCode,
            addDefault: e.canCreate,
            editDefault: e.canUpdate,
            deleteDefault: e.canDelete,
          ),
        ),
      ];

      showPermissionPopup(
        context: context,
        categories: categories,
        title: "Thiết lập quyền",
        submitButtonText: "Xác nhận",
        onSubmit: (updatedCategories) {
          // Trả về toàn bộ thông tin của list permissions
          List<PermissionDto> updatedPermissions = [
            ...updatedCategories.map(
              (category) => PermissionDto(
                userId: item.id,
                permissionCode: category.categoryValue,
                canCreate:
                    category.permissions
                        .firstWhere((p) => p.value.endsWith('_add'))
                        .isSelected,
                canUpdate:
                    category.permissions
                        .firstWhere((p) => p.value.endsWith('_edit'))
                        .isSelected,
                canDelete:
                    category.permissions
                        .firstWhere((p) => p.value.endsWith('_delete'))
                        .isSelected,
                canRead: true, // Mặc định luôn có quyền đọc
              ),
            ),
          ];
          context.read<LoginBloc>().add(
            UpdatePermissionEvent(updatedPermissions),
          );
        },
      );
    } else {
      AppUtility.showSnackBar(
        context,
        'Lấy danh sách quyền thất bại: ${response['message']}',
        isError: true,
      );
      return;
    }
  }

  String getLablePermission(String role) {
    switch (role) {
      case RoleCode.NHANVIEN:
        return "Quản lý nhân viên";
      case RoleCode.PHONGBAN:
        return "Quản lý phòng ban";
      case RoleCode.DUAN:
        return "Quản lý dự án";
      case RoleCode.NGUONVON:
        return "Quản lý nguồn vốn";
      case RoleCode.MOHINHTAISAN:
        return "Quản lý mô hình tài sản";
      case RoleCode.NHOMTAISAN:
        return "Quản lý nhóm tài sản";
      case RoleCode.TAISAN:
        return "Quản lý tài sản";
      case RoleCode.CCDCVT:
        return "Quản lý CCDC vật tư";
      case RoleCode.DIEUDONG_TAISAN:
        return "Điều động tài sản";
      case RoleCode.DIEUDONG_CCDC:
        return "Điều động CCDC vật tư";
      case RoleCode.BANGIAO_TAISAN:
        return "Bán giao tài sản";
      case RoleCode.BANGIAO_CCDC:
        return "Bán giao CCDC vật tư";
      case RoleCode.BAOCAO:
        return "Báo cáo";
      default:
        return "";
    }
  }

  String getNameUser(String idUser) {
    if (idUser.isEmpty) return "Không xác định";
    UserInfoDTO? userInfo = _users!.firstWhere(
      (element) => element.id == idUser,
      orElse: () => UserInfoDTO.empty(),
    );
    if (userInfo.id.isEmpty) {
      return "Không xác định";
    }
    List<NhanVien>? nhanViens = AccountHelper.instance.getNhanVien();
    final user = nhanViens!.firstWhere(
      (element) => element.id == userInfo.tenDangNhap,
      orElse: () => NhanVien(),
    );
    if (user.id == null || user.id!.isEmpty) {
      return "Không xác định";
    }
    return user.hoTen ?? "";
  }
}
