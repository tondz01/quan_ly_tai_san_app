import 'dart:developer';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/chi_tiet_dieu_dong_request.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/lenh_dieu_dong_request.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import '../bloc/dieu_dong_tai_san_state.dart';
import '../model/dieu_dong_tai_san_dto.dart';

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

class DieuDongTaiSanProvider with ChangeNotifier {
  bool get isLoading => _data == null || _dataAsset == null;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  get userInfo => _userInfo;
  List<DieuDongTaiSanDto>? get dataPage => _dataPage;
  DieuDongTaiSanDto? get item => _item;
  get itemPreview => _itemPreview;
  get data => _data;
  get filteredData => _filteredData;
  get dataAsset => _dataAsset;
  get dataPhongBan => _dataPhongBan;
  get dataNhanVien => _dataNhanVien;

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

  int typeDieuDongTaiSan = 1;

  int totalEntries = 0;
  int totalPages = 1;
  int startIndex = 0;
  int endIndex = 0;
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
  List<DieuDongTaiSanDto>? _data;
  List<AssetManagementDto>? _dataAsset;
  List<PhongBan>? _dataPhongBan;
  List<NhanVien>? _dataNhanVien;
  List<DieuDongTaiSanDto>? _dataPage;
  List<DieuDongTaiSanDto> _filteredData = [];
  DieuDongTaiSanDto? _item;
  DieuDongTaiSanDto? _itemPreview;
  UserInfoDTO? _userInfo;

  String idCongTy = 'CT001';

  Timer? _autoReloadTimer;

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

  set dataPage(List<DieuDongTaiSanDto>? value) {
    _dataPage = value;
    notifyListeners();
  }

  void changeIsShowPreview(DieuDongTaiSanDto? itemPreview) {
    _itemPreview = itemPreview;
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

    List<DieuDongTaiSanDto> statusFiltered;
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
                (item.chiTietDieuDongTaiSans?.any(
                      (detail) =>
                          detail.tenTaiSan.toLowerCase().contains(searchLower),
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

  void onInit(BuildContext context, int typeDieuDongTaiSan) {
    // Không gọi onDispose() ở đây để tránh mất dữ liệu
    // onDispose();

    this.typeDieuDongTaiSan = typeDieuDongTaiSan;
    _userInfo = AccountHelper.instance.getUserInfo();

    // Khởi tạo các biến pagination
    totalEntries = 0;
    totalPages = 1;
    startIndex = 0;
    endIndex = 0;
    currentPage = 1;
    controllerDropdownPage = TextEditingController(text: '10');

    getDataAll(context);

    // Start auto reload every 20 seconds
    _autoReloadTimer?.cancel();
    _autoReloadTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      onReloadDataAssetTransfer();
      print("reload data asset transfer");
    });
  }

  void onDispose() {
    _data = null;
    _error = null;
    _isShowInput = false;
    _item = null;
    _isShowCollapse = true;
    _filterStatus.clear();
    _filterStatus[FilterStatus.all] = true;

    // Reset các biến pagination
    totalEntries = 0;
    totalPages = 1;
    startIndex = 0;
    endIndex = 0;
    currentPage = 1;

    if (controllerDropdownPage != null) {
      controllerDropdownPage!.dispose();
      controllerDropdownPage = null;
    }

    // Stop auto reload timer
    _autoReloadTimer?.cancel();
    _autoReloadTimer = null;
  }

  void getDataAll(BuildContext context) {
    try {
      onCloseDetail(context);
      final bloc = context.read<DieuDongTaiSanBloc>();
      bloc.add(
        GetListDieuDongTaiSanEvent(
          context,
          typeDieuDongTaiSan,
          _userInfo?.idCongTy ?? '',
        ),
      );
      bloc.add(GetListAssetEvent(context, _userInfo?.idCongTy ?? ''));
      bloc.add(GetDataDropdownEvent(context, _userInfo?.idCongTy ?? ''));
    } catch (e) {
      log('Error adding AssetManagement events: $e');
    }
  }

  void onReloadDataAssetTransfer() async {
    Map<String, dynamic> dieuDongTaiSans = await AssetTransferRepository()
        .getListDieuDongTaiSan(type: typeDieuDongTaiSan);
    _data = dieuDongTaiSans['data'];
    _data =
        _data
            ?.where((element) => element.loai == typeDieuDongTaiSan)
            .where((item) {
              return item.share == true ||
                  item.nguoiTao == userInfo?.tenDangNhap;
            })
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
    log('message test: onReloadDataAssetTransfer');
    _applyFilters();
    notifyListeners();
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

    // Đảm bảo startIndex và endIndex không vượt quá giới hạn
    if (startIndex < 0) startIndex = 0;
    if (endIndex > totalEntries) endIndex = totalEntries;

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

  void onChangeDetailDieuDongTaiSan(DieuDongTaiSanDto? item) {
    // onChangeScreen(item: item, isMainScreen: false, isEdit: true);
    _itemPreview = null;
    _item = item;
    isShowInput = true;
    isShowCollapse = true;
    notifyListeners();
  }

  void onRowsPerPageChanged(int? value) {
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
    notifyListeners();
  }

  void updateItem(DieuDongTaiSanDto updatedItem) {
    if (_data == null) return;

    int index = _data!.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _data![index] = updatedItem;
      _updatePagination();
      notifyListeners();
    }
  }

  getListDieuDongTaiSanSuccess(
    BuildContext context,
    GetListDieuDongTaiSanSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
      _dataPage = [];
    } else {
      _filteredData.clear();
      _data?.clear();
      AccountHelper.instance.clearAssetTransfer();
      AccountHelper.instance.setAssetTransfer(state.data);
      AccountHelper.refreshAllCounts();
      _data =
          state.data
              .where((element) => element.loai == typeDieuDongTaiSan)
              .where((item) {
                return item.share == true ||
                    item.nguoiTao == userInfo?.tenDangNhap;
              })
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
    AppUtility.showSnackBar(context, 'Tạo mới thành công!');
    getDataAll(context);
    AccountHelper.refreshAllCounts();
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

  void updateSignatureSuccess(
    BuildContext context,
    UpdateSigningStatusSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Cập nhập trạng thái thành công!');
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

  void putPostDeleteFailed(
    BuildContext context,
    PutPostDeleteFailedState state,
  ) {
    AppUtility.showSnackBar(context, state.message);
    notifyListeners();
  }

  Future<void> saveAssetTransfer(
    BuildContext context,
    LenhDieuDongRequest request,
    List<ChiTietDieuDongRequest> requestDetail,
    List<SignatoryDto> listSignatory,
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
    request = request.copyWith(
      duongDanFile: result['filePath'] ?? '',
      tenFile: result['fileName'] ?? '',
    );

    SGLog.debug(
      "AssetTransferProvider",
      "result: $result ${result['fileName'] ?? ''} ${result['filePath'] ?? ''}",
    );
    if (context.mounted) {
      final bloc = context.read<DieuDongTaiSanBloc>();
      bloc.add(
        CreateDieuDongEvent(context, request, requestDetail, listSignatory),
      );
    }

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
              ? await AssetTransferRepository().uploadFileBytes(
                fileName,
                fileBytes,
              )
              : await AssetTransferRepository().uploadFile(filePath);
      final statusCode = result['status_code'] as int? ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        // if (context.mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Tệp "$fileName" đã được tải lên thành công'),
        //       backgroundColor: const Color(0xFF21A366),
        //     ),
        //   );
        // }
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

  Future<void> updateAssetTransfer(DieuDongTaiSanDto updatedItem) async {
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
    switch (typeDieuDongTaiSan) {
      case 1:
        return 'Cấp phát tài sản';
      case 2:
        return 'Thu hồi tài sản';
      case 3:
        return 'Điều chuyển tài sản';
      default:
        return 'Quản lý tài sản';
    }
  }

  int isCheckSigningStatus(DieuDongTaiSanDto item) {
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

  void refreshData(BuildContext context, int type) {
    typeDieuDongTaiSan = type;
    _data = null;
    _dataPage = null;
    _item = null;
    _dataAsset = null;
    _dataPhongBan = null;
    _dataNhanVien = null;
    notifyListeners();
    _userInfo = AccountHelper.instance.getUserInfo();
    onCloseDetail(context);
    controllerDropdownPage = TextEditingController(text: '10');
    getDataAll(context);
  }
}
