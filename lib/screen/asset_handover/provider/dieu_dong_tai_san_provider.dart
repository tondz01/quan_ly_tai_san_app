// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/dieu_dong_tai_san.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

enum FilterStatus {
  all('Tất cả', ColorValue.darkGrey),
  draft('Nháp', ColorValue.silverGray),
  ready('Sẵn sàng', ColorValue.lightAmber),
  confirm('Xác nhận', ColorValue.mediumGreen),
  browser('Trình duyệt', ColorValue.lightBlue),
  complete('Hoàn thành', ColorValue.forestGreen),
  cancel('Hủy', ColorValue.coral);

  final String label;
  final Color activeColor;
  const FilterStatus(this.label, this.activeColor);
}

class DieuDongTaiSanProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  List<DieuDongTaiSan>? get dataPage => _dataPage;
  DieuDongTaiSan? get item => _item;
  get data => _data;
  get columns => _columns;
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  // Truy cập trạng thái filter
  bool get isShowAll => _filterStatus[FilterStatus.all] ?? false;
  bool get isShowDraft => _filterStatus[FilterStatus.draft] ?? false;
  bool get isShowReady => _filterStatus[FilterStatus.ready] ?? false;
  bool get isShowConfirm => _filterStatus[FilterStatus.confirm] ?? false;
  bool get isShowBrowser => _filterStatus[FilterStatus.browser] ?? false;
  bool get isShowComplete => _filterStatus[FilterStatus.complete] ?? false;
  bool get isShowCancel => _filterStatus[FilterStatus.cancel] ?? false;

  // Getter để lấy count cho mỗi status
  int get allCount => _data?.length ?? 0;
  int get draftCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 0).length ?? 0;
  int get readyCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 1).length ?? 0;
  int get confirmCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 2).length ?? 0;
  int get browserCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 3).length ?? 0;
  int get completeCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 4).length ?? 0;
  int get cancelCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 5).length ?? 0;

  // Thuộc tính cho tìm kiếm
  String get searchTerm => _searchTerm;
  set searchTerm(String value) {
    _searchTerm = value;
    _applyFilters(); // Áp dụng filter khi thay đổi nội dung tìm kiếm
    notifyListeners();
  }

  bool _isShowInput = false;
  bool _isShowCollapse = true;
  bool _hasUnsavedChanges = false;

  String? get error => _error;
  String? get subScreen => _subScreen;
  String _searchTerm = '';

  int typeAssetTransfer = 1;

  late int totalEntries;
  late int totalPages;
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

  // List status

  String? _error;
  String? _subScreen;

  Widget? _body;

  bool _isLoading = false;

  List<DieuDongTaiSan>? _data;
  List<DieuDongTaiSan>? _dataPage;
  // Danh sách dữ liệu đã được lọc
  List<DieuDongTaiSan> _filteredData = [];
  List<SgTableColumn<DieuDongTaiSan>> _columns = [];
  DieuDongTaiSan? _item;

  // Method để refresh data và filter
  void refreshData(BuildContext context,String idCongTy) {
    _isLoading = true;

    // Reset filter về trạng thái ban đầu
    _filterStatus.clear();
    _filterStatus[FilterStatus.all] = true;

    // Clear search term
    _searchTerm = '';

    // Reload data
    context.read<DieuDongTaiSanBloc>().add(GetListDieuDongTaiSanEvent(context: context,idCongTy: idCongTy));
    notifyListeners();
  }

  Widget? get body => _body;

  set subScreen(String? value) {
    _subScreen = value;
    notifyListeners();
  }

  set body(Widget? value) {
    _body = value;
    notifyListeners();
  }

  set dataPage(List<DieuDongTaiSan>? value) {
    _dataPage = value;
    notifyListeners();
  }

  set isShowInput(bool value) {
    _isShowInput = value;
    notifyListeners();
  }

  set isShowCollapse(bool value) {
    _isShowCollapse = value;
    notifyListeners();
  }

  set hasUnsavedChanges(bool value) {
    _hasUnsavedChanges = value;
    notifyListeners();
  }

  void setFilterStatus(FilterStatus status, bool? value) {
    log('message setFilterStatus: $status, $value');

    _filterStatus[status] = value ?? false;

    if (status == FilterStatus.all && value == true) {
      for (var key in _filterStatus.keys) {
        if (key != FilterStatus.all) {
          _filterStatus[key] = false;
        }
      }
    } else if (status != FilterStatus.all && value == true) {
      _filterStatus[FilterStatus.all] = false;
    }

    _applyFilters();

    notifyListeners();
  }

  void _applyFilters() {
    if (_data == null) return;

    bool hasActiveFilter = _filterStatus.entries
        .where((entry) => entry.key != FilterStatus.all)
        .any((entry) => entry.value == true);

    // Lọc theo trạng thái
    List<DieuDongTaiSan> statusFiltered;
    if (_filterStatus[FilterStatus.all] == true || !hasActiveFilter) {
      statusFiltered = List.from(_data!);
    } else {
      statusFiltered =
          _data!.where((item) {
            int itemStatus = item.trangThai ?? -1;

            if (_filterStatus[FilterStatus.draft] == true &&
                (itemStatus == 0)) {
              return true;
            }

            if (_filterStatus[FilterStatus.ready] == true &&
                (itemStatus == 1)) {
              return true;
            }

            if (_filterStatus[FilterStatus.confirm] == true &&
                (itemStatus == 2)) {
              return true;
            }

            if (_filterStatus[FilterStatus.browser] == true &&
                (itemStatus == 3)) {
              return true;
            }

            if (_filterStatus[FilterStatus.complete] == true &&
                (itemStatus == 4)) {
              return true;
            }

            if (_filterStatus[FilterStatus.cancel] == true &&
                (itemStatus == 5)) {
              return true;
            }

            return false;
          }).toList();
    }

    // Lọc tiếp theo nội dung tìm kiếm
    if (_searchTerm.isNotEmpty) {
      String searchLower = _searchTerm.toLowerCase();
      _filteredData =
          statusFiltered.where((item) {
            return
            // Tên phiếu
            (item.tenPhieu?.toLowerCase().contains(searchLower) ?? false) ||
                // Số quyết định
                (item.soQuyetDinh?.toLowerCase().contains(searchLower) ??
                    false) ||
                // Người đề nghị
                (item.tenNguoiDeNghi?.toLowerCase().contains(searchLower) ??
                    false) ||
                // Người lập phiếu
                (item.nguoiTao?.toLowerCase().contains(searchLower) ??
                    false) ||
                // Chi tiết điều động
                (item.assetHandoverMovements?.any(
                      (detail) =>
                          detail.name?.toLowerCase().contains(searchLower) ??
                          false,
                    ) ??
                    false) ||
                // Đơn vị giao/nhận
                (item.tenDonViNhan?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.tenDonViNhan?.toLowerCase().contains(searchLower) ??
                    false);
          }).toList();

    } else {
      _filteredData = statusFiltered;
    }

    // Sau khi lọc, cập nhật lại phân trang
    _updatePagination();
  }

  // Lưu trữ trạng thái filter trong Map
  final Map<FilterStatus, bool> _filterStatus = {
    FilterStatus.all: false,
    FilterStatus.draft: false,
    FilterStatus.ready: false,
    FilterStatus.confirm: false,
    FilterStatus.browser: false,
    FilterStatus.complete: false,
    FilterStatus.cancel: false,
  };

  // Nội dung tìm kiếm

  void onInit(BuildContext context,String idCongTy) {
    onDispose();
    controllerDropdownPage = TextEditingController(text: '10');

    _body = Container();
    getListAssetHandover(context,idCongTy);
  }

  void onDispose() {
    _isLoading = false;
    _isShowInput = false;
    _data = null;
    _error = null;
    _filterStatus.clear();
    _filterStatus[FilterStatus.all] = true;
    if (controllerDropdownPage != null) {
      controllerDropdownPage!.dispose();
      controllerDropdownPage = null;
    }
  }

  void onTapBackHeader() {
    notifyListeners();
  }

  void onTapNewHeader() {
    notifyListeners();
  }

  // Cập nhật danh sách trạng thái

  void getListAssetHandover(BuildContext context,String idCongTy) {
    _isLoading = true;
    Future.microtask(() {
      context.read<DieuDongTaiSanBloc>().add(GetListDieuDongTaiSanEvent(context: context,idCongTy: idCongTy));
    });
  }

  void _updatePagination() {
    // Sử dụng _filteredData thay vì _data
    totalEntries = _filteredData.length;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    dataPage =
        _filteredData.isNotEmpty
            ? _filteredData.sublist(
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
    log('message onRowsPerPageChanged: $value');
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
    notifyListeners();
  }

  void onChangeDetail(BuildContext context, DieuDongTaiSan? item) {
    _confirmBeforeLeaving(context, item);

    notifyListeners();
  }

  void updateItem(DieuDongTaiSan updatedItem) {
    if (_data == null) return;
    int index = _data!.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _data![index] = updatedItem;

      _updatePagination();
      notifyListeners();
    } else {}
  }

  void deleteItem(String id) {
    if (_data == null) return;
    int index = _data!.indexWhere((item) => item.id == id);
    if (index != -1) {
      _data!.removeAt(index);

      _updatePagination();
      notifyListeners();
    } else {}
  }

  getListAssetHandoverSuccess(
    BuildContext context,
    GetListDieuDongTaiSanSuccessState state,
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

  Future<bool> _showUnsavedChangesDialog(
    BuildContext context,
    DieuDongTaiSan? item,
  ) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Thay đổi chưa lưu'),
              content: const Text(
                'Bạn có thay đổi chưa lưu. Bạn có chắc chắn muốn rời khỏi trang này?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    _item = item;
                    log('message onChangeDetail: $_item');
                    isShowInput = true;
                    isShowCollapse = true;
                    log('message _item: $_item');
                    hasUnsavedChanges = false;
                    Navigator.of(context).pop();
                  },
                  child: const Text('Rời khỏi'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  // Phương thức để kiểm tra và xác nhận trước khi rời khỏi
  Future<bool> _confirmBeforeLeaving(
    BuildContext context,
    DieuDongTaiSan? item,
  ) async {
    if (hasUnsavedChanges) {
      return await _showUnsavedChangesDialog(context, item);
    } else {
      _item = item;
      isShowInput = true;
      isShowCollapse = true;
    }
    return true;
  }
}
