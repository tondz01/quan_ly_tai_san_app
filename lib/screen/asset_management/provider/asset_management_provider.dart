import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/core/utils/model_country.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';

class AssetManagementProvider with ChangeNotifier {
  get error => _error;
  bool get isLoading =>
      _data == null ||
      _dataGroup == null ||
      _dataProject == null ||
      _dataCapitalSource == null ||
      _dataDepartment == null;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  get subScreen => _subScreen;

  get data => _data;
  get dataDetail => _dataDetail;
  get filteredData => _filteredData ?? _data;

  get dataGroup => _dataGroup;
  get dataProject => _dataProject;
  get dataCapitalSource => _dataCapitalSource;
  get dataDepartment => _dataDepartment;
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

  // bool _isLoading = true;
  bool _isShowInput = false;
  bool _isShowCollapse = false;
  String? _error;

  String? _subScreen;

  List<AssetManagementDto>? _data;
  List<AssetGroupDto>? _dataGroup;
  List<DuAn>? _dataProject;
  List<NguonKinhPhi>? _dataCapitalSource;
  List<PhongBan>? _dataDepartment;
  List<AssetManagementDto>? _filteredData;
  AssetManagementDto? _dataDetail;

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
    return countries.firstWhereOrNull(
      (country) => country.id == id,
    );
  }

  List<Map<String, bool>?> checkBoxAssetGroup = [];
  onInit(BuildContext context) {
    reset();
    onLoadItemDropdown();
    isShowInput = false;
    isShowCollapse = false;
    getDataAll(context);
    notifyListeners();
  }

  reset() {
    // _isLoading = true;
    clearFilter();
  }

  Future<void> getDataAll(BuildContext context) async {
    try {
      final bloc = context.read<AssetManagementBloc>();
      // Gọi song song, không cần delay
      bloc.add(GetListAssetManagementEvent(context, 'CT001'));
      bloc.add(GetListAssetGroupEvent(context, 'CT001'));
      bloc.add(GetListProjectEvent(context, 'CT001'));
      bloc.add(GetListCapitalSourceEvent(context, 'CT001'));
      bloc.add(GetListDepartmentEvent(context, 'CT001'));
    } catch (e) {
      log('Error adding AssetManagement events: $e');
    }
  }

  void onChangeDetail(AssetManagementDto? item) {
    if (item != null) {
      _dataDetail = item;
    } else {
      _dataDetail = null;
    }
    _isShowCollapse = true;
    isShowInput = true;
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

  createAssetSuccess(
    BuildContext context,
    CreateAssetSuccessState state,
  ) {
    _error = null;
    // Thêm tài sản mới vào danh sách
    // if (state.data != null) {
    //   _data?.add(state.data!);
    //   _filteredData = List.from(_data!);
    // }
    getDataAll(context);
    notifyListeners();
  }

  createAssetError(
    BuildContext context,
    CreateAssetFailedState state,
  ) {
    _error = state.message;
    notifyListeners();
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
      log('------------------------------------------------');
      log(
        '----------_itemsAssetGroup: ${_itemsAssetGroup?.length}---------------',
      );
      log('------------------------------------------------');
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
      log('------------------------------------------------');
      log('----------itemsDuAn: ${_itemsDuAn?.length}---------------');
      log('------------------------------------------------');
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
    log('------------------------------------------------');
    log(
      '----------_dataCapitalSource: ${_dataCapitalSource?.length}---------------',
    );
    log('------------------------------------------------');
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

    log('------------------------------------------------');
    log('----------_dataDepartment: ${_dataDepartment?.length}---------------');
    log('------------------------------------------------');
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
        DropdownMenuItem<Country>(
          value: element,
          child: Text(element.name),
        ),
    ];

    //Item dropdown lý do tăng
    _itemsLyDoTang = [
      for (var element in listLyDoTang)
        DropdownMenuItem<LyDoTang>(
          value: element,
          child: Text(element.name),
        ),
    ];

    log('onLoadItemDropdown itemsLyDoTang: ${_itemsLyDoTang.length}');

    //Item dropdown hien trang
    _itemsHienTrang = [
      for (var element in listHienTrang)
        DropdownMenuItem<HienTrang>(
          value: element,
          child: Text(element.name),
        ),
    ];

    log('onLoadItemDropdown itemsHienTrang: ${_itemsHienTrang.length}');
  }
}
