// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/unit/bloc/unit_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/unit/bloc/unit_event.dart';
import 'package:quan_ly_tai_san_app/screen/unit/bloc/unit_state.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';
import 'package:quan_ly_tai_san_app/screen/unit/repository/unit_repository.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class UnitProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchTerm => _searchTerm;

  get data => _data;
  get filteredData => _filteredData;
  get dataPage => _dataPage;
  UnitDto? get dataDetail => _dataDetail;

  get isCreate => _isCreate;
  bool get isShowCollapse => _isShowCollapse ?? false;
  bool get isShowInput => _isShowInput;

  set isShowCollapse(bool value) {
    _isShowCollapse = value;
    notifyListeners();
  }

  set searchTerm(String value) {
    _searchTerm = value;
    _applyFilters(); // Áp dụng filter khi thay đổi nội dung tìm kiếm
    notifyListeners();
  }

  set isShowInput(bool value) {
    _isShowInput = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool? _isCreate;
  bool? _isShowCollapse;
  bool _isShowInput = false;
  String? _error;
  String _searchTerm = '';

  late int totalEntries;
  late int totalPages = 0;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;
  TextEditingController? controllerDropdownPage;

  List<UnitDto>? _data;
  List<UnitDto>? _filteredData;
  List<UnitDto>? _dataPage;
  UnitDto? _dataDetail;

  final List<DropdownMenuItem<int>> items = [
    const DropdownMenuItem(value: 5, child: Text('5')),
    const DropdownMenuItem(value: 10, child: Text('10')),
    const DropdownMenuItem(value: 20, child: Text('20')),
    const DropdownMenuItem(value: 50, child: Text('50')),
  ];

  onInit(BuildContext context) {
    refresh(context);
  }

  void _applyFilters() {
    if (_data == null) return;
    // Lọc tiếp theo nội dung tìm kiếm
    if (_searchTerm.isNotEmpty) {
      String searchLower = _searchTerm.toLowerCase();
      _filteredData =
          _data!.where((item) {
            return (item.id?.toLowerCase().contains(searchLower) ?? false) ||
                (item.tenDonVi?.toLowerCase().contains(searchLower) ?? false) ||
                (item.note?.toLowerCase().contains(searchLower) ?? false);
          }).toList();
    } else {
      _filteredData = _data!;
    }

    // Sau khi lọc, cập nhật lại phân trang
    _updatePagination();
  }

  void refresh(BuildContext context) {
    controllerDropdownPage = TextEditingController(text: '10');
    _isLoading = false;
    _data = [];
    _filteredData = [];
    _dataPage = [];
    _dataDetail = null;
    _isCreate = false;
    _isShowCollapse = false;
    _isShowInput = false;
    getListUnit(context);
    notifyListeners();
  }

  void getListUnit(BuildContext context) {
    _isLoading = true;
    Future.microtask(() {
      context.read<UnitBloc>().add(GetListUnitEvent(context));
    });
  }

  getListUnitSuccess(BuildContext context, GetListUnitSuccessState state) {
    _error = null;
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
      _isLoading = false;
    } else {
      log('message getListUnitSuccess: ${state.data.length}');
      _data = state.data;
      _filteredData = List.from(_data!);
      _isLoading = false;
      _updatePagination();
    }
    notifyListeners();
  }

  void _updatePagination() {
    // Sử dụng _filteredData thay vì _data
    totalEntries = _filteredData!.length;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    _dataPage =
        _filteredData!.isNotEmpty
            ? _filteredData!.sublist(
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

  void onCloseDetail(BuildContext context) {
    _isShowCollapse = true;
    _isShowInput = false;
    notifyListeners();
  }

  void onRowsPerPageChanged(int? value) {
    log('message onRowsPerPageChanged: $value');
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
    notifyListeners();
  }

  void onChangeDetail(UnitDto? item) {
    // log('message onChangeDetail: ${item?.toJson()}');
    if (item != null) {
      _dataDetail = item;
      _isCreate = false;
    } else {
      _dataDetail = null;
      _isCreate = true;
      log('message _isCreate: $_isCreate');
    }
    _isShowCollapse = true;
    isShowInput = true;
    log('message onChangeDetail: $_isShowCollapse');
    log('message onChangeDetail: $_isShowInput');
  }

  void createUnitSuccess(BuildContext context, CreateUnitSuccessState state) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Thêm mới thành công!');
    refresh(context);
    notifyListeners();
  }

  void updateUnitSuccess(BuildContext context, UpdateUnitSuccessState state) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Cập nhật thành công!');
    refresh(context);
    notifyListeners();
  }

  void deleteUnitSuccess(BuildContext context, DeleteUnitSuccessState state) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Xóa thành công!');
    refresh(context);
    notifyListeners();
  }

  void getListUnitFailed(BuildContext context, GetListUnitFailedState state) {
    _error = state.message;
    _isLoading = false;
    notifyListeners();
  }

  void createUnitFailed(BuildContext context, CreateUnitFailedState state) {
    _error = state.message;
    AppUtility.showSnackBar(context, state.message, isError: true);
    notifyListeners();
  }

  void putPostDeleteFailed(
    BuildContext context,
    PutPostDeleteFailedState state,
  ) {
    AppUtility.showSnackBar(context, state.message, isError: true);
    notifyListeners();
  }
}
