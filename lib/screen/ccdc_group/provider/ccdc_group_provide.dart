// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_event.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_state.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/repository/ccdc_group_repository.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class CcdcGroupProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchTerm => _searchTerm;

  get data => _data;
  get filteredData => _filteredData;
  get dataPage => _dataPage;
  CcdcGroup? get dataDetail => _dataDetail;

  get isCreate => _isCreate;
  bool get isShowCollapse => _isShowCollapse ?? false;
  bool get isShowInput => _isShowInput;

  set isShowCollapse(bool value) {
    _isShowCollapse = value;
    notifyListeners();
  }

  set searchTerm(String value) {
    _searchTerm = value;
    _applyFilters();
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

  List<CcdcGroup>? _data;
  List<CcdcGroup>? _filteredData;
  List<CcdcGroup>? _dataPage;
  CcdcGroup? _dataDetail;

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
    if (_searchTerm.isNotEmpty) {
      String searchLower = _searchTerm.toLowerCase();
      _filteredData =
          _data!.where((item) {
            return (item.id?.toLowerCase().contains(searchLower) ?? false) ||
                (item.ten?.toLowerCase().contains(searchLower) ?? false) ||
                (item.idCongTy?.toLowerCase().contains(searchLower) ?? false) ||
                (item.nguoiTao?.toLowerCase().contains(searchLower) ?? false);
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
    getListCcdcGroup(context);
    notifyListeners();
  }

  void getListCcdcGroup(BuildContext context) {
    _isLoading = true;
    Future.microtask(() {
      context.read<CcdcGroupBloc>().add(GetListCcdcGroupEvent(context));
    });
  }

  getListCcdcGroupSuccess(
    BuildContext context,
    GetListCcdcGroupSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
    } else {
      _data = state.data;
      _filteredData = List.from(_data!);
      _updatePagination();
    }
    _isLoading = false;
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
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
    notifyListeners();
  }

  void onChangeDetail(CcdcGroup? item) {
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
  }

  void createCcdcGroupSuccess(
    BuildContext context,
    CreateCcdcGroupSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Thêm mới thành công!');
    refresh(context);
    notifyListeners();
  }

  void createCcdcGroupBatchSuccess(
    BuildContext context,
    CreateCcdcGroupBatchSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Thêm danh sách nhóm tài sản thành công!');
    refresh(context);
    notifyListeners();
  }

  void createCcdcGroupBatchFailed(
    BuildContext context,
    CreateCcdcGroupBatchFailedState state,
  ) {
    AppUtility.showSnackBar(context, state.message, isError: true);
    notifyListeners();
  }

  void updateCcdcGroupSuccess(
    BuildContext context,
    UpdateCcdcGroupSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Cập nhật thành công!');
    refresh(context);
    notifyListeners();
  }

  void deleteCcdcGroupSuccess(
    BuildContext context,
    DeleteCcdcGroupSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Xóa thành công!');
    refresh(context);
    notifyListeners();
  }

  void getListCcdcGroupFailed(
    BuildContext context,
    GetListCcdcGroupFailedState state,
  ) {
    _error = state.message;
    _isLoading = false;
    notifyListeners();
  }

  void createCcdcGroupFailed(
    BuildContext context,
    CreateCcdcGroupFailedState state,
  ) {
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

  Future<Map<String, dynamic>?> insertData(
    BuildContext context,
    String fileName,
    String filePath,
    Uint8List fileBytes,
  ) async {
    if (kIsWeb) {
      if (fileName.isEmpty || filePath.isEmpty) return null;
    } else {
      if (filePath.isEmpty) return null;
    }
    try {
      final result =
          kIsWeb
              ? await CcdcGroupRepository().insertDataFileBytes(
                fileName,
                fileBytes,
              )
              : await CcdcGroupRepository().insertDataFile(filePath);
      final statusCode = result['status_code'] as int? ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Import dữ liệu thành công'),
              backgroundColor: Colors.green.shade600,
            ),
          );
          getListCcdcGroup(context);
        }
        return result['data'];
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tải lên thất bại (mã $statusCode)'),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
        return null;
      }
    } catch (e) {
      SGLog.debug("CcdcGroupProvider", ' Error uploading file: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải lên tệp: ${e.toString()}'),
            backgroundColor: Colors.red.shade600,
          ),
        );
        return null;
      }
    }
    return null;
  }
}
