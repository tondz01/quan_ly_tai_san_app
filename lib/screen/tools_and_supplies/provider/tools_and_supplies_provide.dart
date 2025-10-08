import 'dart:developer';

import 'dart:typed_data';

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
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';

class ToolsAndSuppliesProvider with ChangeNotifier {
  bool get isLoading => _data == null || _dataPhongBan == null;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  get data => _data;
  get dataPhongBan => _dataPhongBan;
  get dataGroupCCDC => _dataGroupCCDC;
  get dataTypeCCDC => _dataTypeCCDC;
  get dataUnit => _dataUnit;
  get dataDetail => _dataDetail;
  get dataPage => _dataPage;
  get filteredData => _filteredData;
  bool get isUpdateDetail => _isUpdateDetail;

  get selectedFileName => _selectedFileName;
  get selectedFilePath => _selectedFilePath;
  get selectedFileBytes => _selectedFileBytes;

  String? get error => _error;
  String? get subScreen => _subScreen;

  Widget? get body => _body;

  bool _isUpdateDetail = false;

  set subScreen(String? value) {
    _subScreen = value;
    notifyListeners();
  }

  set isUpdateDetail(bool value) {
    _isUpdateDetail = value;
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
  late int totalPages = 1;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;
  TextEditingController? controllerDropdownPage;

  String? _selectedFileName;
  String? _selectedFilePath;
  Uint8List? _selectedFileBytes;

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
  List<TypeCcdc>? _dataTypeCCDC;
  List<UnitDto>? _dataUnit;

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
      bloc.add(GetListTypeCcdcEvent(context));
      bloc.add(GetListUnitEvent(context));
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
          bool ten = AppUtility.fuzzySearch(
            item.ten.toLowerCase(),
            searchLower,
          );
          bool idDonVi = AppUtility.fuzzySearch(
            item.idDonVi.toLowerCase(),
            searchLower,
          );
          bool idNhomCCDC = AppUtility.fuzzySearch(
            item.idNhomCCDC.toLowerCase(),
            searchLower,
          );
          bool idLoaiCCDCCon = AppUtility.fuzzySearch(
            item.idLoaiCCDCCon.toLowerCase(),
            searchLower,
          );
          bool id = AppUtility.fuzzySearch(item.id.toLowerCase(), searchLower);
          bool kyHieu = AppUtility.fuzzySearch(
            item.kyHieu.toLowerCase(),
            searchLower,
          );
          bool donViTinh = AppUtility.fuzzySearch(
            item.donViTinh.toLowerCase(),
            searchLower,
          );

          return ten ||
              idDonVi ||
              idNhomCCDC ||
              idLoaiCCDCCon ||
              id ||
              kyHieu ||
              donViTinh;
        }).toList();
    
    // Cập nhật phân trang sau khi search
    _updatePagination();
    notifyListeners();
  }

  void _updatePagination() {
    // Sử dụng filteredData thay vì data để phân trang đúng khi có search
    List<ToolsAndSuppliesDto> dataToPaginate = filteredData ?? data ?? [];
    totalEntries = dataToPaginate.length;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    _dataPage =
        dataToPaginate.isNotEmpty
            ? dataToPaginate.sublist(
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
      _updatePagination();
    } else {
      _data = state.data;
      _filteredData = state.data;
      _updatePagination();
    }
    _dataGroupCCDC = state.dataGroupCCDC;
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
    }
    notifyListeners();
  }

  getListTypeCcdcSuccess(
    BuildContext context,
    GetListTypeCcdcSuccessState state,
  ) {
    _error = null;
    _dataTypeCCDC = state.data;
    notifyListeners();
  }

  getListUnitSuccess(
    BuildContext context,
    GetListUnitSuccessState state,
  ) {
    _error = null;
    _dataUnit = state.data;
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

  void deleteToolsAndSuppliesBatchSuccess(
    BuildContext context,
    DeleteToolsAndSuppliesBatchSuccessState state,
  ) {
    onCloseDetail(context);
    getListToolsAndSupplies(context);

    AppUtility.showSnackBar(context, 'Xóa danh sách CCDC - Vật tư thành công!');
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
      _isUpdateDetail = true;
      log('message test: _showUnsavedChangesDialog: $isUpdateDetail');
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
      _isUpdateDetail = true;
      log('message test: _showUnsavedChangesDialog: $isUpdateDetail');
    }
    return true;
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

  void onSubmit(String? fileName, String? filePath, Uint8List? fileBytes) {
    _selectedFileName = fileName;
    _selectedFilePath = filePath;
    _selectedFileBytes = fileBytes;
    notifyListeners();
  }
}
