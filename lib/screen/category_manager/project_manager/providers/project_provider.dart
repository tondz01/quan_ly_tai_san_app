import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';

class ProjectProvider with ChangeNotifier {
  get isLoading => _isLoading;
  get isShowInput => _isShowInput;
  get isShowCollapse => _isShowCollapse;
  get data => _data;
  get userInfo => _userInfo;
  get dataDetail => _dataDetail;
  get dataPage => _dataPage;
  get filteredData => _filteredData;
  get error => _error;

  bool _isShowInput = false;
  bool _isShowCollapse = true;
  bool _isLoading = false;
  String? _error;

  List<DuAn>? _data;
  List<DuAn>? _dataPage;
  List<DuAn>? _filteredData;
  DuAn? _dataDetail;
  UserInfoDTO? _userInfo;

  // Setting Pagination
  late int totalEntries;
  late int totalPages = 1;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;
  TextEditingController? controllerDropdownPage;

  final List<DropdownMenuItem<int>> itemsPagination = [
    const DropdownMenuItem(value: 5, child: Text('5')),
    const DropdownMenuItem(value: 10, child: Text('10')),
    const DropdownMenuItem(value: 20, child: Text('20')),
    const DropdownMenuItem(value: 50, child: Text('50')),
  ];

  void onInit(BuildContext context) {
    _userInfo = AccountHelper.instance.getUserInfo();
    controllerDropdownPage = TextEditingController(text: '10');
    _isShowInput = false;
    _isShowCollapse = true;
    getListRoles(context);
  }

  void getListRoles(BuildContext context) {
    try {
      _isLoading = true;
      final bloc = context.read<ProjectBloc>();
      bloc.add(GetListProjectEvent(userInfo?.idCongTy ?? ''));
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

  void onRowsPerPageChanged(int? value) {
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
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

  void getListProjectSuccess(
    BuildContext context,
    GetListProjectSuccsessState state,
  ) {
    _error = null;
    _isLoading = false;
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
    } else {
      _data = state.data;
      _filteredData = state.data;
      _updatePagination();
    }
    notifyListeners();
  }

  void createRolesSuccess(BuildContext context, AddProjectSuccessState state) {
    _isLoading = false;
    onCloseDetail(context);
    getListRoles(context);
    // Close input panel if open
    AppUtility.showSnackBar(context, 'Thêm "Dự án" tư thành công!');
  }

  void updateRolesSuccess(
    BuildContext context,
    UpdateProjectSuccessState state,
  ) {
    _isLoading = false;
    onCloseDetail(context);
    getListRoles(context);

    // Close input panel if open
    AppUtility.showSnackBar(context, 'Cập nhập "Dự án" tư thành công!');
  }

  void deleteRolesSuccess(
    BuildContext context,
    DeleteProjectSuccessState state,
  ) {
    _isLoading = false;
    onCloseDetail(context);
    getListRoles(context);

    // Close input panel if open
    AppUtility.showSnackBar(context, 'Xóa "Dự án" tư thành công!');
  }

  void onChangeDetail(BuildContext context, DuAn? item) {
    _dataDetail = item;
    _isShowInput = true;
    _isShowCollapse = true;
    notifyListeners();
  }

  void onCallFailled(BuildContext context, ProjectErrorState state) {
    _isLoading = false;
    _error = state.message;
    notifyListeners();
    if (_isShowInput) {
      onCloseDetail(context);
    }
    AppUtility.showSnackBar(
      context,
      _error ?? 'Lỗi không xác định',
      isError: true,
    );
  }
}
