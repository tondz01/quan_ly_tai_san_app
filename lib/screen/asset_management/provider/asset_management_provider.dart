import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/core/utils/model_country.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_depreciation_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';

enum ShowBody { taiSan, khauHao }

class AssetManagementProvider with ChangeNotifier {
  get error => _error;
  bool get isLoading =>
      _data == null ||
      _dataGroup == null ||
      _dataProject == null ||
      _dataCapitalSource == null ||
      _dataDepartment == null ||
      _dataKhauHao == null;
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

  get itemsAssetGroup => _itemsAssetGroup;
  get itemsDuAn => _itemsDuAn;
  get itemsNguonKinhPhi => _itemsNguonKinhPhi;
  get itemsPhongBan => _itemsPhongBan;
  get itemsCountry => _itemsCountry;

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

  // bool _isLoading = true;
  bool _isShowInput = false;
  bool _isShowCollapse = false;
  bool _isShowInputKhauHao = false;
  bool _isShowCollapseKhauHao = false;
  String? _error;

  String? _subScreen;

  UserInfoDTO? _userInfo;

  AssetManagementDto? _dataDetail;
  AssetDepreciationDto? _dataDepreciationDetail;

  List<AssetManagementDto>? _data;
  List<AssetGroupDto>? _dataGroup;
  List<DuAn>? _dataProject;
  List<NguonKinhPhi>? _dataCapitalSource;
  List<PhongBan>? _dataDepartment;
  List<AssetManagementDto>? _filteredData;
  List<ChildAssetDto>? _dataChildAssets;
  List<AssetDepreciationDto>? _dataKhauHao;
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

  //Tài sản con
  HienTrang getHienTrang(int id) {
    return listHienTrang.firstWhere((element) => element.id == id);
  }

  LyDoTang getLyDoTang(int id) {
    return listLyDoTang.firstWhere((element) => element.id == id);
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
  onInit(BuildContext context) {
    reset();
    _userInfo = AccountHelper.instance.getUserInfo();
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

  reset() {
    // _isLoading = true;
    onChangeBody(ShowBody.taiSan);
    clearFilter();
  }

  Future<void> getDataAll(BuildContext context) async {
    try {
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
      log('Error adding AssetManagement events: $e');
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

  void onChangeDetail(AssetManagementDto? item) {
    if (item != null) {
      _dataDetail = item;
      _dataDetail = _dataDetail?.copyWith(
        childAssets: getListChildAssetsByIdAsset(item.id ?? ''),
      );
      log('Check load detail asset: ${jsonEncode(_dataDetail)}');
    } else {
      _dataDetail = null;
    }
    _isShowCollapse = true;
    isShowInput = true;
  }

  List<ChildAssetDto> getListChildAssetsByIdAsset(String idTaiSan) {
    List<ChildAssetDto> list = [];
    for (var element in _dataChildAssets!) {
      if (element.idTaiSanCha == idTaiSan) {
        list.add(element);
      }
    }
    log('getListChildAssetsByIdAsset: ${list.length}');
    return list;
  }

  void onChangeDepreciationDetail(AssetDepreciationDto? item) {
    if (item != null) {
      _dataDepreciationDetail = item;
    } else {
      _dataDepreciationDetail = null;
    }
    log('message onChangeDepreciationDetail');
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
    } else {
      _data = state.data;
      _filteredData = List.from(_data!); // Khởi tạo filteredData
    }
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

  void updateAssetSuccess(
    BuildContext context,
    UpdateAssetSuccessState state,
  ) {
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

    log('onLoadItemDropdown itemsLyDoTang: ${_itemsLyDoTang.length}');

    //Item dropdown hien trang
    _itemsHienTrang = [
      for (var element in listHienTrang)
        DropdownMenuItem<HienTrang>(value: element, child: Text(element.name)),
    ];

    log('onLoadItemDropdown itemsHienTrang: ${_itemsHienTrang.length}');
  }
}
