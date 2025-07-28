// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_movement_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_list.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/row_find_by_status.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

enum FilterStatus {
  all('Tất cả'),
  draft('Nháp'),
  ready('Sẵn sàng'),
  confirm('Xác nhận'),
  browser('Trình duyệt'),
  complete('Hoàn thành'),
  cancel('Hủy');

  final String label;
  const FilterStatus(this.label);
}

class AssetHandoverProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  List<AssetHandoverDto>? get dataPage => _dataPage;
  get data => _data;
  get columns => _columns;
  get listStatus => _listStatus;

  // Truy cập trạng thái filter
  bool get isShowAll => _filterStatus[FilterStatus.all] ?? false;
  bool get isShowDraft => _filterStatus[FilterStatus.draft] ?? false;
  bool get isShowReady => _filterStatus[FilterStatus.ready] ?? false;
  bool get isShowConfirm => _filterStatus[FilterStatus.confirm] ?? false;
  bool get isShowBrowser => _filterStatus[FilterStatus.browser] ?? false;
  bool get isShowComplete => _filterStatus[FilterStatus.complete] ?? false;
  bool get isShowCancel => _filterStatus[FilterStatus.cancel] ?? false;

  // Thuộc tính cho tìm kiếm
  String get searchTerm => _searchTerm;
  set searchTerm(String value) {
    _searchTerm = value;
    _applyFilters(); // Áp dụng filter khi thay đổi nội dung tìm kiếm
    notifyListeners();
  }

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

  set dataPage(List<AssetHandoverDto>? value) {
    _dataPage = value;
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

    onSetListStatus();

    _applyFilters();

    notifyListeners();
  }

  void _applyFilters() {
    if (_data == null) return;

    log('Aplicando filtros con ${_data!.length} elementos');

    bool hasActiveFilter = _filterStatus.entries
        .where((entry) => entry.key != FilterStatus.all)
        .any((entry) => entry.value == true);

    // Lọc theo trạng thái
    List<AssetHandoverDto> statusFiltered;
    if (_filterStatus[FilterStatus.all] == true || !hasActiveFilter) {
      statusFiltered = List.from(_data!);
      log('Filtro por estado: todos los datos (${statusFiltered.length})');
    } else {
      statusFiltered =
          _data!.where((item) {
            int itemStatus = item.state ?? -1;

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

      log('Filtro por estado: ${statusFiltered.length} elementos');
    }

    // Lọc tiếp theo nội dung tìm kiếm
    if (_searchTerm.isNotEmpty) {
      String searchLower = _searchTerm.toLowerCase();
      _filteredData =
          statusFiltered.where((item) {
            return
            // Tên phiếu
            (item.name?.toLowerCase().contains(searchLower) ?? false) ||
                // Số quyết định
                (item.decisionNumber?.toLowerCase().contains(searchLower) ??
                    false) ||
                // Người đề nghị
                (item.createdBy?.toLowerCase().contains(searchLower) ??
                    false) ||
                // Người lập phiếu
                (item.createdBy?.toLowerCase().contains(searchLower) ??
                    false) ||
                // Chi tiết điều động
                (item.assetHandoverMovements?.any(
                      (detail) =>
                          detail.name?.toLowerCase().contains(searchLower) ??
                          false,
                    ) ??
                    false) ||
                // Đơn vị giao/nhận
                (item.senderUnit?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.receiverUnit?.toLowerCase().contains(searchLower) ??
                    false);
          }).toList();

      log('Filtro por búsqueda: ${_filteredData.length} elementos');
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
  late List<ListStatus> _listStatus;

  String? _error;
  String? _subScreen;
  String mainScreen = '';

  Widget? _body;

  bool _isLoading = false;

  List<AssetHandoverDto>? _data;
  List<AssetHandoverDto>? _dataPage;
  // Danh sách dữ liệu đã được lọc
  List<AssetHandoverDto> _filteredData = [];
  List<SgTableColumn<AssetHandoverDto>> _columns = [];

  void onInit(BuildContext context) {
    _isLoading = true;
    controllerDropdownPage = TextEditingController(text: '10');

    // Khởi tạo danh sách trạng thái
    onSetListStatus();

    // Initialize body without triggering notification
    _body = Container();
    // AssetHandoverList(provider: this, mainScreen: onSetMainScreen());
    onChangeScreen(item: null, isMainScreen: true, isEdit: false);
    log('message onInit');
    getListAssetHandover(context);
    log('message onInit 2');
  }

  void onDispose() {
    _isLoading = false;
    _data = null;
    _error = null;

    if (controllerDropdownPage != null) {
      controllerDropdownPage!.dispose();
      controllerDropdownPage = null;
    }
  }

  void onTapBackHeader() {
    onChangeScreen(item: null, isMainScreen: true, isEdit: false);
    notifyListeners();
  }

  void onTapNewHeader() {
    onChangeScreen(item: null, isMainScreen: false, isEdit: true);
    notifyListeners();
  }

  // Cập nhật danh sách trạng thái
  void onSetListStatus() {
    _listStatus = [
      for (var status in FilterStatus.values)
        ListStatus(
          text: status.label,
          isEffective: _filterStatus[status] ?? false,
          onChanged: (value) {
            setFilterStatus(status, value);
          },
        ),
    ];
  }

  void getListAssetHandover(BuildContext context) {
    _isLoading = true;
    Future.microtask(() {
      context.read<AssetHandoverBloc>().add(
        GetListAssetHandoverEvent(context),
      );
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
    log('message pageProducts: ${dataPage!.length}');
  }

  void onChangeScreen({
    required AssetHandoverDto? item,
    required bool isMainScreen,
    required bool isEdit,
  }) {
    // Use Future.microtask to avoid build phase conflicts
    log('message onChangeScreen');
    Future.microtask(() {
      
      if (!isMainScreen) {
        _subScreen = item == null ? 'Mới' : item.name ?? '';
        _body = AssetHandoverDetail(item: item, isEditing: isEdit);
      } else {
        _subScreen = '';
        mainScreen = 'Biên bản bàn giao tài sản';
        _body = AssetHandoverList(provider: this, mainScreen: mainScreen);
      }
      notifyListeners();
    });
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

  void updateItem(AssetHandoverDto updatedItem) {
    if (_data == null) return;

    int index = _data!.indexWhere((item) => item.id == updatedItem.id);

    if (index != -1) {
      _data![index] = updatedItem;

      _updatePagination();

      notifyListeners();

      log('Đã cập nhật item có ID: ${updatedItem.id}');
    } else {
      log('Không tìm thấy item có ID: ${updatedItem.id}');
    }
  }

  void deleteItem(String id) {
    if (_data == null) return;

    // Tìm vị trí của item cần xóa
    int index = _data!.indexWhere((item) => item.id == id);

    if (index != -1) {
      // Xóa item khỏi danh sách
      _data!.removeAt(index);

      // Cập nhật lại trang hiện tại
      _updatePagination();

      // Thông báo UI cập nhật
      notifyListeners();

      log('Đã xóa item có ID: $id');
    } else {
      log('Không tìm thấy item có ID: $id');
    }
  }

  getListAssetHandoverSuccess(
    BuildContext context,
    GetListAssetHandoverSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
    } else {
      _data = state.data;
      _filteredData = List.from(_data!);
      _isLoading = false;
      onSetColumns();
      _updatePagination();
    }
    notifyListeners();
  }

  // String onSetMainScreen() {
  //   return mainScreen =
  //       typeAssetTransfer == 1
  //           ? 'Cấp phát tài sản'
  //           : typeAssetTransfer == 2
  //           ? 'Thu hồi tài sản'
  //           : 'Điều động tài sản';
  // }

  void onSetColumns() {
    _columns = [
      TableColumnBuilder.createTextColumn<AssetHandoverDto>(
        title: 'Bàn giao tài sản',
        getValue: (item) => item.name ?? '',
        width: 170,
      ),
      TableColumnBuilder.createTextColumn<AssetHandoverDto>(
        title: 'Quyết định điều động',
        getValue: (item) => item.decisionNumber ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetHandoverDto>(
        title: 'Lệnh điều động',
        getValue: (item) => item.transferDate ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetHandoverDto>(
        title: 'Ngày bàn giao',
        getValue: (item) => item.transferDate ?? '',
        width: 150,
      ),
      SgTableColumn<AssetHandoverDto>(
        title: 'Chi tiết bàn giao',
        cellBuilder:
            (item) => showMovementDetails(item.assetHandoverMovements ?? []),
        cellAlignment: TextAlign.center,
        titleAlignment: TextAlign.center,
        width: 120,
        searchable: true,
      ),
      TableColumnBuilder.createTextColumn<AssetHandoverDto>(
        title: 'Đơn vị giao',
        getValue: (item) => item.senderUnit ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetHandoverDto>(
        title: 'Đơn vị nhận',
        getValue: (item) => item.receiverUnit ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetHandoverDto>(
        title: 'Người lập phiếu',
        getValue: (item) => item.createdBy ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetHandoverDto>(
        title: 'Trạng thái',
        getValue: (item) => getStatus(item.state ?? 0),
        width: 120,
      ),
    ];
  }

  String getStatus(int status) {
    log('message getStatus: $status');
    switch (status) {
      case 0:
        return 'Nháp';
      case 1:
        return 'Sẵn sàng';
      case 2:
        return 'Xác nhận';
      case 3:
        return 'Trình Duyệt';
      case 4:
        return 'Hoàn thành';
      case 5:
        return 'Hủy';
      default:
        return '';
    }
  }

  Widget showMovementDetails(List<AssetHandoverMovementDto> movementDetails) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:
                movementDetails
                    .map(
                      (detail) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                          color: ColorValue.paleRose,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SGText(
                          text: detail.name ?? '',
                          size: 12,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}
