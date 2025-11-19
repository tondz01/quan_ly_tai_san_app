import 'dart:developer';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
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
  bool get isLoadingImport => _isLoadingImport;
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

  onLoadingImport(bool value) {
    _isLoadingImport = value;
    log('message onLoadingImport: $value');
    notifyListeners();
  }

  late int totalEntries;
  late int totalPages = 1;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 20;
  int currentPage = 0; // Changed to 0-based for API
  TextEditingController? controllerDropdownPage;
  String? _currentSearch;
  String? _currentSortBy;
  String? _currentSortDir;

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
  bool _isLoadingImport = false;

  List<ToolsAndSuppliesDto>? _data;
  List<ToolsAndSuppliesDto>? _dataPage;
  ToolsAndSuppliesDto? _dataDetail;
  List<ToolsAndSuppliesDto>? _filteredData;
  List<PhongBan>? _dataPhongBan;
  List<CcdcGroup>? _dataGroupCCDC;
  List<TypeCcdc>? _dataTypeCCDC;
  List<UnitDto>? _dataUnit;

  void onInit(BuildContext context) {
    controllerDropdownPage = TextEditingController(text: '20');
    _isShowInput = false;
    _isShowCollapse = true;
    _hasUnsavedChanges = false;
    currentPage = 0;
    rowsPerPage = 20;
    totalEntries = 0;
    totalPages = 1;
    startIndex = 0;
    endIndex = 0;
    _currentSearch = null;
    _currentSortBy = null;
    _currentSortDir = null;
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
      // Clean up search/sort values - remove null or empty strings
      final cleanSortBy = _currentSortBy != null && _currentSortBy!.trim().isNotEmpty 
          ? _currentSortBy!.trim() 
          : null;
      final cleanSortDir = _currentSortDir != null && _currentSortDir!.trim().isNotEmpty 
          ? _currentSortDir!.trim() 
          : null;
      final cleanSearch = _currentSearch != null && _currentSearch!.trim().isNotEmpty 
          ? _currentSearch!.trim() 
          : null;

      log('getListToolsAndSupplies - page: $currentPage, size: $rowsPerPage, '
          'sortBy: $cleanSortBy, sortDir: $cleanSortDir, search: $cleanSearch');

      final bloc = context.read<ToolsAndSuppliesBloc>();
      bloc.add(GetListToolsAndSuppliesEvent(
        context,
        'CT001',
        page: currentPage,
        size: rowsPerPage,
        sortBy: cleanSortBy,
        sortDir: cleanSortDir,
        search: cleanSearch,
      ));
      bloc.add(GetListPhongBanEvent(context, 'CT001'));
      bloc.add(GetListTypeCcdcEvent(context));
      bloc.add(GetListUnitEvent(context));
    } catch (e) {
      log('Error adding AssetManagement events: $e');
    }
  }

  void onSearchToolsAndSupplies(String value) {
    log('message onSearchToolsAndSupplies: $value');
    _currentSearch = value.isEmpty ? null : value.trim();
    currentPage = 0; // Reset to first page when searching
    // Trigger API call from view
    notifyListeners();
  }

  void _updatePagination() {
    // Use API pagination data if available
    List<ToolsAndSuppliesDto> dataToPaginate = data ?? [];
    totalEntries = totalEntries > 0 ? totalEntries : dataToPaginate.length;
    
    // Calculate display indices (1-based for UI)
    startIndex = currentPage * rowsPerPage;
    endIndex = (startIndex + dataToPaginate.length).clamp(0, totalEntries);

    _dataPage = dataToPaginate;
    log('message pageProducts: ${dataPage!.length}, total: $totalEntries, page: ${currentPage + 1}');
  }

  void onCloseDetail(BuildContext context) {
    _isShowInput = false;
    _isShowCollapse = true;
    notifyListeners();
  }

  void onPageChanged(BuildContext context, int page) {
    log('onPageChanged called with page: $page (1-based), converting to 0-based');
    // Convert 1-based UI page to 0-based API page
    final newPage = page - 1;
    if (currentPage != newPage) {
      currentPage = newPage;
      log('Calling API with page: $currentPage, size: $rowsPerPage, search: $_currentSearch');
      notifyListeners(); // Update UI immediately
      getListToolsAndSupplies(context);
    } else {
      log('Page unchanged, skipping API call');
    }
  }

  void onSetsShowCollapse(bool value) {
    _isShowCollapse = value;
    notifyListeners();
  }

  void onRowsPerPageChanged(BuildContext context, int? value) {
    log('onRowsPerPageChanged called with value: $value');
    if (value == null) return;
    
    if (rowsPerPage != value) {
      rowsPerPage = value;
      controllerDropdownPage?.text = value.toString();
      currentPage = 0; // Reset to first page when size changes
      log('Size changed to $rowsPerPage, resetting to page 0');
      notifyListeners(); // Update UI immediately
      getListToolsAndSupplies(context);
    } else {
      log('Size unchanged, skipping API call');
    }
  }

  getListToolsAndSuppliesSuccess(
    BuildContext context,
    GetListToolsAndSuppliesSuccessState state,
  ) {
    _error = null;
    log('getListToolsAndSuppliesSuccess - Received ${state.data.length} items');
    
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
      log('Data is empty, setting to empty list');
    } else {
      _data = state.data;
      _filteredData = state.data;
      log('Data updated: ${state.data.length} items');
    }
    
    // Update pagination info from API response
    totalEntries = state.totalElements;
    totalPages = state.totalPages;
    currentPage = state.currentPage;
    log('Pagination updated: totalEntries=$totalEntries, totalPages=$totalPages, currentPage=$currentPage');
    
    _updatePagination();
    _dataGroupCCDC = state.dataGroupCCDC;
    _isLoadingImport = false;
    
    log('Calling notifyListeners() to update UI');
    notifyListeners();
    log('notifyListeners() completed');
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

  getListUnitSuccess(BuildContext context, GetListUnitSuccessState state) {
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
