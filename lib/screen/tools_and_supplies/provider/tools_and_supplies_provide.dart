import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_event.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_state.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/show_un_saved_changes_dialog.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ToolsAndSuppliesProvider with ChangeNotifier {
  bool get isLoading => _data == null || _dataPhongBan == null;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  get data => _data;
  get dataPhongBan => _dataPhongBan;
  get dataGroupCCDC => _dataGroupCCDC;
  get dataDetail => _dataDetail;
  get dataPage => _dataPage;
  get filteredData => _filteredData;

  String? get error => _error;
  String? get subScreen => _subScreen;

  Widget? get body => _body;

  set subScreen(String? value) {
    _subScreen = value;
    notifyListeners();
  }

  set body(Widget? value) {
    _body = value;
    notifyListeners();
  }

  set hasUnsavedChanges(bool value) {
    _hasUnsavedChanges = value;
    notifyListeners();
  }

  late int totalEntries;
  late int totalPages = 0;
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

  String? _error;
  String? _subScreen;

  Widget? _body;
  bool _isShowInput = false;
  bool _isShowCollapse = true;
  bool _hasUnsavedChanges = false;

  List<ToolsAndSuppliesDto>? _data;
  List<ToolsAndSuppliesDto>? _dataPage;
  ToolsAndSuppliesDto? _dataDetail;
  List<ToolsAndSuppliesDto>? _filteredData;
  List<PhongBan>? _dataPhongBan;
  List<CcdcGroup>? _dataGroupCCDC;
  void onInit(BuildContext context) {
    controllerDropdownPage = TextEditingController(text: '10');
    _isShowInput = false;
    _isShowCollapse = true;
    _hasUnsavedChanges = false;
    getListToolsAndSupplies(context);
  }

  void onDispose() {
    _data = null;
    _error = null;

    if (controllerDropdownPage != null) {
      controllerDropdownPage!.dispose();
      controllerDropdownPage = null;
    }
  }

  void getListToolsAndSupplies(BuildContext context) {
    try {
      final bloc = context.read<ToolsAndSuppliesBloc>();
      bloc.add(GetListToolsAndSuppliesEvent(context, 'CT001'));
      bloc.add(GetListPhongBanEvent(context, 'CT001'));
    } catch (e) {
      log('Error adding AssetManagement events: $e');
    }
  }

  void onSearchToolsAndSupplies(String value) {
    if (value.isEmpty) {
      _filteredData = data;
      return;
    }
    log('message onSearchToolsAndSupplies: $value');

    String searchLower = value.toLowerCase().trim();
    _filteredData =
        data.where((item) {
          bool name = AppUtility.fuzzySearch(
            item.name.toLowerCase(),
            searchLower,
          );
          bool importUnit = item.importUnit.toLowerCase().contains(searchLower);
          bool departmentGroup = item.importUnit.toLowerCase().contains(
            searchLower,
          );
          bool unit = item.unit.toLowerCase().contains(searchLower);
          bool value = item.value.toString().contains(searchLower);

          return name || importUnit || departmentGroup || unit || value;
        }).toList();
    log('message _filteredData: $_filteredData');
    notifyListeners();
  }

  void _updatePagination() {
    totalEntries = data?.length ?? 0;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    _dataPage =
        data.isNotEmpty
            ? data.sublist(
              startIndex < totalEntries ? startIndex : 0,
              endIndex < totalEntries ? endIndex : totalEntries,
            )
            : [];
    log('message pageProducts: ${dataPage!.length}');
  }

  void onCloseDetail(BuildContext context) {
    _isShowInput = false;
    _isShowCollapse = true;
    notifyListeners();
  }

  void onPageChanged(int page) {
    currentPage = page;
    _updatePagination();
    notifyListeners();
  }

  void onSetsShowCollapse(bool value) {
    _isShowCollapse = value;
    notifyListeners();
  }

  void onRowsPerPageChanged(int? value) {
    log('message onRowsPerPageChanged: $value');
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
    notifyListeners();
  }

  getListToolsAndSuppliesSuccess(
    BuildContext context,
    GetListToolsAndSuppliesSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
    } else {
      _data = state.data;
      _filteredData = state.data;
      _updatePagination();
    }
    _dataGroupCCDC = state.dataGroupCCDC;
    SGLog.debug(
      "GetListToolsAndSuppliesSuccess",
      "GetListToolsAndSuppliesSuccessState: data: ${_data!.length}, dataGroupCCDC: ${_dataGroupCCDC!.length}",
    );
    notifyListeners();
  }

  getListPhongBanSuccess(
    BuildContext context,
    GetListPhongBanSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _dataPhongBan = [];
    } else {
      _dataPhongBan = state.data;
      log('message _dataPhongBan: $_dataPhongBan');
    }
    notifyListeners();
  }

  void createToolsAndSuppliesSuccess(
    BuildContext context,
    CreateToolsAndSuppliesSuccessState state,
  ) {
    onCloseDetail(context);
    getListToolsAndSupplies(context);

    // Close input panel if open
    AppUtility.showSnackBar(context, 'Tạo CCDC - Vật tư thành công!');
  }

  void updateToolsAndSuppliesSuccess(
    BuildContext context,
    UpdateToolsAndSuppliesSuccessState state,
  ) {
    onCloseDetail(context);
    getListToolsAndSupplies(context);

    // Close input panel if open
    AppUtility.showSnackBar(context, 'Cập nhập CCDC - Vật tư thành công!');
  }

  void deleteToolsAndSuppliesSuccess(
    BuildContext context,
    DeleteToolsAndSuppliesSuccessState state,
  ) {
    onCloseDetail(context);
    getListToolsAndSupplies(context);

    // Close input panel if open
    AppUtility.showSnackBar(context, 'Xóa CCDC - Vật tư thành công!');
  }

  void onChangeDetail(BuildContext context, ToolsAndSuppliesDto? item) {
    _confirmBeforeLeaving(context, item);
    notifyListeners();
  }

  Future<bool> _showUnsavedChangesDialog(
    BuildContext context,
    ToolsAndSuppliesDto? item,
  ) async {
    return showUnsavedChangesDialog(context, item, () {
      _dataDetail = item;
      _isShowInput = true;
      _isShowCollapse = true;
      hasUnsavedChanges = false;
      Navigator.of(context).pop();
    });
  }

  // Phương thức để kiểm tra và xác nhận trước khi rời khỏi
  Future<bool> _confirmBeforeLeaving(
    BuildContext context,
    ToolsAndSuppliesDto? item,
  ) async {
    if (hasUnsavedChanges) {
      return await _showUnsavedChangesDialog(context, item);
    } else {
      _dataDetail = item;
      _isShowInput = true;
      _isShowCollapse = true;
    }
    return true;
  }
}
