// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/asset_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/asset_transfer_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/asset_transfer_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/row_find_by_status.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/movement_detail_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

enum FilterStatus {
  all('Tất cả'),
  request('Yêu cầu'),
  confirm('Chờ xác nhận'),
  approve('Chờ duyệt'),
  reject('Bị từ chối'),
  complete('Đã hoàn thành');

  final String label;
  const FilterStatus(this.label);
}

class AssetTransferProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  List<AssetTransferDto>? get dataPage => _dataPage;
  AssetTransferDto? get item => _item;
  get data => _data;
  get columns => _columns;
  // get listStatus => _listStatus;

  bool get isShowAll => _filterStatus[FilterStatus.all] ?? false;
  bool get isShowRequest => _filterStatus[FilterStatus.request] ?? false;
  bool get isShowConfirm => _filterStatus[FilterStatus.confirm] ?? false;
  bool get isShowApprove => _filterStatus[FilterStatus.approve] ?? false;
  bool get isShowReject => _filterStatus[FilterStatus.reject] ?? false;
  bool get isShowComplete => _filterStatus[FilterStatus.complete] ?? false;

  String get searchTerm => _searchTerm;
  set searchTerm(String value) {
    _searchTerm = value;
    _applyFilters();
    notifyListeners();
  }

  String? get error => _error;
  String? get subScreen => _subScreen;
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
  // late List<ListStatus> _listStatus;

  String? _error;
  String? _subScreen;
  String mainScreen = '';


  bool _isShowInput = false;
  bool _isLoading = false;
  bool _isShowCollapse = true;
  List<AssetTransferDto>? _data;
  List<AssetTransferDto>? _dataPage;
  List<AssetTransferDto> _filteredData = [];
  AssetTransferDto? _item;
  List<SgTableColumn<AssetTransferDto>> _columns = [];

  set subScreen(String? value) {
    _subScreen = value;
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

  set dataPage(List<AssetTransferDto>? value) {
    _dataPage = value;
    notifyListeners();
  }

  void setFilterStatus(FilterStatus status, bool? value) {
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

    bool hasActiveFilter = _filterStatus.entries
        .where((entry) => entry.key != FilterStatus.all)
        .any((entry) => entry.value == true);

    List<AssetTransferDto> statusFiltered;
    if (_filterStatus[FilterStatus.all] == true || !hasActiveFilter) {
      statusFiltered = List.from(_data!);
      log('Filtro por estado: todos los datos (${statusFiltered.length})');
    } else {
      statusFiltered =
          _data!.where((item) {
            int itemStatus = item.status ?? 0;

            if (_filterStatus[FilterStatus.request] == true &&
                (itemStatus == 1 || itemStatus == 2)) {
              return true;
            }

            if (_filterStatus[FilterStatus.confirm] == true &&
                itemStatus == 3) {
              return true;
            }

            if (_filterStatus[FilterStatus.approve] == true &&
                (itemStatus == 4 || itemStatus == 5)) {
              return true;
            }

            if (_filterStatus[FilterStatus.reject] == true &&
                (itemStatus == 6 || itemStatus == 7)) {
              return true;
            }

            if (_filterStatus[FilterStatus.complete] == true &&
                (itemStatus == 8)) {
              return true;
            }

            return false;
          }).toList();
    }

    if (_searchTerm.isNotEmpty) {
      String searchLower = _searchTerm.toLowerCase();
      _filteredData =
          statusFiltered.where((item) {
            return (item.documentName?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.decisionNumber?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.requester?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.creator?.toLowerCase().contains(searchLower) ?? false) ||
                (item.movementDetails?.any(
                      (detail) =>
                          detail.name?.toLowerCase().contains(searchLower) ??
                          false,
                    ) ??
                    false) ||
                (item.deliveringUnit?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.receivingUnit?.toLowerCase().contains(searchLower) ??
                    false);
          }).toList();
    } else {
      _filteredData = statusFiltered;
    }

    _updatePagination();
  }

  final Map<FilterStatus, bool> _filterStatus = {
    FilterStatus.all: false,
    FilterStatus.request: false,
    FilterStatus.confirm: false,
    FilterStatus.approve: false,
    FilterStatus.reject: false,
    FilterStatus.complete: false,
  };

  void onInit(BuildContext context, int typeAssetTransfer) {
    onDispose();
    this.typeAssetTransfer = typeAssetTransfer;
    _isLoading = true;
    controllerDropdownPage = TextEditingController(text: '10');

    onSetListStatus();
    getListToolsAndSupplies(context);
  }

  void onDispose() {
    _isLoading = false;
    _data = null;
    _error = null;
    _isShowInput = false;
    _item = null;
    _isShowCollapse = true;
    log('onDispose AssetTransferProvider');
    if (controllerDropdownPage != null) {
      controllerDropdownPage!.dispose();
      controllerDropdownPage = null;
    }
  }

  void onSetListStatus() {
    // _listStatus = [
      // for (var status in FilterStatus.values)
      //   ListStatus(
      //     text: status.label,
      //     isEffective: _filterStatus[status] ?? false,
      //     onChanged: (value) {
      //       // Actualize el estado directamente y luego notifique
      //       setFilterStatus(status, value);
      //       // No es necesario llamar a notifyListeners aquí porque setFilterStatus ya lo hace
      //     },
      //   ),
    // ];
  }

  void getListToolsAndSupplies(BuildContext context) {
    _isLoading = true;
    Future.microtask(() {
      context.read<AssetTransferBloc>().add(
        GetListAssetTransferEvent(context, typeAssetTransfer),
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

  

  void onPageChanged(int page) {
    currentPage = page;
    _updatePagination();
    notifyListeners();
  }

  void onChangeDetailAssetTransfer(AssetTransferDto? item) {
    // onChangeScreen(item: item, isMainScreen: false, isEdit: true);
    _item = item;
    log('message onChangeDetailAssetTransfer: $_item');
    isShowInput = true;
    isShowCollapse = true;
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

  void updateItem(AssetTransferDto updatedItem) {
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

  getListAssetTransferSuccess(
    BuildContext context,
    GetListAssetTransferSuccessState state,
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

  String onSetMainScreen() {
    return mainScreen =
        typeAssetTransfer == 1
            ? 'Cấp phát tài sản'
            : typeAssetTransfer == 2
            ? 'Thu hồi tài sản'
            : 'Điều động tài sản';
  }

  void onSetColumns() {
    _columns = [
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Tên phiếu',
        getValue: (item) => item.documentName ?? '',
        width: 170,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Số quyết định',
        getValue: (item) => item.decisionNumber ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Ngày quyết định',
        getValue: (item) => item.decisionDate ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Người đề nghị',
        getValue: (item) => item.requester ?? '',
        width: 150,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Người lập phiếu',
        getValue: (item) => item.creator ?? '',
        width: 150,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Chi tiết điều động',
        getValue:
            (item) =>
                item.movementDetails
                    ?.map((detail) => detail.name ?? '')
                    .join('\n') ??
                '',
        width: 170,
      ),
      SgTableColumn<AssetTransferDto>(
        title: 'Có hiệu lực',
        cellBuilder: (item) => showMovementDetails(item.movementDetails ?? []),
        cellAlignment: TextAlign.center,
        titleAlignment: TextAlign.center,
        width: 120,
        searchable: true,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Đơn vị giao',
        getValue: (item) => item.deliveringUnit ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Đơn vị nhận',
        getValue: (item) => item.receivingUnit ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'TGGN từ Ngày',
        getValue: (item) => item.effectiveDate ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Trình duyệt Ban giám đốc',
        getValue: (item) => item.approver ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Trạng thái',
        getValue: (item) => getStatus(item.status ?? 0),
        width: 120,
      ),
      SgTableColumn<AssetTransferDto>(
        title: 'Có hiệu lực',
        cellBuilder: (item) => showEffective(item.isEffective ?? false),
        sortValueGetter: (item) => item.isEffective,
        searchValueGetter:
            (item) => (item.isEffective ?? false) ? 'Có' : 'Không',
        cellAlignment: TextAlign.center,
        titleAlignment: TextAlign.center,
        width: 120,
        searchable: true,
      ),
    ];
  }

  String getStatus(int status) {
    switch (status) {
      case 0:
        return 'Nháp';
      case 1:
        return 'Chờ xác nhận';
      case 2:
        return 'Xác nhận';
      case 3:
        return 'Trình Duyệt';
      case 4:
        return 'Duyệt';
      case 5:
        return 'Từ chối';
      case 6:
        return 'Hủy';
      case 7:
        return 'Hoàn thành';
      default:
        return '';
    }
  }

  Widget showEffective(bool isEffective) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Checkbox(
        value: isEffective,
        onChanged: null, // Checkbox is read-only, no setState in provider
        activeColor: const Color(0xFF80C9CB), // màu xanh nhạt
        checkColor: Colors.white, // dấu tick màu trắng
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2), // vuông góc
        ),
        materialTapTargetSize:
            MaterialTapTargetSize.shrinkWrap, // thu nhỏ vùng tap
        visualDensity: VisualDensity.compact, // giảm padding
      ),
    );
  }

  Widget showMovementDetails(List<MovementDetailDto> movementDetails) {
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

  Widget showStatus(int status) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: getColorStatus(status),
          borderRadius: BorderRadius.circular(4),
        ),
        child: SGText(
          text: getStatus(status),
          size: 12,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Color getColorStatus(int status) {
    switch (status) {
      case 0:
        return ColorValue.silverGray;
      case 1:
        return ColorValue.lightAmber;
      case 2:
        return ColorValue.mediumGreen;
      case 3:
        return ColorValue.lightBlue;
      case 4:
        return ColorValue.cyan;
      case 5:
        return ColorValue.brightRed;
      case 6:
        return ColorValue.coral;
      case 7:
        return ColorValue.forestGreen;
      default:
        return ColorValue.paleRose;
    }
  }

  // Add method to create a new asset transfer
  Future<void> createAssetTransfer(AssetTransferDto item) async {
    final newItem = AssetTransferDto(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      documentName: item.documentName,
      decisionNumber: item.decisionNumber,
      decisionDate: item.decisionDate,
      subject: item.subject,
      requester: item.requester,
      creator: 'Current User', // Would come from authentication service
      movementDetails: item.movementDetails,
      deliveringUnit: item.deliveringUnit,
      receivingUnit: item.receivingUnit,
      proposingUnit: item.proposingUnit,
      deliveryLocation: item.deliveryLocation,
      effectiveDate: item.effectiveDate,
      effectiveDateTo: item.effectiveDateTo,
      preparerInitialed: item.preparerInitialed,
      requireManagerApproval: item.requireManagerApproval,
      deputyConfirmed: item.deputyConfirmed,
      departmentApproval: item.departmentApproval,
      approver: item.approver,
      status: 0, // Draft status
      isEffective: false,
      documentFilePath: item.documentFilePath,
      documentFileName: item.documentFileName,
    );

    _data ??= [];
    _data!.add(newItem);

    _filteredData = List.from(_data!);
    _updatePagination();

    notifyListeners();
  }

  Future<void> updateAssetTransfer(AssetTransferDto updatedItem) async {
    if (_data == null || updatedItem.id == null) return;

    log('Updating asset transfer: ${updatedItem.id}');

    int index = _data!.indexWhere((item) => item.id == updatedItem.id);

    if (index != -1) {
      _data![index] = updatedItem;

      _filteredData = List.from(_data!);
      _updatePagination();

      notifyListeners();
    }
  }
}
