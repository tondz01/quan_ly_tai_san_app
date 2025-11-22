import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/provider/table_staff_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/repository/auth_repository.dart';

class StaffProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  get data => _data;
  get userInfo => _userInfo;
  get dataDetail => _dataDetail;

  String? get error => _error;
  String? get subScreen => _subScreen;

  Widget? get body => _body;

  set subScreen(String? value) {
    _subScreen = value;
    notifyListeners();
  }

  set body(Widget? value) {
    _body = value;
    notifyListeners();
  }

  late int totalEntries;
  late int totalPages = 1;
  late int startIndex;
  late int endIndex;

  String? _error;
  String? _subScreen;

  Widget? _body;
  bool _isShowInput = false;
  bool _isShowCollapse = true;
  bool _isLoading = false;

  List<NhanVien>? _data;
  NhanVien? _dataDetail;

  UserInfoDTO? _userInfo;

  void onInit(BuildContext context) {
    _userInfo = AccountHelper.instance.getUserInfo();
    _isShowInput = false;
    _isShowCollapse = true;
    onReloadDataStaff();
    // getListDepartments(context);
  }

  void onDispose() {
    _data = null;
    _error = null;
  }

  void getListDepartments(BuildContext context) {
    AuthRepository().loadUserDepartments(_userInfo?.idCongTy ?? '');
    onReloadData(context);
  }

  void onCloseDetail(BuildContext context) {
    _isShowInput = false;
    _isShowCollapse = true;
    notifyListeners();
  }

  void onSetsShowCollapse(bool value) {
    _isShowCollapse = value;
    notifyListeners();
  }

  onReloadDataStaff() {
    AuthRepository().loadUserEmployee('ct001');
  }

  void createStaffSuccess(BuildContext context, AddStaffSuccessState state) {
    _isLoading = false;
    onCloseDetail(context);
    onReloadDataStaff();
    // Close input panel if open
    AppUtility.showSnackBar(context, 'Tạo mới nhân viên thành công!');
  }

  void updateStaffSuccess(BuildContext context, UpdateStaffSuccessState state) {
    _isLoading = false;
    onCloseDetail(context);
    onReloadDataStaff();
    // Close input panel if open
    AppUtility.showSnackBar(context, 'Cập nhật nhân viên thành công!!!');
  }

  void deleteStaffSuccess(BuildContext context, DeleteStaffBatchSuccess state) {
    _isLoading = false;
    onCloseDetail(context);
    onReloadDataStaff();
    // Close input panel if open
    onReloadData(context);
    AppUtility.showSnackBar(context, 'Xóa phòng ban thành công!');
  }

  void deleteStaffBatchSuccess(
    BuildContext context,
    DeleteStaffBatchSuccess state,
  ) {
    _isLoading = false;
    onCloseDetail(context);
    // getListDepartments(context);
    onReloadData(context);
    AppUtility.showSnackBar(context, 'Xóa nhiều phòng ban thành công!');
  }

  void onChangeDetail(BuildContext context, NhanVien? item) {
    _dataDetail = item;
    _isShowInput = true;
    _isShowCollapse = true;
    notifyListeners();
  }

  void onCallFailled(BuildContext context, String message) {
    _isLoading = false;
    _error = message;
    notifyListeners();
    if (_isShowInput) {
      onCloseDetail(context);
    }
    AppUtility.showSnackBar(context, message, isError: true);
  }

  onReloadData(BuildContext context, [bool isRefresh = true]) {
    final container = ProviderScope.containerOf(context);
    container.read(tableStaffProvider.notifier).refreshData(isRefresh);
  }
}
