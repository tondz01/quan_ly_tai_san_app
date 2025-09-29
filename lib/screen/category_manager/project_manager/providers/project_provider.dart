import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/constants/project_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

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
  int rowsPerPage = ProjectConstants.defaultRowsPerPage;
  int currentPage = 1;
  TextEditingController? controllerDropdownPage;

  final List<DropdownMenuItem<int>> items =
      (ProjectConstants.mobilePaginationOptions)
          .map(
            (value) =>
                DropdownMenuItem(value: value, child: Text(value.toString())),
          )
          .toList();

  void onInit(BuildContext context) {
    _userInfo = AccountHelper.instance.getUserInfo();
    controllerDropdownPage = TextEditingController(
      text: ProjectConstants.defaultRowsPerPage.toString(),
    );
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
      SGLog.error('ProjectProvider', 'Error adding Project events: $e');
    }
  }

  void onSearchRoles(String value) {
    currentPage = 1;
    
    if (value.isEmpty) {
      _filteredData = data;
      _updatePagination();
      notifyListeners();
      return;
    }

    String searchLower = value.toLowerCase().trim();

    _filteredData =
        data?.where((item) {
          bool name = AppUtility.fuzzySearch(
            item.tenDuAn?.toLowerCase() ?? '',
            searchLower,
          );
          bool idMatch = item.id?.toLowerCase().contains(searchLower) ?? false;
          bool ghiChuMatch = AppUtility.fuzzySearch(
            item.ghiChu?.toLowerCase() ?? '',
            searchLower,
          );

          bool matches = name || idMatch || ghiChuMatch;
          if (matches) {
          }
          return matches;
        }).toList() ??
        [];

    _updatePagination();
    notifyListeners();
  }

  void _updatePagination() {
    totalEntries = _filteredData?.length ?? 0;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(
      1,
      ProjectConstants.maxPaginationPages,
    );
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    _dataPage =
        _filteredData?.isNotEmpty == true
            ? _filteredData!.sublist(
              startIndex < totalEntries ? startIndex : 0,
              endIndex < totalEntries ? endIndex : totalEntries,
            )
            : [];

    SGLog.debug('ProjectProvider', 'Pagination - totalEntries: $totalEntries, currentPage: $currentPage, dataPage length: ${_dataPage?.length ?? 0}');
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
    GetListProjectSuccessState state,
  ) {
    _error = null;
    _isLoading = false;
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
      _dataPage = [];
    } else {
      _data = state.data;
      _filteredData = state.data;
      _updatePagination();
    }
    notifyListeners();
  }

  void createRolesSuccess(
    BuildContext context,
    CreateProjectSuccessState state,
  ) {
    _isLoading = false;
    onCloseDetail(context);
    getListRoles(context);
    // Close input panel if open
    AppUtility.showSnackBar(context, ProjectConstants.successCreateProject);
  }

  void updateRolesSuccess(
    BuildContext context,
    UpdateProjectSuccessState state,
  ) {
    _isLoading = false;
    onCloseDetail(context);
    getListRoles(context);

    // Close input panel if open
    AppUtility.showSnackBar(context, ProjectConstants.successUpdateProject);
  }

  void deleteRolesSuccess(
    BuildContext context,
    DeleteProjectSuccessState state,
  ) {
    _isLoading = false;
    onCloseDetail(context);
    getListRoles(context);

    // Close input panel if open
    AppUtility.showSnackBar(context, ProjectConstants.successDeleteProject);
  }

  void deleteProjectBatchSuccess(
    BuildContext context,
    DeleteProjectBatchSuccess state,
  ) {
    _isLoading = false;
    onCloseDetail(context);
    getListRoles(context);
    AppUtility.showSnackBar(context, state.message);
  }

  void onChangeDetail(BuildContext context, DuAn? item) {
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
}
