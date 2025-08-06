import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/bloc/asset-management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/bloc/asset_management_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/model/asset_management_dto.dart';

class AssetManagementProvider with ChangeNotifier {
  get error => _error;
  bool get isLoading => _isLoading;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  get subScreen => _subScreen;

  get data => _data;
  get dataDetail => _dataDetail;
  get filteredData => _filteredData ?? _data;

  bool _isLoading = false;
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
  List<AssetManagementDto>? _filteredData;
  AssetManagementDto? _dataDetail;

  List<Map<String, bool>?> checkBoxAssetGroup = [];
  onInit(BuildContext context) {
    // _subScreen = 'Loại tài sản';
    isShowInput = false;
    isShowCollapse = false;
    getAssetManagements(context);
    notifyListeners();
  }

  reset() {
    _isLoading = true;
    clearFilter();
  }

  getAssetManagements(BuildContext context) {
    context.read<AssetManagementBloc>().add(
      GetListAssetManagementEvent(context, 'CT001'),
    );
  }

  onCreatedAsset() {
    isShowInput = true;
    isShowCollapse = true;
    notifyListeners();
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
      _isLoading = false;
      // _updatePagination();

      _initializeCheckBoxList();
    }
    notifyListeners();
  }

  // Khởi tạo checkbox list dựa trên _data
  void _initializeCheckBoxList() {
    checkBoxAssetGroup.clear();
    if (_data != null) {
      for (var item in _data!) {
        checkBoxAssetGroup.add({item.idNhomTaiSan ?? '': false});
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
    log('checkBoxAssetGroup: ${checkBoxAssetGroup.toList()}');
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
      log('Không có ID nào được chọn - Hiển thị tất cả dữ liệu');
      _filteredData = List.from(_data ?? []);
      notifyListeners();
      return;
    }

    log('Đang lọc theo danh sách ID đã chọn: $selectedIds');

    // Lọc dữ liệu theo danh sách ID đã chọn
    if (_data != null) {
      _filteredData =
          _data!.where((item) {
            return selectedIds.contains(item.idNhomTaiSan);
          }).toList();
    } else {
      _filteredData = [];
    }

    // Cập nhật UI
    notifyListeners();
  }

  // Hàm để reset filter và hiển thị tất cả dữ liệu
  void clearFilter() {
    _filteredData = List.from(_data ?? []);

    // Reset tất cả checkbox về false
    for (int i = 0; i < checkBoxAssetGroup.length; i++) {
      checkBoxAssetGroup[i]?.forEach((key, value) {
        checkBoxAssetGroup[i]![key] = false;
      });
    }

    log(
      'Đã xóa filter - Hiển thị tất cả ${_filteredData?.length ?? 0} item(s)',
    );
    notifyListeners();
  }
}
