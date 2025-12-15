// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_sign_service.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/message/message_service_realtime.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/detai_asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';

import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/repository/auth_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/table_asset_handover_provider.dart';
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
  String? get loadingMessage => _loadingMessage;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  bool get isFindNew => _isFindNew;
  List<AssetHandoverDto>? get dataPage => _dataPage;
  List<DieuDongTaiSanDto>? get dataAssetTransfer => _dataAssetTransfer;
  List<PhongBan>? get dataDepartment => _dataDepartment;
  List<NhanVien>? get dataStaff => _dataStaff;
  List<ChiTietDieuDongTaiSan>? get dataDetailAssetMobilization =>
      _dataDetailAssetMobilization;
  List<DetailAssetHandoverDto>? get dataDetailAssetHandover =>
      _dataDetailAssetHandover;

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

  set dataDetailAssetHandover(List<DetailAssetHandoverDto>? value) {
    _dataDetailAssetHandover = value;
    notifyListeners();
  }

  // Thuộc tính cho tìm kiếm
  String get searchTerm => _searchTerm;
  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  bool _isShowInput = false;
  bool _isShowCollapse = true;
  bool _hasUnsavedChanges = false;
  bool _isFindNew = false;
  String? get error => _error;
  String? get subScreen => _subScreen;
  String _searchTerm = '';
  String? _loadingMessage;

  int typeAssetTransfer = 1;

  late int totalEntries;
  late int totalPages = 0;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;
  TextEditingController? controllerDropdownPage;
  final reloadDataService = PermissionSignService();

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
  List<DetailAssetHandoverDto>? _dataDetailAssetHandover;

  UserInfoDTO? _userInfo;

  // Timer? _autoReloadTimer;

  // Method để refresh data và filter
  void refreshData(BuildContext context) {
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

  void setFilterStatus(BuildContext context, FilterStatus status, bool? value) {
    log('message setFilterStatus: $status, $value');

    // Cập nhật map filter: chỉ cho phép một trạng thái (hoặc all) được chọn
    if (value == false) {
      _filterStatus[status] = false;
    } else {
      for (var key in _filterStatus.keys) {
        _filterStatus[key] = false;
      }
      _filterStatus[status] = true;
    }

    // Map FilterStatus sang mã trạng thái backend và apply cho table provider
    int statusCode;
    switch (status) {
      case FilterStatus.draft:
        statusCode = 0;
        break;
      case FilterStatus.browser:
        statusCode = 1;
        break;
      case FilterStatus.cancel:
        statusCode = 2;
        break;
      case FilterStatus.complete:
        statusCode = 3;
        break;
      case FilterStatus.all:
        statusCode = -1;
        break;
    }

    _onFilterByStatus(context, statusCode);
    notifyListeners();
  }

  void onReloadDataPage(BuildContext context, [bool isRefresh = true]) {
    _isLoading = false;
    final container = ProviderScope.containerOf(context);
    container.read(tableAssetHandoverProvider.notifier).refreshData(isRefresh);
  }

  void _onFilterByStatus(BuildContext context, int status) {
    final container = ProviderScope.containerOf(context);
    container.read(tableAssetHandoverProvider.notifier).filterByStatus(status);
    onReloadDataPage(context);
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

  bool _isOnInitCalled = false;

  Future<void> onInit(BuildContext context) async {
    // Tránh gọi onInit nhiều lần
    if (_isOnInitCalled) {
      log('AssetHandoverProvider: onInit already called, skipping');
      return;
    }
    _isOnInitCalled = true;

    _userInfo = AccountHelper.instance.getUserInfo();
    onDispose();
    onLoadDataAssetTransfer();

    _body = Container();
    onLoadDataDropdown();
    // getListAssetHandover(context);
    // _autoReloadTimer?.cancel();
    // _autoReloadTimer = Timer.periodic(const Duration(seconds: 20), (_) {
    //   onReloadDataAssetHandover();
    //   print("reload data asset handover");
    // });
    // reloadDataService.reloadData(() async {
    //   onReloadDataAssetHandover();
    // });
  }

  Future<void> onLoadDataAssetTransfer() async {
    final result = await AssetTransferRepository().getDataWithPagination(
      0,
      999999,
      -1,
      '',
      3,
      '',
      false,
    );
    final data = (result['data'] as List<dynamic>).cast<DieuDongTaiSanDto>();
    _dataAssetTransfer = List<DieuDongTaiSanDto>.from(data);
    notifyListeners();
  }

  /// Lọc danh sách AssetTransfer dựa trên quyền của người dùng
  /// - Nếu người dùng thuộc phòng ban kho: lấy tất cả phiếu thuộc các phòng ban kho
  /// - Nếu không: lọc theo phòng ban của người dùng
  /// [isEditing] - Nếu false, trả về tất cả (không lọc)
  List<DieuDongTaiSanDto> getFilteredAssetTransfer({bool isEditing = false}) {
    // Luôn log kể cả khi null
    if (_dataAssetTransfer == null) {
      return [];
    }

    final userInfo = AccountHelper.instance.getUserInfo();
    if (userInfo == null) {
      return [];
    }

    final nhanVien = AccountHelper.instance.getNhanVienById(
      userInfo.tenDangNhap,
    );
    if (nhanVien == null) {
      return [];
    }

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
    final filtered =
        _dataAssetTransfer!.where((element) => element.trangThai == 3).where((
          element,
        ) {
          if (isEditing) return true;

          // Nếu nhân viên thuộc kho, lấy tất cả phiếu thuộc các phòng ban kho
          if (isNhanVienKho) {
            final matchKho =
                idPhongBanKhoSet.contains(element.idDonViGiao) ||
                idPhongBanKhoSet.contains(element.idDonViNhan);
            return matchKho;
          }

          // Nếu không phải kho, lọc theo phòng ban của nhân viên
          final idDonViGiao = nhanVien.phongBanId ?? nhanVien.boPhan;
          if (idDonViGiao == null || idDonViGiao.isEmpty) {
            return false;
          }

          final matchDonVi =
              element.idDonViGiao == idDonViGiao ||
              element.idDonViNhan == idDonViGiao;
          return matchDonVi;
        }).toList();

    return filtered;
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

  // onGetDataAsset() async {
  //   if (AccountHelper.instance.getAllAssets().isEmpty) {
  //     final args = await AssetManagementRepository().getListAssetManagement(
  //       'ct001',
  //     );
  //     await AccountHelper.instance.setListAsset(args['data'] ?? []);
  //     _dataAsset = args['data'];
  //   } else {
  //     _dataAsset = AccountHelper.instance.getAllAssets();
  //   }
  // }

  void onReloadDataAssetHandover() async {
    Map<String, dynamic> result =
        await AssetHandoverRepository().getListAssetHandover();
    _data = result['data'];
    _data =
        _data
            ?.where(
              (item) =>
                  item.share == true || item.nguoiTao == userInfo?.tenDangNhap,
            )
            .toList();
    _filteredData = List.from(_data!);
    if (_data != null) {
      // refreshCountSign(_data!);
    }
    notifyListeners();
  }

  // Hàm xử lý cập nhật realtime từ Firebase
  void onRealtimeUpdate(dynamic jsonMsg, BuildContext context) {
    if (kDebugMode) {
      log(
        'message [ref.listen] [onRealtimeUpdate AssetHandoverProvider] jsonMsg: $jsonMsg',
      );
    }
    if (jsonMsg['type_func'] == FunctionType.ASSET_HANDOVER) {
      if (AppUtility.userInList(
        userInfo?.tenDangNhap ?? '',
        jsonMsg['id_need_to_do'] ?? '',
      )) {
        onReloadDataPage(context);
      }
    } else if (jsonMsg['type_func'] == FunctionType.ALL_FUNCTION) {
      if (kDebugMode) {
        log(
          'message [ref.listen] [onRealtimeUpdate AssetHandoverProvider] update received: $jsonMsg',
        );
      }
      onReloadDataPage(context);
    } else if (jsonMsg['type_func'] == FunctionType.ASSET_TRANSFER) {
      onLoadDataAssetTransfer();
    }
  }

  void onDispose() {
    _isShowInput = false;
    _data = null;
    _error = null;
    _filterStatus.clear();
    _filterStatus[FilterStatus.all] = true;
    _isOnInitCalled = false; // Reset flag để có thể gọi lại onInit khi cần
    if (controllerDropdownPage != null) {
      controllerDropdownPage!.dispose();
      controllerDropdownPage = null;
    }
    // _autoReloadTimer?.cancel();
    // _autoReloadTimer = null;
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
    Future.microtask(() {
      context.read<AssetHandoverBloc>().add(GetListAssetHandoverEvent(context));
    });
  }

  Future<void> onChangeDetail(
    BuildContext context,
    AssetHandoverDto? item, {
    bool isFindNew = false,
  }) async {
    // Tải dữ liệu chi tiết bất đồng bộ (không bật global loading overlay)
    if (item != null) {
      unawaited(
        getListDetailAssetMobilization(item.lenhDieuDong ?? '', isFindNew),
      );
    }
    // Ưu tiên hiển thị nhanh giao diện chi tiết, không khóa màn bằng overlay
    _item = item;
    _isFindNew = isFindNew;
    isShowInput = true;
    isShowCollapse = true;
    notifyListeners();

    if (kDebugMode) {
      log('message [AssetHandoverProvider] onChangeDetail: $item');
    }
  }

  void updateItem(AssetHandoverDto updatedItem) {
    if (_data == null) return;
    int index = _data!.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _data![index] = updatedItem;

      notifyListeners();
    } else {}
  }

  getListAssetHandoverSuccess(
    BuildContext context,
    GetListAssetHandoverSuccessState state,
  ) {
    _error = null;

    // _dataDepartment = state.dataDepartment;
    // _dataStaff = state.dataStaff;
    // _dataAssetTransfer = state.dataAssetTransfer;

    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
      _item = null;
    } else {
      _filteredData.clear();
      _data?.clear();
      // refreshCountSign(state.data);
      _data =
          state.data
              .where(
                (item) =>
                    item.share == true ||
                    item.nguoiTao == userInfo?.tenDangNhap,
              )
              .toList();
    }
    notifyListeners();
  }

  // refreshCountSign(List<AssetHandoverDto> data) {
  //   AccountHelper.instance.clearAssetHandover();
  //   AccountHelper.instance.setAssetHandover(data);
  //   AccountHelper.refreshAllCounts();
  //   notifyListeners();
  // }

  // Hàm cảnh báo thay đổi chưa lưu trước khi rời trang đã bị loại bỏ để đơn giản hóa luồng,
  // nếu sau này cần có thể khôi phục lại từ lịch sử git.

  Future<void> getListDetailAssetMobilization(
    String id, [
    bool isFindNewDetail = false,
  ]) async {
    if (id.isEmpty) return;
    Map<String, dynamic> result;
    _isLoading = true;
    _loadingMessage = 'Đang tải dữ liệu chi tiết...';
    notifyListeners();
    if (isFindNewDetail) {
      result = await AssetTransferRepository().getDataPageByBanGiao(
        0,
        999999,
        -1,
        '',
        '',
      );
      final data = (result['data'] as List<dynamic>).cast<DieuDongTaiSanDto>();
      List<DieuDongTaiSanDto> listDieuDongTaiSan = List<DieuDongTaiSanDto>.from(
        data,
      );
      _dataDetailAssetMobilization =
          listDieuDongTaiSan
              .firstWhere((element) => element.id == id)
              .chiTietDieuDongTaiSans;
    } else {
      result = await AssetHandoverRepository().getListDetailAssetMobilization(
        id,
      );
      _dataDetailAssetMobilization = result['data'];
    }
    _dataDetailAssetHandover =
        _dataDetailAssetMobilization
            ?.map(
              (e) => DetailAssetHandoverDto(
                id: e.id,
                idBanGiaoTaiSan: id,
                banGiaoTaiSan: '',
                quyetDinhDieuDongSo: '',
                idTaiSan: e.idTaiSan,
                tenTaiSan: e.tenTaiSan,
                donViTinh: e.donViTinh,
                hienTrang: e.hienTrang,
                soLuong: 0,
              ),
            )
            .toList();
    if (kDebugMode) {
      log(
        'message [AssetHandoverProvider] dataDetailAssetHandover: ${jsonEncode(_dataDetailAssetHandover)}',
      );
    }
    _isLoading = false;
    _loadingMessage = null;
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
    if (_dataStaff != null && _dataStaff!.isNotEmpty) {
      return _dataStaff!.firstWhere(
        (item) => item.id == idNhanVien,
        orElse: () => const NhanVien(),
      );
    } else {
      return const NhanVien();
    }
  }

  onPushMessage(AssetHandoverDto item) {
    String newSignatory =
        item.listSignatory?.map((e) => e.idNguoiKy).join(',') ?? '';
    //Gửi message đến server để cập nhật trạng thái phiếu ký nội sinh
    String idNeedToDo =
        "${item.idDaiDienBenGiao},${item.idDaiDienBenNhan},${item.idGiamDoc},$newSignatory, admin,${item.nguoiTao}";
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      MessageServiceRealtime().pushJsonMessage(
        typeFunc: FunctionType.ASSET_HANDOVER,
        typeAction: ActionType.CREATE,
        idNeedToDo: idNeedToDo,
      );
    });
  }

  String genID() {
    final now = DateTime.now();
    final year = now.year;
    String code = "BGTS";
    String random = UUIDGenerator.generateRandomNumber(6);
    return "$code-$year-$random";
  }
}
