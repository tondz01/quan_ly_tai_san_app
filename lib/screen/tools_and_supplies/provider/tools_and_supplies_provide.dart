import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_event.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_state.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

class ToolsAndSuppliesProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  List<ToolsAndSuppliesDto>? get dataPage => _dataPage;
  ToolsAndSuppliesDto? get item => _item;
  List<ToolsAndSuppliesDto>? get filteredData => _filteredData;
  bool get isShowInput => _isShowInput;
  bool get isShowCollapse => _isShowCollapse;
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  get data => _data;
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

  set dataPage(List<ToolsAndSuppliesDto>? value) {
    _dataPage = value;
    notifyListeners();
  }

  set filteredData(List<ToolsAndSuppliesDto>? value) {
    _filteredData = value;
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

  set hasUnsavedChanges(bool value) {
    _hasUnsavedChanges = value;
    notifyListeners();
  }

  late int totalEntries;
  late int totalPages;
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

  bool _isLoading = false;

  List<ToolsAndSuppliesDto>? _data;
  List<ToolsAndSuppliesDto>? _dataPage;
  ToolsAndSuppliesDto? _item;
  List<ToolsAndSuppliesDto>? _filteredData;
  void onInit(BuildContext context) {
    _isLoading = true;
    controllerDropdownPage = TextEditingController(text: '10');
    // Initialize body without triggering notification
    // _body = ToolsAndSuppliesList(provider: this);
    log('message onInit');
    getListToolsAndSupplies(context);
  }

  void onDispose() {
    _isLoading = false;
    _data = null;
    _error = null;

    if (controllerDropdownPage != null) {
      controllerDropdownPage!.dispose();
      controllerDropdownPage = null;
    }
  }

  void getListToolsAndSupplies(BuildContext context) {
    _isLoading = true;
    // Delay the event dispatch to avoid build phase conflicts
    Future.microtask(() {
      context.read<ToolsAndSuppliesBloc>().add(
        GetListToolsAndSuppliesEvent(context),
      );
    });
  }

  void onSearchToolsAndSupplies(String value) {
    if (value.isEmpty) {
      filteredData = data;
      return;
    }
    log('message onSearchToolsAndSupplies: $value'); 

    String searchLower = value.toLowerCase().trim();
    filteredData =
        data.where((item) {
          bool name = AppUtility.fuzzySearch(
            item.name.toLowerCase(),
            searchLower,
          );
          bool importUnit = item.importUnit.toLowerCase().contains(
            searchLower,
          );
          bool departmentGroup = item.importUnit.toLowerCase().contains(
            searchLower,
          );
          bool unit = item.unit.toLowerCase().contains(
            searchLower,
          );
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

    dataPage =
        data.isNotEmpty
            ? data.sublist(
              startIndex < totalEntries ? startIndex : 0,
              endIndex < totalEntries ? endIndex : totalEntries,
            )
            : [];
    log('message pageProducts: ${dataPage!.length}');
  }

  void onPageChanged(int page) {
    currentPage = page;
    _updatePagination();
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

  void updateItem(ToolsAndSuppliesDto updatedItem) {
    if (_data == null) return;

    int index = _data!.indexWhere((item) => item.id == updatedItem.id);

    if (index != -1) {
      _data![index] = updatedItem;

      _updatePagination();

      notifyListeners();

      log('Đã cập nhật item có ID: ${updatedItem.id}');
    } else {
      log('Không tìm thấy item có ID: ${updatedItem.id}');
    }
  }

  void deleteItem(String id) {
    if (_data == null) return;

    // Tìm vị trí của item cần xóa
    int index = _data!.indexWhere((item) => item.id == id);

    if (index != -1) {
      // Xóa item khỏi danh sách
      _data!.removeAt(index);

      // Cập nhật lại trang hiện tại
      _updatePagination();

      // Thông báo UI cập nhật
      notifyListeners();

      log('Đã xóa item có ID: $id');
    } else {
      log('Không tìm thấy item có ID: $id');
    }
  }

  void addNewItem(ToolsAndSuppliesDto newItem) {
    if (_data == null) {
      _data = [];
    }

    // Thêm item mới vào đầu danh sách
    _data!.insert(0, newItem);

    // Cập nhật lại trang hiện tại
    _updatePagination();

    // Thông báo UI cập nhật
    notifyListeners();

    log('Đã thêm item mới có ID: ${newItem.id}');
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
      _isLoading = false;
      log('message _data: $_data');
      _updatePagination();
    }
    notifyListeners();
  }

  void onChangeDetail(BuildContext context, ToolsAndSuppliesDto? item) {
    _confirmBeforeLeaving(context, item);

    notifyListeners();
  }

  Future<bool> _showUnsavedChangesDialog(
    BuildContext context,
    ToolsAndSuppliesDto? item,
  ) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Thay đổi chưa lưu'),
              content: const Text(
                'Bạn có thay đổi chưa lưu. Bạn có chắc chắn muốn rời khỏi trang này?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    _item = item;
                    log('message onChangeDetail: $_item');
                    isShowInput = true;
                    isShowCollapse = true;
                    log('message _item: $_item');
                    hasUnsavedChanges = false;
                    Navigator.of(context).pop();
                  },
                  child: const Text('Rời khỏi'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  // Phương thức để kiểm tra và xác nhận trước khi rời khỏi
  Future<bool> _confirmBeforeLeaving(
    BuildContext context,
    ToolsAndSuppliesDto? item,
  ) async {
    if (hasUnsavedChanges) {
      return await _showUnsavedChangesDialog(context, item);
    } else {
      _item = item;
      isShowInput = true;
      isShowCollapse = true;
    }
    return true;
  }
}
