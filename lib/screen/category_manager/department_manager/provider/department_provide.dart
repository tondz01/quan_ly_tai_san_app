import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/bloc/department_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/provider/table_department_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/repository/auth_repository.dart';

class DepartmentProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  get data => _data;
  get userInfo => _userInfo;
  get dataDetail => _dataDetail;
  get dataPage => _dataPage;
  get filteredData => _filteredData;

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

  set hasUnsavedChanges(bool value) {
    _hasUnsavedChanges = value;
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
  bool _hasUnsavedChanges = false;
  bool _isLoading = false;

  List<PhongBan>? _data;
  List<PhongBan>? _dataPage;
  PhongBan? _dataDetail;
  List<PhongBan>? _filteredData;

  UserInfoDTO? _userInfo;

  void onInit(BuildContext context) {
    _userInfo = AccountHelper.instance.getUserInfo();
    _isShowInput = false;
    _isShowCollapse = true;
    _hasUnsavedChanges = false;
    // getListDepartments(context);
  }

  void onDispose() {
    _data = null;
    _error = null;
  }

  void getListDepartments(BuildContext context) {
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

  onReloadDataDepartments() {
    AuthRepository().loadAssetGroup(_userInfo?.idCongTy ?? '');
  }

  void createDepartmentsSuccess(
    BuildContext context,
    CreateDepartmentSuccessState state,
  ) {
    _isLoading = false;
    onCloseDetail(context);
    getListDepartments(context);
    // Close input panel if open
    AppUtility.showSnackBar(context, 'Tạo mới phòng ban thành công!');
  }

  void updateDepartmentsSuccess(
    BuildContext context,
    UpdateDepartmentSuccessState state,
  ) {
    _isLoading = false;
    onCloseDetail(context);
    getListDepartments(context);

    // Close input panel if open
    AppUtility.showSnackBar(context, 'Cập nhật phòng ban thành công!');
  }

  void deleteDepartmentsSuccess(
    BuildContext context,
    DeleteDepartmentSuccessState state,
  ) {
    _isLoading = false;
    onCloseDetail(context);
    getListDepartments(context);

    // Close input panel if open
    onReloadData(context);
    AppUtility.showSnackBar(context, 'Xóa phòng ban thành công!');
  }

  void deleteDepartmentBatchSuccess(
    BuildContext context,
    DeleteDepartmentBatchSuccess state,
  ) {
    _isLoading = false;
    onCloseDetail(context);
    // getListDepartments(context);
    onReloadData(context);
    AppUtility.showSnackBar(context, 'Xóa nhiều phòng ban thành công!');
  }

  void onChangeDetail(BuildContext context, PhongBan? item) {
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
    container.read(tableDepartmentProvider.notifier).refreshData(isRefresh);
  }
}
