import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_reponsitory.dart';
import 'package:quan_ly_tai_san_app/core/enum/role_code.dart';
import 'package:quan_ly_tai_san_app/core/utils/model_country.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_depreciation_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

enum ShowBody { taiSan, khauHao }

class AssetManagementProvider with ChangeNotifier {
  get isCanCreate => _isCanCreate;
  get isCanUpdate => _isCanUpdate;
  get isCanDelete => _isCanDelete;
  get isNew => _isNew;

  String get searchTerm => _searchTerm;

  get error => _error;
  bool get isLoading => _isLoading;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  bool get isShowInputKhauHao => _isShowInputKhauHao;
  bool get isShowCollapseKhauHao => _isShowCollapseKhauHao;
  get subScreen => _subScreen;
  get body => _body;

  get data => _data;
  get dataChildAssets => _dataChildAssets;
  get dataDetail => _dataDetail;
  get dataDepreciationDetail => _dataDepreciationDetail;
  get filteredData => _filteredData ?? _data;

  get userInfo => _userInfo;

  get dataGroup => _dataGroup;
  get dataProject => _dataProject;
  get dataCapitalSource => _dataCapitalSource;
  get dataDepartment => _dataDepartment;
  get dataKhauHao => _dataKhauHao;
  get itemsLyDoTang => _itemsLyDoTang;
  get itemsHienTrang => _itemsHienTrang;
  get initialSelectedNguonKinhPhi => _initialSelectedNguonKinhPhi;

  get itemsAssetGroup => _itemsAssetGroup;
  get itemsDuAn => _itemsDuAn;
  get itemsNguonKinhPhi => _itemsNguonKinhPhi;
  get itemsPhongBan => _itemsPhongBan;
  get itemsCountry => _itemsCountry;

  get dataPage => _dataPage;

  set isShowInput(bool value) {
    _isShowInput = value;
    notifyListeners();
  }

  set isShowCollapse(bool value) {
    _isShowCollapse = value;
    notifyListeners();
  }

  set isShowInputKhauHao(bool value) {
    _isShowInputKhauHao = value;
    notifyListeners();
  }

  set isShowCollapseKhauHao(bool value) {
    _isShowCollapseKhauHao = value;
    notifyListeners();
  }

  ShowBody typeBody = ShowBody.taiSan;

  Widget? _body;

  bool _isLoading = true;
  bool _isShowInput = false;
  bool _isShowCollapse = false;
  bool _isShowInputKhauHao = false;
  bool _isShowCollapseKhauHao = false;

  bool _isCanCreate = false;
  bool _isCanUpdate = false;
  bool _isCanDelete = false;
  bool _isNew = false;

  String? _error;
  String _searchTerm = '';

  String? _subScreen;

  UserInfoDTO? _userInfo;

  AssetManagementDto? _dataDetail;
  AssetDepreciationDto? _dataDepreciationDetail;

  List<AssetManagementDto>? _data;
  List<AssetManagementDto>? _dataPage;

  List<AssetGroupDto>? _dataGroup;
  List<DuAn>? _dataProject;
  List<NguonKinhPhi>? _dataCapitalSource;
  List<PhongBan>? _dataDepartment;
  List<AssetManagementDto>? _filteredData;
  List<ChildAssetDto>? _dataChildAssets;
  List<AssetDepreciationDto>? _dataKhauHao;
  List<NguonKinhPhi>? _initialSelectedNguonKinhPhi;
  //List dropdown
  List<DropdownMenuItem<AssetGroupDto>>? _itemsAssetGroup;
  List<DropdownMenuItem<DuAn>>? _itemsDuAn;
  List<DropdownMenuItem<NguonKinhPhi>>? _itemsNguonKinhPhi;
  List<DropdownMenuItem<PhongBan>>? _itemsPhongBan;

  List<Country> listCountry = countries;
  List<DropdownMenuItem<Country>> _itemsCountry = [];

  //Item dropdown lý do tăng
  List<LyDoTang> listLyDoTang = AppUtility.listLyDoTang;
  List<DropdownMenuItem<LyDoTang>> _itemsLyDoTang = [];

  //Item dropdown hien trang
  List<HienTrang> listHienTrang = AppUtility.listHienTrang;
  List<DropdownMenuItem<HienTrang>> _itemsHienTrang = [];

  late int totalEntries;
  late int totalPages = 1;
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

  set searchTerm(String value) {
    _searchTerm = value;
    _applyFilters(); // Áp dụng filter khi thay đổi nội dung tìm kiếm
    notifyListeners();
  }

  //Tài sản con
  HienTrang getHienTrang(int id) {
    return listHienTrang.firstWhere(
      (element) => element.id == id,
      orElse:
          () =>
              listHienTrang.isNotEmpty
                  ? listHienTrang.first
                  : HienTrang(id: 0, name: ''),
    );
  }

  LyDoTang getLyDoTang(int id) {
    return listLyDoTang.firstWhere(
      (element) => element.id == id,
      orElse:
          () =>
              listLyDoTang.isNotEmpty
                  ? listLyDoTang.first
                  : LyDoTang(id: 0, name: ''),
    );
  }

  Country? findCountryByName(String name) {
    return countries.firstWhereOrNull(
      (country) => country.name.toLowerCase() == name.toLowerCase(),
    );
  }

  // Thêm method để lấy Country từ ID
  Country? findCountryById(int id) {
    return countries.firstWhereOrNull((country) => country.id == id);
  }

  List<Map<String, bool>?> checkBoxAssetGroup = [];
  void _applyFilters() {
    if (_data == null) return;
    // Lọc tiếp theo nội dung tìm kiếm
    if (_searchTerm.isNotEmpty) {
      String searchLower = _searchTerm.toLowerCase();
      _filteredData =
          _data!.where((item) {
            String departmentName =
                AccountHelper.instance
                    .getDepartmentById(item.id ?? '')
                    ?.tenPhongBan
                    ?.toLowerCase() ??
                '';
            return (item.id?.toLowerCase().contains(searchLower) ?? false) ||
                (item.tenTaiSan?.toLowerCase().contains(searchLower) ??
                    false) ||
                (item.tenNhom?.toLowerCase().contains(searchLower) ?? false) ||
                (item.nguoiTao?.toLowerCase().contains(searchLower) ?? false) ||
                //đơn vị tính
                (AccountHelper.instance
                        .getUnitById(item.donViTinh ?? '')
                        ?.tenDonVi
                        ?.toLowerCase()
                        .contains(searchLower) ??
                    false) ||
                //phòng ban
                (departmentName.contains(searchLower));
          }).toList();
    } else {
      _filteredData = _data!;
    }

    // Sau khi lọc, cập nhật lại phân trang
    _updatePagination();
  }

  void _updatePagination() {
    totalEntries = _filteredData?.length ?? 0;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    _dataPage =
        _filteredData?.isNotEmpty ?? false
            ? _filteredData!.sublist(
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

  onInit(BuildContext context) {
    reset();
    _userInfo = AccountHelper.instance.getUserInfo();
    checkPermission();
    controllerDropdownPage = TextEditingController(text: '10');
    onLoadItemDropdown();
    onCloseDetail(context);
    isShowInputKhauHao = false;
    isShowCollapseKhauHao = false;
    getDataAll(context);
    notifyListeners();
  }

  void onCloseDetail(BuildContext context) {
    _isShowCollapse = true;
    _isShowInput = false;
    notifyListeners();
  }

  void onLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  reset() {
    _isLoading = true;
    onChangeBody(ShowBody.taiSan);
    clearFilter();
  }

  Future<void> getDataAll(BuildContext context) async {
    try {
      _isLoading = true;
      final bloc = context.read<AssetManagementBloc>();
      String idCongTy = _userInfo?.idCongTy ?? '';
      // Gọi song song, không cần delay
      bloc.add(GetListAssetManagementEvent(context, idCongTy));
      bloc.add(GetListAssetGroupEvent(context, idCongTy));
      bloc.add(GetListProjectEvent(context, idCongTy));
      bloc.add(GetListCapitalSourceEvent(context, idCongTy));
      bloc.add(GetListDepartmentEvent(context, idCongTy));
      bloc.add(GetListKhauHaoEvent(context, idCongTy));
      bloc.add(GetAllChildAssetsEvent(context, idCongTy));
    } catch (e) {
      SGLog.error(
        "AssetManagementProvider",
        "Error adding AssetManagement events: $e",
      );
    }
  }

  void onChangeBody(ShowBody type) {
    switch (type) {
      case ShowBody.taiSan:
        _subScreen = '';
        typeBody = ShowBody.taiSan;
        _isShowCollapse = false;
        isShowInput = false;
        break;
      case ShowBody.khauHao:
        _subScreen = 'Khấu hao tài sản';
        _isShowCollapseKhauHao = false;
        isShowInputKhauHao = false;
        typeBody = ShowBody.khauHao;
        break;
    }
  }

  void onChangeDetail(AssetManagementDto? item, {bool isNew = false}) {
    if (item != null) {
      _dataDetail = item;
      _dataDetail = _dataDetail?.copyWith(
        childAssets: getListChildAssetsByIdAsset(item.id ?? ''),
      );
      if (_dataDetail?.nguonKinhPhiList != null) {
        log('message test: _dataDetail?.nguonKinhPhiList: ${jsonEncode(_dataDetail?.nguonKinhPhiList)}');
        _initialSelectedNguonKinhPhi = itemsNguonKinhPhi
            ?.where(
              (element) => _dataDetail?.nguonKinhPhiList?.any(
                        (e) => e.id == element.value?.id,
                      ) ??
                  false,
            )
            .map((e) => e.value)
            .whereType<NguonKinhPhi>()
            .toList();
        log(
          'message test: _initialSelectedNguonKinhPhi: ${jsonEncode(_initialSelectedNguonKinhPhi)}',
        );
      }
    } else {
      _dataDetail = null;
      _isNew = isNew;
    }
    _isShowCollapse = true;
    isShowInput = true;
    notifyListeners();
  }

  List<ChildAssetDto> getListChildAssetsByIdAsset(String idTaiSan) {
    List<ChildAssetDto> list = [];
    if (_dataChildAssets != null) {
      for (var element in _dataChildAssets!) {
        if (element.idTaiSanCha == idTaiSan) {
          list.add(element);
        }
      }
    }
    return list;
  }

  void onChangeDepreciationDetail(AssetDepreciationDto? item) {
    if (item != null) {
      _dataDepreciationDetail = item;
    } else {
      _dataDepreciationDetail = null;
    }
    _isShowCollapseKhauHao = true;
    isShowInputKhauHao = true;
  }

  // CALL API SUCCESS ---------------------------------------------------------------
  getListAssetManagementSuccess(
    BuildContext context,
    GetListAssetManagementSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _data = [];
      // _filteredData = [];
      _isLoading = false;
      _filteredData = [];
      _dataPage = [];
    } else {
      _data =
          state.data.where((element) => element.isTaiSanCon == false).toList();
      _filteredData = List.from(_data!); // Khởi tạo filteredData
      _updatePagination();
      _isLoading = false;
    }
    onCloseDetail(context);
    notifyListeners();
  }

  getListChildAssetsSuccess(
    BuildContext context,
    GetListChildAssetsSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _dataChildAssets = [];
      // _filteredData = [];
    } else {
      _dataChildAssets = state.data;
      _filteredData = List.from(_dataChildAssets!); // Khởi tạo filteredData
    }
    notifyListeners();
  }

  getListKhauHaoSuccess(
    BuildContext context,
    GetListKhauHaoSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _dataKhauHao = [];
      // _filteredData = [];
    } else {
      _dataKhauHao = state.data;
    }
    notifyListeners();
  }

  createAssetSuccess(BuildContext context, CreateAssetSuccessState state) {
    _error = null;
    // Thêm tài sản mới vào danh sách
    // if (state.data != null) {
    //   _data?.add(state.data!);
    //   _filteredData = List.from(_data!);
    // }
    getDataAll(context);
    AppUtility.showSnackBar(context, 'Thêm mới thành công!');
    notifyListeners();
  }

  createAssetError(BuildContext context, CreateAssetFailedState state) {
    _error = state.message;
    _isLoading = false;
    AppUtility.showSnackBar(context, state.message, isError: true);
    notifyListeners();
  }

  AssetManagementDto? getInfoAssetByChildAsset(String idTaiSan) {
    return data.firstWhere((element) => element.idTaiSan == idTaiSan);
  }

  getListAssetGroupSuccess(
    BuildContext context,
    GetListAssetGroupSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _dataGroup = [];
    } else {
      _dataGroup = state.data;
      _initializeCheckBoxList();
      _itemsAssetGroup = [
        for (var element in _dataGroup!)
          DropdownMenuItem<AssetGroupDto>(
            value: element,
            child: Text(element.tenNhom ?? ''),
          ),
      ];
    }
    notifyListeners();
  }

  getListProjectSuccess(
    BuildContext context,
    GetListProjectSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _dataProject = [];
    } else {
      _dataProject = state.data;
      _initializeCheckBoxList();
      _itemsDuAn = [
        for (var element in _dataProject!)
          DropdownMenuItem<DuAn>(
            value: element,
            child: Text(element.tenDuAn ?? ''),
          ),
      ];
    }
    notifyListeners();
  }

  getListCapitalSourceSuccess(
    BuildContext context,
    GetListCapitalSourceSuccessState state,
  ) {
    _error = null;
    _dataCapitalSource = state.data;
    _itemsNguonKinhPhi = [
      for (var element in _dataCapitalSource!)
        DropdownMenuItem<NguonKinhPhi>(
          value: element,
          child: Text(element.tenNguonKinhPhi ?? ''),
        ),
    ];
    notifyListeners();
  }

  getListDepartmentSuccess(
    BuildContext context,
    GetListDepartmentSuccessState state,
  ) {
    _error = null;
    _dataDepartment = state.data;
    _itemsPhongBan = [
      for (var element in dataDepartment!)
        DropdownMenuItem<PhongBan>(
          value: element,
          child: Text(element.tenPhongBan ?? ''),
        ),
    ];
    notifyListeners();
  }

  getAllChildAssetsSuccess(
    BuildContext context,
    GetAllChildAssetsSuccessState state,
  ) {
    _error = null;
    _dataChildAssets = state.data;
    notifyListeners();
  }

  void updateAssetSuccess(BuildContext context, UpdateAssetSuccessState state) {
    onCloseDetail(context);
    AppUtility.showSnackBar(context, 'Cập nhật thành công!');
    getDataAll(context);
    notifyListeners();
  }

  deleteAssetSuccess(BuildContext context, DeleteAssetSuccessState state) {
    _error = null;
    getDataAll(context);
    AppUtility.showSnackBar(context, 'Xóa thành công!');
    notifyListeners();
  }

  //---------------------------------------------------------------

  // Khởi tạo checkbox list dựa trên _data
  void _initializeCheckBoxList() {
    checkBoxAssetGroup.clear();
    if (_dataGroup != null) {
      for (var item in _dataGroup!) {
        checkBoxAssetGroup.add({item.id ?? '': false});
      }
    }
  }

  // Cập nhật trạng thái checkbox
  void updateCheckBoxStatus(String id, bool value) {
    for (int i = 0; i < checkBoxAssetGroup.length; i++) {
      if (checkBoxAssetGroup[i]?.containsKey(id) == true) {
        checkBoxAssetGroup[i]![id] = value;
        break;
      }
    }
    findDataByIdAssetGroup();
    _updatePagination();

    notifyListeners();
  }

  // Lấy trạng thái checkbox theo id
  bool getCheckBoxStatus(String id) {
    for (var checkbox in checkBoxAssetGroup) {
      if (checkbox?.containsKey(id) == true) {
        return checkbox![id] ?? false;
      }
    }
    return false;
  }

  // Lấy danh sách các id đã được chọn
  List<String> getSelectedIds() {
    List<String> selectedIds = [];
    for (var checkbox in checkBoxAssetGroup) {
      checkbox?.forEach((key, value) {
        if (value == true) {
          selectedIds.add(key);
        }
      });
    }
    return selectedIds;
  }

  void findDataByIdAssetGroup() {
    List<String> selectedIds = getSelectedIds();
    if (selectedIds.isEmpty) {
      _filteredData = List.from(_data ?? []);
      notifyListeners();
      return;
    }

    if (_data != null) {
      _filteredData =
          _data!.where((item) {
            return selectedIds.contains(item.idNhomTaiSan);
          }).toList();
    } else {
      _filteredData = [];
    }
    notifyListeners();
  }

  void clearFilter() {
    _filteredData = List.from(_data ?? []);
    for (int i = 0; i < checkBoxAssetGroup.length; i++) {
      checkBoxAssetGroup[i]?.forEach((key, value) {
        checkBoxAssetGroup[i]![key] = false;
      });
    }
    notifyListeners();
  }

  void onLoadItemDropdown() {
    _itemsCountry = [
      for (var element in listCountry)
        DropdownMenuItem<Country>(value: element, child: Text(element.name)),
    ];

    //Item dropdown lý do tăng
    _itemsLyDoTang = [
      for (var element in listLyDoTang)
        DropdownMenuItem<LyDoTang>(value: element, child: Text(element.name)),
    ];

    //Item dropdown hien trang
    _itemsHienTrang = [
      for (var element in listHienTrang)
        DropdownMenuItem<HienTrang>(value: element, child: Text(element.name)),
    ];
  }

  // check permission
  void checkPermission() async {
    final repo = PermissionRepository();
    if (_userInfo != null) {
      _isCanCreate =
          await repo.checkCanCreatePermission(_userInfo!.id, RoleCode.TAISAN) ??
          false;
      _isCanUpdate =
          await repo.checkCanUpdatePermission(_userInfo!.id, RoleCode.TAISAN) ??
          false;
      _isCanDelete =
          await repo.checkCanDeletePermission(_userInfo!.id, RoleCode.TAISAN) ??
          false;
      SGLog.info(
        "_checkPermission",
        'isCanCreate: $isCanCreate -- isCanDelete: $isCanDelete -- isCanUpdate: $isCanUpdate',
      );
    }
  }
}
