import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/project.dart';

class AssetManagementProvider with ChangeNotifier {
  get error => _error;
  bool get isLoading => _data == null || _dataGroup == null || _dataProject == null;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  get subScreen => _subScreen;

  get data => _data;
  get dataDetail => _dataDetail;
  get filteredData => _filteredData ?? _data;
  get dataGroup => _dataGroup;
  get dataProject => _dataProject;

  // bool _isLoading = true;
  bool _isShowInput = false;
  bool _isShowCollapse = false;
  String? _error;
  set isShowInput(bool value) {
    _isShowInput = value;
    notifyListeners();
  }

  set isShowCollapse(bool value) {
    _isShowCollapse = value;
    notifyListeners();
  }

  String? _subScreen;

  List<AssetManagementDto>? _data;
  List<AssetGroupDto>? _dataGroup;
  List<Project>? _dataProject;
  List<AssetManagementDto>? _filteredData;
  AssetManagementDto? _dataDetail;

  List<Map<String, bool>?> checkBoxAssetGroup = [];
  onInit(BuildContext context) {
    reset();
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
    }
    log('message getListAssetGroupSuccess: ${_dataGroup?.length}');
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
    }
    log('message getListProjectSuccess: ${_dataProject?.length}');
    notifyListeners();
  }

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
    log('message updateCheckBoxStatus: $id -- $value');
    for (int i = 0; i < checkBoxAssetGroup.length; i++) {
      if (checkBoxAssetGroup[i]?.containsKey(id) == true) {
        checkBoxAssetGroup[i]![id] = value;
        log('message checkBoxAssetGroup: ${checkBoxAssetGroup[i]}');
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
}
