import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/message/message_service_realtime.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/table_asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
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
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  bool get isLoading => _isLoading;
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
  get itemsDVGiao => _itemsDVGiao;
  get itemsDDNhanVien => _itemsDDNhanVien;

  get loadingMessage => _loadingMessage;
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
  List<DropdownMenuItem<PhongBan>> _itemsDVGiao = [];
  // List status
  // late List<ListStatus> _listStatus;

  String? _error;
  String? _subScreen;
  String mainScreen = '';
  String _loadingMessage = 'Đang tải dữ liệu...';

  bool _isShowInput = false;
  bool _isShowCollapse = true;
  bool _isLoading = false;
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

  // Timer? _autoReloadTimer;

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
      case FilterStatus.approve:
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
    _dataAsset = AccountHelper.instance.getAllAssets();
    // Khởi tạo các biến pagination
    totalEntries = 0;
    totalPages = 1;
    startIndex = 0;
    endIndex = 0;
    currentPage = 1;
    controllerDropdownPage = TextEditingController(text: '10');
    getDataDropdown();
    if (_dataAsset == null || _dataAsset!.isEmpty) {
      onGetDataAsset();
    }

    // getDataAll(context);

    // Start auto reload every 20 seconds
    // _autoReloadTimer?.cancel();
    // _autoReloadTimer = Timer.periodic(const Duration(seconds: 20), (_) {
    //   // onReloadDataAssetTransfer();
    //   onReloadDataPage(context, false);
    // });
  }

  // Hàm xử lý cập nhật realtime từ Firebase
  void onRealtimeUpdate(dynamic jsonMsg, BuildContext context) {
    if (jsonMsg['type_func'] == FunctionType.ASSET_TRANSFER) {
      log("Realtime update received: $jsonMsg");
      if (AppUtility.userInList(
        userInfo?.tenDangNhap ?? '',
        jsonMsg['id_need_to_do'] ?? '',
      )) {
        print("User involved, reloading data...");
        onReloadDataPage(context, false);
      }
    }
  }

  onGetDataAsset() async {
    if (AccountHelper.instance.getAllAssets().isEmpty) {
      final args = await AssetManagementRepository().getListAssetManagement(
        'ct001',
      );
      log('message result _dataAsset args: ${args['data'].length}');
      AccountHelper.instance.setListAsset(args['data'] ?? []);
      _dataAsset = args['data'];
      log('message result _dataAsset: ${_dataAsset?.length}');
    } else {
      _dataAsset = AccountHelper.instance.getAllAssets();
    }
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
    // _autoReloadTimer?.cancel();
    // _autoReloadTimer = null;
  }

  onReloadDataPage(BuildContext context, [bool isRefresh = true]) {
    final container = ProviderScope.containerOf(context);
    container
        .read(tableAssetTransferProvider.notifier)
        .refreshData(typeDieuDongTaiSan, isRefresh);
  }

  onFillterByStatus(BuildContext context, int status) {
    final container = ProviderScope.containerOf(context);
    container.read(tableAssetTransferProvider.notifier).fillterByStatus(status);
    onReloadDataPage(context);
  }

  void onCloseDetail(BuildContext context) {
    _isShowCollapse = true;
    _isShowInput = false;
    notifyListeners();
  }

  void onChangeDetailDieuDongTaiSan(DieuDongTaiSanDto? item) async {
    // Kiểm tra nếu chưa có dữ liệu tài sản trong cache thì tải mới
    // if (AccountHelper.instance.getAllAssets().isEmpty) {
    //   _isLoading = true;
    //   _loadingMessage = 'Đang tải dữ liệu...';
    //   notifyListeners();

    //   try {
    //     final args = await AssetManagementRepository()
    //         .getListAssetManagement('ct001');
    //     AccountHelper.instance.setListAsset(args['data'] ?? []);
    //   } catch (e) {
    //     SGLog.debug("AssetTransferProvider", "Lỗi tải dữ liệu tài sản: $e");
    //   }
    // }
    onGetDataAsset();
    // // Cập nhật dữ liệu từ cache
    // _dataAsset = AccountHelper.instance.getAllAssets();

    _itemPreview = null;
    _item = item;

    // Cập nhật biến private trực tiếp để tránh notifyListeners nhiều lần
    _isShowInput = true;
    _isShowCollapse = true;
    _isLoading = false;
    _loadingMessage = '';

    notifyListeners();
  }

  void updateItem(DieuDongTaiSanDto updatedItem) {
    if (_data == null) return;

    int index = _data!.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _data![index] = updatedItem;
      // _updatePagination();
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
    // _updatePagination();
    // _applyFilters();
    notifyListeners();
  }

  // refreshDataSuccess(List<DieuDongTaiSanDto> data) {
  //   AccountHelper.instance.clearAssetTransfer();
  //   AccountHelper.instance.setAssetTransfer(data);
  //   AccountHelper.refreshAllCounts();
  //   notifyListeners();
  // }

  getLisTaiSanSuccess(BuildContext context, GetListAssetSuccessState state) {
    _error = null;
    if (state.data.isEmpty) {
      _dataAsset = [];
    } else {
      _dataAsset = state.data;
    }
    notifyListeners();
  }

  getDataDropdown() {
    _dataPhongBan = AccountHelper.instance.getDepartment();
    _itemsDDPhongBan =
        _dataPhongBan
            ?.where((element) => element.isKho != true)
            .map(
              (element) => DropdownMenuItem<PhongBan>(
                value: element,
                child: Text(element.tenPhongBan ?? ''),
              ),
            )
            .toList() ??
        [];

    if (typeDieuDongTaiSan == 1) {
      List<PhongBan> dataDVGiao =
          _dataPhongBan?.where((element) => element.isKho == true).toList() ??
          [];
      log(
        'message dataDVGiao: ${dataDVGiao.length} -- ${_dataPhongBan?.length}',
      );
      _itemsDVGiao =
          dataDVGiao
              .map(
                (element) => DropdownMenuItem<PhongBan>(
                  value: element,
                  child: Text(element.tenPhongBan ?? ''),
                ),
              )
              .toList();
    } else {
      List<PhongBan> dataDV =
          _dataPhongBan?.where((element) => element.isKho == false).toList() ??
          [];

      _itemsDVGiao =
          dataDV
              .map(
                (element) => DropdownMenuItem<PhongBan>(
                  value: element,
                  child: Text(element.tenPhongBan ?? ''),
                ),
              )
              .toList();
    }

    _dataNhanVien = AccountHelper.instance.getNhanVien();
    _itemsDDNhanVien = [
      for (var element in _dataNhanVien!)
        DropdownMenuItem<NhanVien>(
          value: element,
          child: Text(element.hoTen ?? ''),
        ),
    ];
    notifyListeners();
  }

  void createDieuDongSuccess(
    BuildContext context,
    CreateDieuDongSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Tạo mới thành công!');
    // getDataAll(context);
    // AccountHelper.refreshAllCounts();
    onReloadDataPage(context);
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
    // getDataAll(context);
    onReloadDataPage(context);
    notifyListeners();
  }

  void updateSignatureSuccess(
    BuildContext context,
    UpdateSigningStatusSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Cập nhập trạng thái thành công!');
    // getDataAll(context);
    onReloadDataPage(context);
    notifyListeners();
  }

  void deleteDieuDongSuccess(
    BuildContext context,
    DeleteDieuDongSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Xóa thành công!');
    // getDataAll(context);
    onReloadDataPage(context);
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
      // _updatePagination();
      notifyListeners();
    }
  }

  String getScreenTitle() {
    switch (typeDieuDongTaiSan) {
      case 1:
        return 'Cấp phát tài sản';
      case 2:
        return 'Điều chuyển tài sản';
      case 3:
        return 'Thu hồi tài sản';
      default:
        return 'Quản lý tài sản';
    }
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
    // getDataAll(context);
    onReloadDataPage(context);
  }

  Future<void> onReloadDataAssetByCurrentUnit(String idDonViHienthoi) async {
    _isLoading = true;
    _loadingMessage = 'Đang tải dữ liệu tài sản...';
    log('onReloadDataAssetByCurrentUnit: $idDonViHienthoi');
    Map<String, dynamic> result;
    if (typeDieuDongTaiSan == 1) {
      result = await AssetTransferRepository().getAssetByUnit(idDonViHienthoi);
    } else {
      result = await AssetTransferRepository().getAssetByCurrentUnit(
        idDonViHienthoi,
      );
    }
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      _dataAsset = result['data'];
      _isLoading = false;
      _loadingMessage = 'Đang tải dữ liệu...';
    } else {
      SGLog.debug(
        "AssetTransferProvider",
        "Error at onReloadDataAssetByCurrentUnit: ${result['message']}",
      );
      _isLoading = false;
      _loadingMessage = 'Đang tải dữ liệu...';
    }
    notifyListeners();
  }

  onPushMessage(DieuDongTaiSanDto item) {
    String newSignatory =
        item.listSignatory?.map((e) => e.idNguoiKy).join(',') ?? '';
    String idNeedToDo =
        "${item.idDonViGiao},${item.idDonViNhan},${item.idNguoiKyNhay},${item.idTrinhDuyetGiamDoc},$newSignatory, admin";
    MessageServiceRealtime().pushJsonMessage(
      typeFunc: FunctionType.ASSET_TRANSFER,
      typeAction: ActionType.CREATE,
      idNeedToDo: idNeedToDo,
    );
  }
}
