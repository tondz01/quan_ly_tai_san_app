// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';

import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

enum FilterStatus {
  all('Tất cả', ColorValue.darkGrey),
  draft('Nháp', ColorValue.silverGray),
  browser('Duyệt', ColorValue.lightBlue),
  complete('Hoàn thành', ColorValue.forestGreen),
  cancel('Hủy', ColorValue.coral);

  final String label;
  final Color activeColor;
  const FilterStatus(this.label, this.activeColor);
}

class AssetHandoverProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  bool get isFindNew => _isFindNew;
  List<AssetHandoverDto>? get dataPage => _dataPage;
  List<DieuDongTaiSanDto>? get dataAssetTransfer => _dataAssetTransfer;
  List<PhongBan>? get dataDepartment => _dataDepartment;
  List<NhanVien>? get dataStaff => _dataStaff;
  List<ChiTietDieuDongTaiSan>? get dataDetailAssetMobilization =>
      _dataDetailAssetMobilization;

  AssetHandoverDto? get item => _item;
  get data => _data;
  get userInfo => _userInfo;
  get filteredData => _filteredData;
  get columns => _columns;
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  // Truy cập trạng thái filter
  bool get isShowAll => _filterStatus[FilterStatus.all] ?? false;
  bool get isShowDraft => _filterStatus[FilterStatus.draft] ?? false;
  bool get isShowBrowser => _filterStatus[FilterStatus.browser] ?? false;
  bool get isShowComplete => _filterStatus[FilterStatus.complete] ?? false;
  bool get isShowCancel => _filterStatus[FilterStatus.cancel] ?? false;

  // Getter để lấy count cho mỗi status
  int get allCount => _data?.length ?? 0;
  int get draftCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 0).length ?? 0;
  int get browserCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 1).length ?? 0;
  int get completeCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 3).length ?? 0;
  int get cancelCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 2).length ?? 0;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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
  bool _isFindNew = false;
  String? get error => _error;
  String? get subScreen => _subScreen;
  String _searchTerm = '';

  int typeAssetTransfer = 1;

  late int totalEntries;
  late int totalPages = 0;
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

  List<AssetHandoverDto>? _data;
  List<AssetHandoverDto>? _dataPage;
  List<DieuDongTaiSanDto>? _dataAssetTransfer;
  List<PhongBan>? _dataDepartment;
  List<NhanVien>? _dataStaff;
  List<ChiTietDieuDongTaiSan>? _dataDetailAssetMobilization;
  // Danh sách dữ liệu đã được lọc
  List<AssetHandoverDto> _filteredData = [];
  final List<SgTableColumn<AssetHandoverDto>> _columns = [];
  AssetHandoverDto? _item;

  UserInfoDTO? _userInfo;

  // Method để refresh data và filter
  void refreshData(BuildContext context) {
    _isLoading = true;

    // Reset filter về trạng thái ban đầu
    _filterStatus.clear();
    _filterStatus[FilterStatus.all] = true;

    // Clear search term
    _searchTerm = '';

    // Reload data
    context.read<AssetHandoverBloc>().add(GetListAssetHandoverEvent(context));
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

  set dataPage(List<AssetHandoverDto>? value) {
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
    List<AssetHandoverDto> statusFiltered;
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

            if (_filterStatus[FilterStatus.browser] == true &&
                (itemStatus == 1)) {
              return true;
            }

            if (_filterStatus[FilterStatus.cancel] == true &&
                (itemStatus == 2)) {
              return true;
            }

            if (_filterStatus[FilterStatus.complete] == true &&
                (itemStatus == 3)) {
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
            return (item.banGiaoTaiSan?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.quyetDinhDieuDongSo?.toLowerCase().contains(
                      searchLower,
                    ) ??
                    false) ||
                (item.tenDonViDaiDien?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.nguoiTao?.toLowerCase().contains(searchLower) ?? false) ||
                (item.tenLanhDao?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.tenDonViGiao?.toLowerCase().contains(searchLower) ??
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
    FilterStatus.browser: false,
    FilterStatus.cancel: false,
    FilterStatus.complete: false,
  };

  // Nội dung tìm kiếm

  void onInit(BuildContext context) {
    _userInfo = AccountHelper.instance.getUserInfo();
    onDispose();
    controllerDropdownPage = TextEditingController(text: '10');

    _body = Container();
    getListAssetHandover(context);
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
    _item = null;
    _dataDetailAssetMobilization = null;
    notifyListeners();
  }

  // Cập nhật danh sách trạng thái

  void getListAssetHandover(BuildContext context) {
    _isLoading = true;
    Future.microtask(() {
      context.read<AssetHandoverBloc>().add(GetListAssetHandoverEvent(context));
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
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
    notifyListeners();
  }

  void onChangeDetail(
    BuildContext context,
    AssetHandoverDto? item, {
    bool isFindNew = false,
  }) {
    if (item != null) {
      getListDetailAssetMobilization(item.lenhDieuDong ?? '');
    }
    _confirmBeforeLeaving(context, item);

    _isFindNew = isFindNew;
    notifyListeners();
  }

  void updateItem(AssetHandoverDto updatedItem) {
    if (_data == null) return;
    int index = _data!.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _data![index] = updatedItem;

      _updatePagination();
      notifyListeners();
    } else {}
  }

  getListAssetHandoverSuccess(
    BuildContext context,
    GetListAssetHandoverSuccessState state,
  ) {
    _error = null;

    _dataDepartment = state.dataDepartment;
    _dataStaff = state.dataStaff;
    _dataAssetTransfer = state.dataAssetTransfer;

    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
      _item = null;
    } else {
      _filteredData.clear();
      _data?.clear();
      _data =
          state.data
              .where(
                (item) =>
                    item.share == true || item.nguoiTao == userInfo?.tenDangNhap,
              )
              .toList();

      _filteredData = List.from(_data!);
      _updatePagination();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> _showUnsavedChangesDialog(
    BuildContext context,
    AssetHandoverDto? item,
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
                    isShowInput = true;
                    isShowCollapse = true;
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
    AssetHandoverDto? item,
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

  Future<void> getListDetailAssetMobilization(String id) async {
    if (id.isEmpty) return;
    _isLoading = true;
    final Map<String, dynamic> result = await AssetHandoverRepository()
        .getListDetailAssetMobilization(id);
    _dataDetailAssetMobilization = result['data'];
    _isLoading = false;
    notifyListeners();
  }

  NhanVien getNhanVien({required String idNhanVien}) {
    if (dataStaff == null) return NhanVien();
    final found = dataStaff!.firstWhere(
      (item) => item.id == idNhanVien,
      orElse: () => NhanVien(),
    );
    return found;
  }

  int isCheckSigningStatus(AssetHandoverDto item) {
    final signatureFlow =
        [
          {
            "id": item.idDaiDiendonviBanHanhQD,
            "signed": item.daXacNhan == true,
            "label": "Người tạo",
          },
          {
            "id": item.idDaiDienBenGiao,
            "signed": item.daiDienBenGiaoXacNhan == true,
            "label": "Trưởng phòng",
          },
          {
            "id": item.idDaiDienBenNhan,
            "signed": item.daiDienBenNhanXacNhan == true,
            "label": "Phó phòng Đơn vị giao",
          },
          if (item.listSignatory?.isNotEmpty ?? false)
            ...(item.listSignatory
                    ?.map(
                      (e) => {
                        "id": e.idNguoiKy,
                        "signed": e.trangThai == 1,
                        "label": e.tenNguoiKy ?? '',
                      },
                    )
                    .toList() ??
                []),
        ].toList();

    final currentIndex = signatureFlow.indexWhere(
      (s) => s["id"] == userInfo.tenDangNhap,
    );
    if (currentIndex == -1) {
      return -1;
    }

    return signatureFlow[currentIndex]["signed"] == true ? 1 : 0;
  }

  NhanVien getNhanVienByID(String idNhanVien) {
    if (_dataStaff != null && _dataStaff!.isNotEmpty) {
      return _dataStaff!.firstWhere(
        (item) => item.id == idNhanVien,
        orElse: () => const NhanVien(),
      );
    } else {
      return const NhanVien();
    }
  }
}
