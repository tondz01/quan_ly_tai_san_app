// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/message/message_service_realtime.dart';

import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/repository/auth_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/provider/table_tool_and_supplies_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
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

class ToolAndSuppliesHandoverProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  bool get isFindNew => _isFindNew;
  bool get isFindNewItem => _isFindNewItem;
  List<ToolAndSuppliesHandoverDto>? get dataPage => _dataPage;
  List<ToolAndMaterialTransferDto>? get dataAssetTransfer => _dataAssetTransfer;
  List<PhongBan>? get dataDepartment => _dataDepartment;
  List<NhanVien>? get dataStaff => _dataStaff;

  String? get loadingMessage => _loadingMessage;

  ToolAndSuppliesHandoverDto? get item => _item;
  get data => _data;
  get dataCcdc => _dataCcdc;
  get userInfo => _userInfo;
  get listOwnershipUnit => _listOwnershipUnit;
  get filteredData => _filteredData;
  get columns => _columns;
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  bool get isUpdateDetail => _isUpdateDetail;
  bool get isShowDetailDepartmentTree => _isShowDetailDepartmentTree;
  String get detailDiagramTitle => _detailDiagramTitle;
  List<ThreadNode> get detailDiagramNodes =>
      List.unmodifiable(_detailDiagramNodes);

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

  set isUpdateDetail(bool value) {
    _isUpdateDetail = value;
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
  bool _isFindNewItem = false;

  String? get error => _error;
  String? get subScreen => _subScreen;
  String _searchTerm = '';
  String? _loadingMessage;
  // Timer? _autoReloadTimer;

  int typeAssetTransfer = 1;

  // List status

  String? _error;
  String? _subScreen;

  Widget? _body;

  bool _isLoading = false;
  bool _isUpdateDetail = false;

  List<ToolAndSuppliesHandoverDto>? _data;
  List<ToolAndSuppliesHandoverDto>? _dataPage;
  List<ToolAndMaterialTransferDto>? _dataAssetTransfer;
  List<PhongBan>? _dataDepartment;
  List<NhanVien>? _dataStaff;
  List<ToolsAndSuppliesDto>? _dataCcdc;
  List<OwnershipUnitDetailDto> _listOwnershipUnit = [];
  // Danh sách dữ liệu đã được lọc
  List<ToolAndSuppliesHandoverDto> _filteredData = [];
  final List<SgTableColumn<ToolAndSuppliesHandoverDto>> _columns = [];

  ToolAndSuppliesHandoverDto? _item;

  // Chi tiết CCDC theo lệnh điều động

  bool _isShowDetailDepartmentTree = false;
  String _detailDiagramTitle = '';
  List<ThreadNode> _detailDiagramNodes = [];

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
    context.read<ToolAndSuppliesHandoverBloc>().add(
      GetListToolAndSuppliesHandoverEvent(context),
    );
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

  void updateDetailDiagram({
    required ToolAndSuppliesHandoverDto item,
    required List<ThreadNode> nodes,
    required String title,
  }) {
    _item = item;
    _detailDiagramTitle = title;
    _detailDiagramNodes = nodes;
    _isShowDetailDepartmentTree = true;
    notifyListeners();
  }

  void hideDetailDiagram() {
    if (!_isShowDetailDepartmentTree) return;
    _isShowDetailDepartmentTree = false;
    notifyListeners();
  }

  set dataPage(List<ToolAndSuppliesHandoverDto>? value) {
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

  void setFilterStatus(BuildContext context, FilterStatus status, bool? value) {
    // Nếu đang bỏ chọn (value == false), chỉ cần bỏ chọn checkbox đó
    if (value == false) {
      _filterStatus[status] = false;
    } else {
      // Sau đó mới chọn checkbox được chọn
      for (var key in _filterStatus.keys) {
        _filterStatus[key] = false;
      }
      _filterStatus[status] = true;
    }

    switch (status) {
      case FilterStatus.draft:
        onFillterByStatus(context, 0);
        break;
      case FilterStatus.browser:
        onFillterByStatus(context, 1);
        break;

      case FilterStatus.cancel:
        onFillterByStatus(context, 2);
        break;
      case FilterStatus.complete:
        onFillterByStatus(context, 3);
        break;
      case FilterStatus.all:
        onFillterByStatus(context, -1);
        break;
    }
    notifyListeners();
  }

  onReloadDataPage(BuildContext context, [bool isRefresh = true]) {
    final container = ProviderScope.containerOf(context);
    container
        .read(tableToolAndSuppliesHandoverProvider.notifier)
        .refreshData(isRefresh);
  }

  onFillterByStatus(BuildContext context, int status) {
    final container = ProviderScope.containerOf(context);
    container
        .read(tableToolAndSuppliesHandoverProvider.notifier)
        .filterByStatus(status);
    // onReloadDataPage(context);
  }

  void _applyFilters() {
    if (_data == null) return;

    bool hasActiveFilter = _filterStatus.entries
        .where((entry) => entry.key != FilterStatus.all)
        .any((entry) => entry.value == true);

    // Lọc theo trạng thái
    List<ToolAndSuppliesHandoverDto> statusFiltered;
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
            return (item.banGiaoCCDCVatTu?.toLowerCase().contains(
                      searchLower,
                    ) ??
                    false) ||
                (item.quyetDinhDieuDongSo?.toLowerCase().contains(
                      searchLower,
                    ) ??
                    false) ||
                (item.banGiaoCCDCVatTu?.toLowerCase().contains(searchLower) ??
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

  void onInit(BuildContext context) async {
    _userInfo = AccountHelper.instance.getUserInfo();
    onDispose();

    _body = Container();
    onLoadDataDropdown();
    onLoadDataCcdc(context);
    // getListToolAndSuppliesHandover(context);
    onLoadDataAssetTransfer();
    // _autoReloadTimer?.cancel();
    // _autoReloadTimer = Timer.periodic(const Duration(seconds: 20), (_) {
    //   onReloadDataToolAndMaterialHandover();
    //   print("reload data tool and supplies handover");
    // });
  }

  onLoadDataAssetTransfer() async {
    _dataAssetTransfer =
        await ToolAndMaterialTransferRepository()
            .getAllToolAndMeterialTransferByCT();
    notifyListeners();
  }

  void onRealtimeUpdate(dynamic jsonMsg, BuildContext context) {
    if (jsonMsg['type_func'] == FunctionType.TOOL_AND_SUPPLIES_HANDOVER) {
      log(
        'message [ref.listen] [ToolAndSuppliesHandoverProvider] update received: $jsonMsg',
      );
      if (AppUtility.userInList(
        userInfo?.tenDangNhap ?? '',
        jsonMsg['id_need_to_do'] ?? '',
      )) {
        onReloadDataPage(context);
      }
    } else if (jsonMsg['type_func'] == FunctionType.ALL_FUNCTION) {
      onReloadDataPage(context);
    }
  }

  onLoadDataDropdown() {
    _dataDepartment = AccountHelper.instance.getDepartment();
    _dataStaff = AccountHelper.instance.getNhanVien();
    if (_dataStaff == null) {
      AuthRepository().loadUserEmployee('ct001');
      _dataStaff = AccountHelper.instance.getNhanVien();
    }
    if (_dataDepartment == null) {
      AuthRepository().loadUserDepartments('ct001');
      _dataDepartment = AccountHelper.instance.getDepartment();
    }
  }

  void onReloadDataToolAndMaterialHandover() async {
    Map<String, dynamic> result =
        await ToolAndSuppliesHandoverRepository()
            .getListToolAndSuppliesHandover();

    _data = result['data'];
    _data =
        _data?.where((item) {
          return item.share == true || item.nguoiTao == userInfo?.tenDangNhap;
        }).toList();
    _filteredData = List.from(_data!);
    if (_data != null) {
      // refreshCountSign(_data!);
    }
    _applyFilters();
    notifyListeners();
  }

  void onDispose() {
    _isLoading = false;
    _isShowInput = false;
    _data = null;
    _error = null;
    _filterStatus.clear();
    _filterStatus[FilterStatus.all] = true;
    // _autoReloadTimer?.cancel();
    // _autoReloadTimer = null;
  }

  void onTapBackHeader() {
    notifyListeners();
  }

  void onTapNewHeader() {
    _item = null;
    notifyListeners();
  }

  onCloseDetail() {
    _item = null;
    _isShowCollapse = true;
    _isShowInput = false;
    if (isLoading) {
      _isLoading = false;
    }
    notifyListeners();
  }
  // Cập nhật danh sách trạng thái

  void getListToolAndSuppliesHandover(BuildContext context) {
    _isLoading = true;
    Future.microtask(() {
      context.read<ToolAndSuppliesHandoverBloc>().add(
        GetListToolAndSuppliesHandoverEvent(context),
      );
    });
  }

  onLoadDataCcdc(BuildContext context) {
    _dataCcdc = AccountHelper.instance.getAllCCDC();
    if (_dataCcdc == null) {
      if (AccountHelper.instance.getAllCCDC().isEmpty) {
        AuthRepository().loadCCDCGroup('ct001').then((value) {
          _dataCcdc = AccountHelper.instance.getAllCCDC();
          notifyListeners();
        });
      } else {
        _dataCcdc = AccountHelper.instance.getAllCCDC();
        notifyListeners();
      }
    }
  }

  void onChangeDetail(
    BuildContext context,
    ToolAndSuppliesHandoverDto? item, {
    bool isFindNew = false,
    bool isFindNewItem = false,
  }) async {
    if (item != null) {
      onSetLoadingMessage('Đang tải dữ liệu...');
      _isLoading = true;

      if (_dataCcdc == null) {
        if (AccountHelper.instance.getAllCCDC().isEmpty) {
          await AuthRepository().loadCCDCGroup('ct001').then((value) {
            _dataCcdc = AccountHelper.instance.getAllCCDC();
          });
        } else {
          _dataCcdc = AccountHelper.instance.getAllCCDC();
        }
      }
      await getListOwnership(item.idDonViGiao ?? '').then((value) {
        _item = item;
      });
      await onLoadDataAssetTransfer().then((value) {
        isShowInput = true;
        isShowCollapse = true;
        _isUpdateDetail = true;
        _isFindNew = isFindNew;
        _isFindNewItem = isFindNewItem;
        notifyListeners();
      });
    }
  }

  void updateItem(ToolAndSuppliesHandoverDto updatedItem) {
    if (_data == null) return;
    int index = _data!.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _data![index] = updatedItem;
      _applyFilters();
      notifyListeners();
    } else {}
  }

  getListToolAndSuppliesHandoverSuccess(
    BuildContext context,
    GetListToolAndSuppliesHandoverSuccessState state,
  ) {
    _error = null;

    // _dataDepartment = state.dataDepartment;
    // _dataStaff = state.dataStaff;
    _filteredData.clear();
    _data?.clear();
    if (state.data.isEmpty) {
      log("check state.data: ${jsonEncode(state.data)}");

      _data = [];
      _filteredData = [];
      _item = null;
    } else {
      refreshCountSign(state.data);
      _data =
          state.data.where((item) {
            return item.share == true || item.nguoiTao == userInfo?.tenDangNhap;
          }).toList();

      _filteredData = List.from(_data!);
    }
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  refreshCountSign(List<ToolAndSuppliesHandoverDto> data) {
    AccountHelper.instance.clearToolAndSuppliesHandover();
    AccountHelper.instance.setToolAndMaterialHandover(data);
    AccountHelper.refreshAllCounts();
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

  int isCheckSigningStatus(ToolAndSuppliesHandoverDto item) {
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

    final currentSigner = signatureFlow[currentIndex];

    if (item.idDaiDiendonviBanHanhQD == userInfo.tenDangNhap &&
        currentSigner["signed"] != -1) {
      return currentSigner["signed"] == true
          ? 3
          : 5; // 3: Đã ký & tạo, 5: Chưa ký & tạo
    }

    if (item.idDaiDiendonviBanHanhQD == userInfo.tenDangNhap) {
      return -1; // Chỉ là người tạo, không phải người ký
    }

    return currentSigner["signed"] == true ? 1 : 0;
  }

  NhanVien getNhanVienByID(String idNhanVien) {
    NhanVien? nhanVien = AccountHelper.instance.getNhanVienById(idNhanVien);
    if (nhanVien != null) {
      return nhanVien;
    } else {
      return const NhanVien();
    }
  }

  Future<List<OwnershipUnitDetailDto>> getListOwnership(String id) async {
    if (id.isEmpty) return [];
    Map<String, dynamic> result = await ToolAndMaterialTransferRepository()
        .getListOwnershipUnit(id);
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      final List<dynamic> rawData = result['data'];
      final list =
          rawData.map((item) => OwnershipUnitDetailDto.fromJson(item)).toList();
      _listOwnershipUnit = list;
      _isLoading = false;
      notifyListeners();
      return list;
    } else {
      return [];
    }
  }

  onPushMessage(ToolAndSuppliesHandoverDto item) {
    String newSignatory =
        item.listSignatory?.map((e) => e.idNguoiKy).join(',') ?? '';
    String idNeedToDo =
        "${item.idDonViGiao},${item.idDonViNhan},${item.idGiamDoc},$newSignatory, admin,${item.nguoiTao}";
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      MessageServiceRealtime().pushJsonMessage(
        typeFunc: FunctionType.TOOL_AND_SUPPLIES_HANDOVER,
        typeAction: ActionType.CREATE,
        idNeedToDo: idNeedToDo,
      );
    });
  }

  onSetLoadingMessage(String? message) {
    _loadingMessage = message;
    notifyListeners();
  }

  String genID() {
    final now = DateTime.now();
    final year = now.year;
    String code = "BGDCC";
    String random = UUIDGenerator.generateRandomNumber(6);
    return "$code-$year-$random";
  }

  /// Lọc danh sách AssetTransfer dựa trên quyền của người dùng
  /// - Nếu người dùng thuộc phòng ban kho: lấy tất cả phiếu thuộc các phòng ban kho
  /// - Nếu không: lọc theo phòng ban của người dùng
  /// [isEditing] - Nếu false, trả về tất cả (không lọc)
  List<ToolAndMaterialTransferDto> getFilteredAssetTransfer({
    bool isEditing = false,
  }) {
    if (_dataAssetTransfer == null) return [];

    final userInfo = AccountHelper.instance.getUserInfo();
    if (userInfo == null) return [];

    final nhanVien = AccountHelper.instance.getNhanVienById(
      userInfo.tenDangNhap,
    );
    if (nhanVien == null) return [];

    // Lấy tất cả các ID phòng ban kho
    final idPhongBanKhoSet =
        (_dataDepartment ?? [])
            .where((element) => element.isKho == true)
            .map((element) => element.id)
            .whereType<String>()
            .toSet();
    // Kiểm tra xem nhân viên có thuộc phòng ban kho không
    final isNhanVienKho =
        nhanVien.phongBanId != null &&
        idPhongBanKhoSet.contains(nhanVien.phongBanId);
    return _dataAssetTransfer!.where((element) => element.trangThai == 3).where(
      (element) {
        if (isEditing) return true;

        // Nếu nhân viên thuộc kho, lấy tất cả phiếu thuộc các phòng ban kho
        if (isNhanVienKho) {
          return idPhongBanKhoSet.contains(element.idDonViGiao) ||
              idPhongBanKhoSet.contains(element.idDonViNhan);
        }

        // Nếu không phải kho, lọc theo phòng ban của nhân viên
        final idDonViGiao = nhanVien.phongBanId ?? nhanVien.boPhan;
        if (idDonViGiao == null || idDonViGiao.isEmpty) return false;

        return element.idDonViGiao == idDonViGiao ||
            element.idDonViNhan == idDonViGiao;
      },
    ).toList();
  }
}
