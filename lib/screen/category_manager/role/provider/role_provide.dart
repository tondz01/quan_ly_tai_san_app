import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';

class RoleProvider with ChangeNotifier {
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
  int rowsPerPage = 10;
  int currentPage = 1;
  TextEditingController? controllerDropdownPage;

  final List<DropdownMenuItem<int>> items = [
    const DropdownMenuItem(value: 5, child: Text('5')),
    const DropdownMenuItem(value: 10, child: Text('10')),
    const DropdownMenuItem(value: 20, child: Text('20')),
    const DropdownMenuItem(value: 50, child: Text('50')),
  ];

  String? _error;
  String? _subScreen;

  Widget? _body;
  bool _isShowInput = false;
  bool _isShowCollapse = true;
  bool _hasUnsavedChanges = false;
  bool _isLoading = false;
  List<ChucVu>? _data;
  List<ChucVu>? _dataPage;
  ChucVu? _dataDetail;
  List<ChucVu>? _filteredData;

  UserInfoDTO? _userInfo;

  void onInit(BuildContext context) {
    _userInfo = AccountHelper.instance.getUserInfo();
    controllerDropdownPage = TextEditingController(text: '10');
    _isShowInput = false;
    _isShowCollapse = true;
    _hasUnsavedChanges = false;
    getListRoles(context);
  }

  void onDispose() {
    _data = null;
    _error = null;

    if (controllerDropdownPage != null) {
      controllerDropdownPage!.dispose();
      controllerDropdownPage = null;
    }
  }

  void getListRoles(BuildContext context) {
    try {
      _isLoading = true;
      final bloc = context.read<RoleBloc>();
      bloc.add(GetListRoleEvent(context, userInfo?.idCongTy ?? ''));
      log('userInfo?.idCongTy: ${userInfo?.idCongTy}');
    } catch (e) {
      log('Error adding Role events: $e');
    }
  }

  void onSearchRoles(String value) {
    if (value.isEmpty) {
      _filteredData = data;
      return;
    }

    String searchLower = value.toLowerCase().trim();
    _filteredData =
        data.where((item) {
          bool name = AppUtility.fuzzySearch(
            item.name.toLowerCase(),
            searchLower,
          );
          bool importUnit = item.importUnit.toLowerCase().contains(searchLower);
          bool departmentGroup = item.importUnit.toLowerCase().contains(
            searchLower,
          );
          bool unit = item.unit.toLowerCase().contains(searchLower);
          bool value = item.value.toString().contains(searchLower);

          return name || importUnit || departmentGroup || unit || value;
        }).toList();
    notifyListeners();
  }

  void _updatePagination() {
    totalEntries = data?.length ?? 0;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    _dataPage =
        data.isNotEmpty
            ? data.sublist(
              startIndex < totalEntries ? startIndex : 0,
              endIndex < totalEntries ? endIndex : totalEntries,
            )
            : [];
  }

  void onCloseDetail(BuildContext context) {
    _isShowInput = false;
    _isShowCollapse = true;
    notifyListeners();
  }

  void onPageChanged(int page) {
    currentPage = page;
    _updatePagination();
    notifyListeners();
  }

  void onSetsShowCollapse(bool value) {
    _isShowCollapse = value;
    notifyListeners();
  }

  void onRowsPerPageChanged(int? value) {
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
    notifyListeners();
  }

  getListRolesSuccess(BuildContext context, GetListRoleSuccessState state) {
    _error = null;
    _isLoading = false;
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
    } else {
      _data = state.data;
      _filteredData = state.data;
      log('message getListRolesSuccess _data: $_data');
      _updatePagination();
    }
    notifyListeners();
  }

  void createRolesSuccess(BuildContext context, CreateRoleSuccessState state) {
    _isLoading = false;
    onCloseDetail(context);
    getListRoles(context);

    // Close input panel if open
    AppUtility.showSnackBar(context, 'Thêm "Chức vụ" tư thành công!');
  }

  void updateRolesSuccess(BuildContext context, UpdateRoleSuccessState state) {
    _isLoading = false;
    onCloseDetail(context);
    getListRoles(context);

    // Close input panel if open
    AppUtility.showSnackBar(context, 'Cập nhập "Chức vụ" tư thành công!');
  }

  void deleteRolesSuccess(BuildContext context, DeleteRoleSuccessState state) {
    _isLoading = false;
    onCloseDetail(context);
    getListRoles(context);

    // Close input panel if open
    AppUtility.showSnackBar(context, 'Xóa "Chức vụ" tư thành công!');
  }

  void onChangeDetail(BuildContext context, ChucVu? item) {
    _dataDetail = item;
    _isShowInput = true;
    _isShowCollapse = true;
    notifyListeners();
  }
}
