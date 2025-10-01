import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_event.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/request/detail_tool_and_material_transfer_request.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/request/tool_and_material_transfer_request.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/detail_subpplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import '../bloc/tool_and_material_transfer_state.dart';
import '../model/tool_and_material_transfer_dto.dart';

enum FilterStatus {
  all('Tất cả', ColorValue.darkGrey),
  draft('Nháp', ColorValue.silverGray),
  approve('Duyệt', ColorValue.cyan),
  cancel('Hủy', ColorValue.coral),
  complete('Hoàn thành', ColorValue.forestGreen);

  final String label;
  final Color activeColor;
  const FilterStatus(this.label, this.activeColor);
}

class ToolAndMaterialTransferProvider with ChangeNotifier {
  bool get isLoading => _data == null || _dataAsset == null;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  get userInfo => _userInfo;
  List<ToolAndMaterialTransferDto>? get dataPage => _dataPage;
  ToolAndMaterialTransferDto? get item => _item;
  get data => _data;
  get filteredData => _filteredData;
  get dataAsset => _dataAsset;
  get dataPhongBan => _dataPhongBan;
  get dataNhanVien => _dataNhanVien;
  get listOwnershipUnit => _listOwnershipUnit;
  get listDetailTransferCCDC => _listDetailTransferCCDC;

  get itemsDDPhongBan => _itemsDDPhongBan;
  get itemsDDNhanVien => _itemsDDNhanVien;
  // get listStatus => _listStatus;

  bool get isShowAll => _filterStatus[FilterStatus.all] ?? false;
  bool get isShowDraft => _filterStatus[FilterStatus.draft] ?? false;
  bool get isShowApprove => _filterStatus[FilterStatus.approve] ?? false;
  bool get isShowCancel => _filterStatus[FilterStatus.cancel] ?? false;
  bool get isShowComplete => _filterStatus[FilterStatus.complete] ?? false;

  // Getter để lấy count cho mỗi status
  int get allCount => _data?.length ?? 0;
  int get draftCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 0).length ?? 0;
  int get approveCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 1).length ?? 0;
  int get cancelCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 2).length ?? 0;
  int get completeCount =>
      _data?.where((item) => (item.trangThai ?? 0) == 3).length ?? 0;

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

  int typeToolAndMaterialTransfer = 1;

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

  List<DropdownMenuItem<PhongBan>> _itemsDDPhongBan = [];
  List<DropdownMenuItem<NhanVien>> _itemsDDNhanVien = [];

  // List status
  // late List<ListStatus> _listStatus;

  String? _error;
  String? _subScreen;
  String mainScreen = '';

  bool _isShowInput = false;
  bool _isShowCollapse = true;
  List<ToolAndMaterialTransferDto>? _data;
  List<ToolsAndSuppliesDto>? _dataAsset;
  List<PhongBan>? _dataPhongBan;
  List<NhanVien>? _dataNhanVien;
  List<ToolAndMaterialTransferDto>? _dataPage;
  List<ToolAndMaterialTransferDto> _filteredData = [];
  List<OwnershipUnitDetailDto> _listOwnershipUnit = [];
  List<DetailSubppliesHandoverDto> _listDetailTransferCCDC = [];
  List<ThreadNode> listSignatoryDetail = [];

  ToolAndMaterialTransferDto? _item;
  UserInfoDTO? _userInfo;

  String idCongTy = 'CT001';

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

  set dataPage(List<ToolAndMaterialTransferDto>? value) {
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

    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (_data == null) return;

    bool hasActiveFilter = _filterStatus.entries
        .where((entry) => entry.key != FilterStatus.all)
        .any((entry) => entry.value == true);

    List<ToolAndMaterialTransferDto> statusFiltered;
    if (_filterStatus[FilterStatus.all] == true || !hasActiveFilter) {
      statusFiltered = List.from(_data!);
    } else {
      statusFiltered =
          _data!.where((item) {
            int itemStatus = item.trangThai ?? 0;
            if (_filterStatus[FilterStatus.draft] == true &&
                (itemStatus == 0)) {
              return true;
            }
            if (_filterStatus[FilterStatus.approve] == true &&
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

    if (_searchTerm.isNotEmpty) {
      String searchLower = _searchTerm.toLowerCase();
      _filteredData =
          statusFiltered.where((item) {
            return (item.tenPhieu?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.soQuyetDinh?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.tenNguoiDeNghi?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.nguoiTao?.toLowerCase().contains(searchLower) ?? false) ||
                (item.detailToolAndMaterialTransfers?.any(
                      (detail) =>
                          detail.tenCCDCVatTu?.toLowerCase().contains(
                            searchLower,
                          ) ??
                          false,
                    ) ??
                    false) ||
                (item.tenDonViGiao?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.tenDonViNhan?.toLowerCase().contains(searchLower) ??
                    false);
          }).toList();
    } else {
      _filteredData = statusFiltered;
    }

    _updatePagination();
  }

  final Map<FilterStatus, bool> _filterStatus = {
    FilterStatus.all: false,
    FilterStatus.draft: false,
    FilterStatus.approve: false,
    FilterStatus.cancel: false,
    FilterStatus.complete: false,
  };

  void onInit(BuildContext context, int type) {
    typeToolAndMaterialTransfer = type;
    _initData(context);
  }

  void refreshData(BuildContext context, int type) {
    typeToolAndMaterialTransfer = type;
    _data = null;
    _dataPage = null;
    _item = null;
    _listOwnershipUnit = [];
    notifyListeners();
    _initData(context);
  }

  void _initData(BuildContext context) {
    _userInfo = AccountHelper.instance.getUserInfo();
    onCloseDetail(context);

    controllerDropdownPage = TextEditingController(text: '10');

    getDataAll(context);
  }

  void onDispose() {
    _data = null;
    _error = null;
    _isShowInput = false;
    _item = null;
    _isShowCollapse = true;
    _filterStatus.clear();
    _filterStatus[FilterStatus.all] = true;
    _listOwnershipUnit = [];
    if (controllerDropdownPage != null) {
      controllerDropdownPage!.dispose();
      controllerDropdownPage = null;
    }
  }

  void getDataAll(BuildContext context) {
    try {
      final bloc = context.read<ToolAndMaterialTransferBloc>();
      bloc.add(
        GetListToolAndMaterialTransferEvent(
          context,
          typeToolAndMaterialTransfer,
          _userInfo?.idCongTy ?? '',
        ),
      );
      bloc.add(GetListAssetEvent(context, _userInfo?.idCongTy ?? ''));
      bloc.add(GetDataDropdownEvent(context, _userInfo?.idCongTy ?? ''));
    } catch (e) {
      log('Error adding AssetManagement events: $e');
    }
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

  void onCloseDetail(BuildContext context) {
    _isShowCollapse = true;
    _isShowInput = false;
    notifyListeners();
  }

  void onChangeDetailToolAndMaterialTransfer(
    ToolAndMaterialTransferDto? item,
  ) async {
    // onChangeScreen(item: item, isMainScreen: false, isEdit: true);
    _item = item;
    isShowInput = true;
    isShowCollapse = true;
    if (item != null) {
      _listDetailTransferCCDC = await getListDetailTransferCCDC(item.id!);
      log(
        "check result listDetailTransferCCDC: ${jsonEncode(_listDetailTransferCCDC)}",
      );
      buildThreadNodes(item);
    }
    notifyListeners();
  }

  void onRowsPerPageChanged(int? value) {
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
    notifyListeners();
  }

  void updateItem(ToolAndMaterialTransferDto updatedItem) {
    if (_data == null) return;

    int index = _data!.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _data![index] = updatedItem;
      _updatePagination();
      notifyListeners();
    } else {
      log('Không tìm thấy item có ID: ${updatedItem.id}');
    }
  }

  getListToolAndMaterialTransferSuccess(
    BuildContext context,
    GetListToolAndMaterialTransferSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
      _dataPage = [];
    } else {
      AccountHelper.instance.clearToolAndMaterialTransfer();
      AccountHelper.instance.setToolAndMaterialTransfer(state.data);
      AccountHelper.refreshAllCounts();
      _data =
          state.data
              .where((element) => element.loai == typeToolAndMaterialTransfer)
              .where(
                (item) =>
                    item.share == true ||
                    item.nguoiTao == userInfo?.tenDangNhap,
              )
              .where((item) {
                final idSignatureGroup =
                    [
                      item.nguoiTao,
                      item.idNguoiKyNhay,
                      item.idTrinhDuyetCapPhong,
                      item.idTrinhDuyetGiamDoc,
                      if (item.listSignatory != null)
                        ...item.listSignatory!.map((e) => e.idNguoiKy),
                    ].whereType<String>().toList();

                final inGroup = idSignatureGroup
                    .map((e) => e.toLowerCase())
                    .contains(userInfo.tenDangNhap.toLowerCase());
                return inGroup;
              })
              .toList();
      _filteredData = List.from(_data!);
    }
    _updatePagination();
    notifyListeners();
  }

  getLisTaiSanSuccess(BuildContext context, GetListAssetSuccessState state) {
    _error = null;
    if (state.data.isEmpty) {
      _dataAsset = [];
    } else {
      _dataAsset = state.data;
    }
    notifyListeners();
  }

  getDataDropdownSuccess(
    BuildContext context,
    GetDataDropdownSuccessState state,
  ) {
    _error = null;
    if (state.dataPb.isEmpty) {
      _dataPhongBan = [];
    } else {
      _dataPhongBan = state.dataPb;
      _itemsDDPhongBan = [
        for (var element in _dataPhongBan!)
          DropdownMenuItem<PhongBan>(
            value: element,
            child: Text(element.tenPhongBan ?? ''),
          ),
      ];
    }
    if (state.dataNv.isEmpty) {
      _dataNhanVien = [];
    } else {
      _dataNhanVien = state.dataNv;
      _itemsDDNhanVien = [
        for (var element in _dataNhanVien!)
          DropdownMenuItem<NhanVien>(
            value: element,
            child: Text(element.hoTen ?? ''),
          ),
      ];
    }
    notifyListeners();
  }

  void createDieuDongSuccess(
    BuildContext context,
    CreateDieuDongSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Thêm mới thành công!');
    getDataAll(context);
    notifyListeners();
  }

  PhongBan getPhongBanByID(String idPhongBan) {
    if (_dataPhongBan != null && _dataPhongBan!.isNotEmpty) {
      return _dataPhongBan!.firstWhere(
        (item) => item.id == idPhongBan,
        orElse: () => const PhongBan(),
      );
    } else {
      return const PhongBan();
    }
  }

  NhanVien getNhanVienByID(String idNhanVien) {
    if (_dataNhanVien != null && _dataNhanVien!.isNotEmpty) {
      return _dataNhanVien!.firstWhere(
        (item) => item.id == idNhanVien,
        orElse: () => const NhanVien(),
      );
    } else {
      return const NhanVien();
    }
  }

  void updateDieuDongSuccess(
    BuildContext context,
    UpdateDieuDongSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Cập nhật thành công!');
    getDataAll(context);
    notifyListeners();
  }

  void deleteDieuDongSuccess(
    BuildContext context,
    DeleteDieuDongSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Xóa thành công!');
    getDataAll(context);
    notifyListeners();
  }

  void updateSigningTAMTStatusSuccess(
    BuildContext context,
    UpdateSigningTAMTStatusSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Cập nhập trạng thái thành cồng!');
    getDataAll(context);
    notifyListeners();
  }

  void putPostDeleteFailed(
    BuildContext context,
    PutPostDeleteFailedState state,
  ) {
    AppUtility.showSnackBar(context, state.message);
    notifyListeners();
  }

  Future<void> saveAssetTransfer(
    BuildContext context,
    ToolAndMaterialTransferRequest request,
    List<ChiTietBanGiaoRequest> requestDetail,
    List<SignatoryDto> requestSignatory,
    String fileName,
    String filePath,
    Uint8List fileBytes,
  ) async {
    Map<String, dynamic>? result = await uploadWordDocument(
      context,
      fileName,
      filePath,
      fileBytes,
    );
    if (result == null) {
      notifyListeners();
      return;
    }
    request.duongDanFile = result['filePath'] ?? '';
    request.tenFile = result['fileName'] ?? '';

    SGLog.debug(
      "AssetTransferProvider",
      "result: $result ${result['fileName'] ?? ''} ${result['filePath'] ?? ''}",
    );
    if (!context.mounted) return;
    final bloc = context.read<ToolAndMaterialTransferBloc>();
    bloc.add(
      CreateToolAndMaterialTransferEvent(
        context,
        request,
        requestDetail,
        requestSignatory,
      ),
    );

    notifyListeners();
  }

  Future<Map<String, dynamic>?> uploadWordDocument(
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
              ? await ToolAndMaterialTransferRepository().uploadFileBytes(
                fileName,
                fileBytes,
              )
              : await ToolAndMaterialTransferRepository().uploadFile(filePath);
      final statusCode = result['status_code'] as int? ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        if (context.mounted) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Tệp "$fileName" đã được tải lên thành công'),
          //     backgroundColor: Colors.green.shade600,
          //   ),
          // );
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
      SGLog.debug("AssetTransferDetail", ' Error uploading file: $e');
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

  Future<void> updateAssetTransfer(
    ToolAndMaterialTransferDto updatedItem,
  ) async {
    if (_data == null) return;

    SGLog.debug(
      "AssetTransferProvider",
      'Updating asset transfer: ${updatedItem.id}',
    );

    int index = _data!.indexWhere((item) => item.id == updatedItem.id);

    if (index != -1) {
      _data![index] = updatedItem;

      _filteredData = List.from(_data!);
      _updatePagination();

      notifyListeners();
    }
  }

  String getScreenTitle() {
    switch (typeToolAndMaterialTransfer) {
      case 1:
        return 'Cấp phát CCDC - Vật tư';
      case 2:
        return 'Thu hồi CCDC - Vật tư';
      case 3:
        return 'Điều chuyển CCDC - Vật tư';
      default:
        return 'Quản lý CCDC - Vật tư';
    }
  }

  int isCheckSigningStatus(ToolAndMaterialTransferDto item) {
    final signatureFlow =
        [
          {"id": item.nguoiTao, "signed": -1, "label": "Người tạo"},
          if (item.nguoiLapPhieuKyNhay == true)
            {
              "id": item.idNguoiKyNhay,
              "signed": item.trangThaiKyNhay == true,
              "label": "Người ký nháy",
            },
          {
            "id": item.idTrinhDuyetCapPhong,
            "signed": item.trinhDuyetCapPhongXacNhan == true,
            "label": "Trình duyệt cấp phòng",
          },
          {
            "id": item.idTrinhDuyetGiamDoc,
            "signed": item.trinhDuyetGiamDocXacNhan == true,
            "label": "Giám đốc",
          },
          if (item.listSignatory != null)
            ...item.listSignatory!.map(
              (e) => {
                "id": e.idNguoiKy,
                "signed": e.trangThai == 1,
                "label": e.tenNguoiKy,
              },
            ),
        ].toList();

    final currentIndex = signatureFlow.indexWhere(
      (s) => s["id"] == userInfo.tenDangNhap,
    );

    if (currentIndex == -1 || currentIndex >= signatureFlow.length) {
      return -1;
    }

    final currentSigner = signatureFlow[currentIndex];

    if (item.nguoiLapPhieuKyNhay == true &&
        item.idNguoiKyNhay == userInfo.tenDangNhap) {
      return item.trangThaiKyNhay == true ? 2 : 4;
    }

    if (item.nguoiTao == userInfo.tenDangNhap &&
        currentSigner["signed"] != -1) {
      return currentSigner["signed"] == true ? 3 : 5;
    }

    // Logic cũ
    if (currentSigner["signed"] == -1) {
      return -1;
    }

    return currentSigner["signed"] == true ? 1 : 0;
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
      notifyListeners();
      return list;
    } else {
      return [];
    }
  }

  Future<List<DetailSubppliesHandoverDto>> getListDetailTransferCCDC(
    String id,
  ) async {
    if (id.isEmpty) return [];
    Map<String, dynamic> result = await ToolAndSuppliesHandoverRepository()
        .getListDetailAssetByTransfer(id);
    log("check result: ${jsonEncode(result)}");
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      final List<dynamic> rawData = result['data'];
      log("check result rawData: ${jsonEncode(rawData)}");
      // The repository already returns parsed DTOs, so we can cast directly
      final list = rawData.cast<DetailSubppliesHandoverDto>();
      _listDetailTransferCCDC = list;
      log(
        "check result _listDetailTransferCCDC: ${jsonEncode(_listDetailTransferCCDC)}",
      );
      notifyListeners();
      return list;
    } else {
      return [];
    }
  }

  void buildThreadNodes(ToolAndMaterialTransferDto item) {
    List<ThreadNode> nodes = [];

    // Tạo danh sách ThreadNode theo từng cụm chiTietTaiSanList
    for (DetailToolAndMaterialTransferDto chiTiet
        in item.detailToolAndMaterialTransfers ?? []) {
      // Thêm ThreadNode cho chiTietTaiSanList
      nodes.add(
        ThreadNode(
          header: '${chiTiet.tenCCDCVatTu} -- SLX: ${chiTiet.soLuongXuat}',
          colorHeader: ColorValue.pink,
          depth: 1,
          child: SGText(
            text: 'Số lượng đã bàn giao: ${chiTiet.soLuongDaBanGiao}',
            size: 13,
            color: ColorValue.cyan,
          ),
        ),
      );

      // Tìm các detailOwnershipUnit tương ứng với chiTietTaiSanList này
      var relatedOwnershipUnits =
          _listDetailTransferCCDC
              .where((e) => e.idChiTietDieuDong == chiTiet.id)
              .toList();

      // Thêm các ThreadNode cho detailOwnershipUnit tương ứng
      if (relatedOwnershipUnits.isNotEmpty) {
        for (var detailHandover in relatedOwnershipUnits) {
          nodes.add(
            ThreadNode(
              header: 'Số phiếu bán giao: ${detailHandover.idBanGiaoCCDCVatTu}',
              depth: 2,
              child: _buildDetailHandover(detailHandover),
            ),
          );
        }
      }
    }

    // Nếu không có chiTietTaiSanList, hiển thị tất cả detailOwnershipUnit
    if (item.detailToolAndMaterialTransfers?.isEmpty ??
        true && _listDetailTransferCCDC.isNotEmpty) {
      for (DetailSubppliesHandoverDto ownershipUnit
          in _listDetailTransferCCDC) {
        nodes.add(
          ThreadNode(
            header: 'Số phiếu bán giao: ${ownershipUnit.idBanGiaoCCDCVatTu}',
            depth: 1,
            child: _buildDetailHandover(ownershipUnit),
          ),
        );
      }
    }

    listSignatoryDetail = nodes;
    notifyListeners();
  }

  Widget _buildDetailHandover(DetailSubppliesHandoverDto item) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 3,
        children: [
          SGText(
            text: 'Mã chi tiết CCDC - Vật tư: ${item.idChiTietCCDCVatTu}',
            size: 13,
            color: ColorValue.primaryBlue,
          ),
          SGText(
            text: 'Số lượng bàn giao: ${item.soLuong}',
            size: 13,
            color: ColorValue.mediumGreen,
          ),
        ],
      ),
    );
  }
}
