import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/enum/loai_kho_enum.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/message/message_service_realtime.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_event.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/provider/table_tool_and_material_transfer_provider.dart';
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
  bool get isLoading => _isLoading;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  int get type => _type;
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
  get itemsDVGiao => _itemsDVGiao;
  get itemsDVNhan => _itemsDVNhan;
  get itemsDDNhanVien => _itemsDDNhanVien;

  String get messageLoading => _messageLoading;

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

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? get error => _error;
  String? get subScreen => _subScreen;

  // Nội dung tìm kiếm
  String _searchTerm = '';

  int _type = 1;

  set type(int value) {
    _type = value;
    notifyListeners();
  }

  late int totalEntries;
  late int totalPages;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;

  List<DropdownMenuItem<PhongBan>> _itemsDDPhongBan = [];
  List<DropdownMenuItem<PhongBan>> _itemsDVGiao = [];
  List<DropdownMenuItem<PhongBan>> _itemsDVNhan = [];
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

  // Timer? _autoReloadTimer;

  bool _isLoading = false;
  String _messageLoading = '';
  int _detailRequestId = 0;

  set messageLoading(String value) {
    _messageLoading = value;
    notifyListeners();
  }

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

  // set isLoading(bool value) {
  //   isLoading = value;
  //   notifyListeners();
  // }

  set dataPage(List<ToolAndMaterialTransferDto>? value) {
    _dataPage = value;
    notifyListeners();
  }

  void setFilterStatus(BuildContext context, FilterStatus status, bool? value) {
    if (value == false) {
      _filterStatus[status] = false;
    } else {
      // Nếu đang chọn (value == true), bỏ chọn tất cả các checkbox khác trước
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

  void onInit(BuildContext context, int type) {
    this.type = type;
    _initData(context);
    // _autoReloadTimer?.cancel();
    _dataAsset = AccountHelper.instance.getAllCCDC();
  }

  void onRealtimeUpdate(dynamic jsonMsg, BuildContext context) {
    if (jsonMsg['type_func'] == FunctionType.TOOL_AND_MATERIAL_TRANSFER) {
      if (AppUtility.userInList(
        userInfo?.tenDangNhap ?? '',
        jsonMsg['id_need_to_do'] ?? '',
      )) {
        onReloadData(context);
      }
    } else if (jsonMsg['type_func'] == FunctionType.ALL_FUNCTION) {
      onReloadData(context);
    }
  }

  void refreshData(BuildContext context, int type) {
    this.type = type;
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
    getDataDropdown();

    onReloadData(context);
    // getDataAll(context);
  }

  void onReloadData(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    container
        .read(tableToolAndMaterialTransferProvider.notifier)
        .refreshData(type, -1, false);
  }

  void onFillterByStatus(BuildContext context, int status) {
    final container = ProviderScope.containerOf(context);
    container
        .read(tableToolAndMaterialTransferProvider.notifier)
        .fillterByStatus(status);
    onReloadData(context);
    notifyListeners();
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

  }

  // void getDataAll(BuildContext context) {
  //   try {
  //     final bloc = context.read<ToolAndMaterialTransferBloc>();
  //     // bloc.add(
  //     //   GetListToolAndMaterialTransferEvent(
  //     //     context,
  //     //     typeToolAndMaterialTransfer,
  //     //     _userInfo?.idCongTy ?? '',
  //     //   ),
  //     // );
  //     // // bloc.add(GetListAssetEvent(context, _userInfo?.idCongTy ?? ''));
  //     // bloc.add(GetDataDropdownEvent(context, _userInfo?.idCongTy ?? ''));
  //   } catch (e) {
  //     log('Error adding AssetManagement events: $e');
  //   }
  // }

  void onCloseDetail(BuildContext context) {
    _isShowCollapse = true;
    _isShowInput = false;
    Future.delayed(const Duration(milliseconds: 300), () {
      onSetLoading(false);
    });
    notifyListeners();
  }

  Future<void> onChangeDetailToolAndMaterialTransfer(
    ToolAndMaterialTransferDto? item,
  ) async {
    final currentRequestId = ++_detailRequestId;
    _item = item;
    _messageLoading = 'Đang tải dữ liệu...';
    _isLoading = true;
    isShowInput = true;
    isShowCollapse = true;
    notifyListeners();

    try {
      if (item != null && item.id != null) {
        final details = await getListDetailTransferCCDC(item.id!);
        if (currentRequestId != _detailRequestId) return;
        _listDetailTransferCCDC = details;
        buildThreadNodes(item);
        notifyListeners();
      }
    } catch (e) {
      SGLog.debug('[onChangeDetail]','Error in onChangeDetailToolAndMaterialTransfer: $e');
      // Có thể hiển thị thông báo lỗi nếu cần
    } finally {
      if (currentRequestId == _detailRequestId) {
        onSetLoading(false);
      }
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
      // refreshCountSign(state.data);
      _data =
          state.data
              .where((element) => element.loai == type)
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
    notifyListeners();
  }

  // refreshCountSign(List<ToolAndMaterialTransferDto> data) {
  //   AccountHelper.instance.clearToolAndMaterialTransfer();
  //   AccountHelper.instance.setToolAndMaterialTransfer(data);
  //   AccountHelper.refreshAllCounts();
  //   notifyListeners();
  // }

  getDataDropdown() {
    _dataPhongBan = AccountHelper.instance.getDepartment();
    // Tạo dropdown item một lần để tái sử dụng
    DropdownMenuItem<PhongBan> toDropdownItem(PhongBan e) => 
        DropdownMenuItem<PhongBan>(value: e, child: Text(e.tenPhongBan ?? ''));

    // Phòng ban (không phải kho)
    _itemsDDPhongBan = _dataPhongBan
        ?.where((e) => e.isKho != true)
        .map(toDropdownItem)
        .toList() ?? [];

    // Đơn vị giao: Kho cấp phát (type=1) hoặc Phòng ban thường (type!=1)
    final isCapPhat = type == 1;
    // Đơn vị nhận: Kho thu hồi (type=3) hoặc Phòng ban thường (type!=3)
    final isThuHoi = type == 3;

    _itemsDVGiao = _dataPhongBan
        ?.where((e) => isCapPhat 
            ? (e.isKho == true && LoaiKho.fromValue(e.loaiKho).isKhoCapPhat)
            : e.isKho == false)
        .map(toDropdownItem)
        .toList() ?? [];

    _itemsDVNhan = _dataPhongBan
    ?.where((e) => isThuHoi
        ? (e.isKho == true && LoaiKho.fromValue(e.loaiKho).isKhoThuHoi)
        : e.isKho == false)
    .map(toDropdownItem)
    .toList() ?? [];
    // Nhân viên
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

  getLisTaiSanSuccess(BuildContext context, GetListAssetSuccessState state) {
    _error = null;
    if (state.data.isEmpty) {
      _dataAsset = [];
    } else {
      _dataAsset = state.data;
    }
    notifyListeners();
  }

  void createDieuDongSuccess(
    BuildContext context,
    CreateDieuDongSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Thêm mới thành công!');
    // getDataAll(context);
    onReloadData(context);
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
    onReloadData(context);
    notifyListeners();
  }

  void deleteDieuDongSuccess(
    BuildContext context,
    DeleteDieuDongSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Xóa thành công!');
    // getDataAll(context);
    onReloadData(context);
    notifyListeners();
  }

  void updateSigningTAMTStatusSuccess(
    BuildContext context,
    UpdateSigningTAMTStatusSuccessState state,
  ) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Cập nhập trạng thái thành công!');
    // getDataAll(context);
    onReloadData(context);
    notifyListeners();
  }

  void putPostDeleteFailed(
    BuildContext context,
    PutPostDeleteFailedState state,
  ) {
    AppUtility.showSnackBar(context, state.message);
    onReloadData(context);
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
    // Lưu bloc reference trước khi upload để tránh lỗi khi context bị deactivated
    ToolAndMaterialTransferBloc? bloc;
    if (context.mounted) {
      bloc = context.read<ToolAndMaterialTransferBloc>();
      log('[saveAssetTransfer] Bloc reference saved');
    } else {
      log('[saveAssetTransfer] Context not mounted, cannot get bloc');
      return;
    }

    // Only upload if we have a new file to upload
    bool hasNewFile =
        (kIsWeb && fileName.isNotEmpty && fileBytes.isNotEmpty) ||
        (!kIsWeb && filePath.isNotEmpty);

    if (hasNewFile) {
      Map<String, dynamic>? result = await uploadWordDocument(
        context,
        fileName,
        filePath,
        fileBytes,
      );

      if (result == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi tải lên tài liệu. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        notifyListeners();
        return;
      }

      request.duongDanFile = result['filePath'] ?? '';
      request.tenFile = result['fileName'] ?? '';
    } else {
      // Use existing file info if available
      if (fileName.isNotEmpty) {
        request.tenFile = fileName;
      }
      if (filePath.isNotEmpty) {
        request.duongDanFile = filePath;
      }
    }

    SGLog.debug(
      "AssetTransferProvider saveAssetTransfer",
      "Final request - fileName: ${request.tenFile}, filePath: ${request.duongDanFile}",
    );

    // Sử dụng bloc đã lưu trước khi upload
    // Context có thể đã bị deactivated sau upload, nhưng bloc vẫn hoạt động
    // Event vẫn cần context (mặc dù bloc không dùng), nên truyền context cũ
    bloc.add(
      CreateToolAndMaterialTransferEvent(
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
      if (fileName.isEmpty || (filePath.isEmpty && fileBytes.isEmpty)) {
        log(
          '[uploadWordDocument] Web: fileName or filePath/fileBytes is empty, returning null',
        );
        return null;
      }
    } else {
      if (filePath.isEmpty && fileBytes.isEmpty) {
        log(
          '[uploadWordDocument] Mobile: filePath and fileBytes are empty, returning null',
        );
        return null;
      }
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
          //     backgroundColor: const Color(0xFF21A366),
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
      notifyListeners();
    }
  }

  String getScreenTitle() {
    switch (type) {
      case 1:
        return 'Cấp phát CCDC - Vật tư';
      case 2:
        return 'Điều chuyển CCDC - Vật tư';
      case 3:
        return 'Thu hồi CCDC - Vật tư';
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
      log('message [getListOwnership] list: ${jsonEncode(_listOwnershipUnit)}');
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
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      final List<dynamic> rawData = result['data'];
      // The repository already returns parsed DTOs, so we can cast directly
      return rawData.cast<DetailSubppliesHandoverDto>();
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

  onPushMessage(ToolAndMaterialTransferDto item) {
    String newSignatory =
        item.listSignatory?.map((e) => e.idNguoiKy).join(',') ?? '';
    String idNeedToDo =
        "${item.idDonViGiao},${item.idDonViNhan},${item.idNguoiKyNhay},${item.idTrinhDuyetGiamDoc},$newSignatory, admin,${item.nguoiTao}";
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      MessageServiceRealtime().pushJsonMessage(
        typeFunc: FunctionType.TOOL_AND_MATERIAL_TRANSFER,
        typeAction: ActionType.CREATE,
        idNeedToDo: idNeedToDo,
      );
    });
  }

  // Future<void> onReloadDataCcdc(String idDonViHienthoi) async {
  //   _isLoading = true;
  //   _loadingMessage = 'Đang tải dữ liệu tài sản...';
  //   Map<String, dynamic> result;
  //   if (type == 1) {
  //     result = await ToolAndMaterialTransferRepository().getCcdcHasHandover(idDonViHienthoi);
  //   } else {
  //     result = await ToolAndMaterialTransferRepository().getCcdcNotYetHandover(idDonViHienthoi);
  //   }
  //   if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
  //     _dataCcdc = result['data'];
  //     _isLoading = false;
  //     _loadingMessage = 'Đang tải dữ liệu...';
  //   } else {
  //     SGLog.debug(
  //       "AssetTransferProvider",
  //       "Error at onReloadDataAssetByCurrentUnit: ${result['message']}",
  //     );
  //     _isLoading = false;
  //     _loadingMessage = 'Đang tải dữ liệu...';
  //   }
  //   notifyListeners();
  // }

  onSetLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String genID() {
    final now = DateTime.now();
    final year = now.year;
    String code =
        type == 1
            ? "CPDC"
            : type == 2
            ? "DDDC"
            : "THDC";
    String random = UUIDGenerator.generateRandomNumber(6);
    return "$code-$year-$random";
  }
}
