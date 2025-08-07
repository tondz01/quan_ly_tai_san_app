// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';

class AssetCategoryProvider with ChangeNotifier {
  String? get error => _error;
  String get searchTerm => _searchTerm;

  get data => _data;
  get filteredData => _filteredData;
  get dataPage => _dataPage;
  get dataDetail => _dataDetail;

  get isCreate => _isCreate;

  bool get isLoading => _isLoading;
  bool get isShowCollapse => _isShowCollapse ?? false;
  bool get isShowInput => _isShowInput;

  bool _isLoading = false;
  bool? _isShowCollapse;
  bool _isShowInput = false;
  bool? _isCreate;

  String? _error;
  String _searchTerm = '';

  late int totalEntries;
  late int totalPages;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;
  TextEditingController? controllerDropdownPage;

  List<AssetCategoryDto>? _data;
  List<AssetCategoryDto>? _filteredData;
  List<AssetCategoryDto>? _dataPage;
  AssetCategoryDto? _dataDetail;

  final List<DropdownMenuItem<int>> items = [
    const DropdownMenuItem(value: 5, child: Text('5')),
    const DropdownMenuItem(value: 10, child: Text('10')),
    const DropdownMenuItem(value: 20, child: Text('20')),
    const DropdownMenuItem(value: 50, child: Text('50')),
  ];
  set searchTerm(String value) {
    _searchTerm = value;
    _applyFilters(); // Áp dụng filter khi thay đổi nội dung tìm kiếm
    notifyListeners();
  }

  set isShowCollapse(bool value) {
    _isShowCollapse = value;
    notifyListeners();
  }

  set isShowInput(bool value) {
    _isShowInput = value;
    notifyListeners();
  }

  onInit(BuildContext context) {
    controllerDropdownPage = TextEditingController(text: '10');
    getListAssetCategory(context);
  }

  void _applyFilters() {
    if (_data == null) return;
    // Lọc tiếp theo nội dung tìm kiếm
    if (_searchTerm.isNotEmpty) {
      String searchLower = _searchTerm.toLowerCase();
      _filteredData =
          _data!.where((item) {
            return
            // Tên phiếu
            (item.id?.toLowerCase().contains(searchLower) ?? false) ||
                // Số quyết định
                (item.tenMoHinh?.toLowerCase().contains(searchLower) ?? false) ||
                // công ty
                (item.idCongTy?.toLowerCase().contains(searchLower) ?? false) ||
                (item.loaiKyKhauHao?.toLowerCase().contains(searchLower) ?? false);
          }).toList();
    } else {
      _filteredData = _data!;
    }

    // Sau khi lọc, cập nhật lại phân trang
    _updatePagination();
  }

  void getListAssetCategory(BuildContext context) {
    _isLoading = true;
    Future.microtask(() {
      context.read<AssetCategoryBloc>().add(GetListAssetCategoryEvent(context,'ct001'));
    });
  }

  getListAssetCategorySuccess(
    BuildContext context,
    GetListAssetCategorySuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
    } else {
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

  void onChangeDetail(AssetCategoryDto? item) {
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

  void onRowsPerPageChanged(int? value) {
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
    notifyListeners();
  }

  void getListAssetCategoryFailed(
    BuildContext context,
    GetListAssetCategoryFailedState state,
  ) {
    _error = state.message;
    _isLoading = false;
    notifyListeners();
  }
}
