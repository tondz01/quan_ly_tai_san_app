import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/bloc/asset-management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/bloc/asset-management_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/asset_transfer_bloc.dart';

class AssetManagementProvider with ChangeNotifier {
  get error => _error;
  bool get isLoading => _isLoading;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  get subScreen => _subScreen;

  get data => _data;

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

  onInit(BuildContext context) {
    // _subScreen = 'Loại tài sản';
    isShowInput = false;
    isShowCollapse = false;
    getAssetManagements(context);
    notifyListeners();
  }

  reset() {
    _isLoading = true;
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
      // _filteredData = List.from(_data!);
      _isLoading = false;
      // _updatePagination();
    }
    notifyListeners();
  }
}
