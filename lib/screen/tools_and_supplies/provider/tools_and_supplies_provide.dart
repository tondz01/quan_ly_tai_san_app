import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_event.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_state.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/detail_and_edit.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/tools_and_supplies_list.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class ToolsAndSuppliesProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  List<ToolsAndSuppliesDto>? get dataPage => _dataPage;
  get data => _data;
  get columns => _columns;
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

  bool _isLoading = false;

  List<ToolsAndSuppliesDto>? _data;
  List<ToolsAndSuppliesDto>? _dataPage;
  List<SgTableColumn<ToolsAndSuppliesDto>> _columns = [];

  void onInit(BuildContext context) {
    _isLoading = true;
    controllerDropdownPage = TextEditingController(text: '10');
    // Initialize body without triggering notification
    _body = ToolsAndSuppliesList(provider: this);
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

  void onTapBackHeader() {
    log('message onTap');
    onChangeScreen(item: null, isMainScreen: true, isEdit: false);
    notifyListeners();
  }

  void onTapNewHeader() {
    log('message onTapNew');
    onChangeScreen(item: null, isMainScreen: false, isEdit: true);
    notifyListeners();
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

  void onChangeScreen({
    required ToolsAndSuppliesDto? item,
    required bool isMainScreen,
    required bool isEdit,
  }) {
    // Use Future.microtask to avoid build phase conflicts
    log('message onChangeScreen');
    Future.microtask(() {
      if (!isMainScreen) {
        _subScreen = item == null ? 'Mới' : item.name;
        _body = DetailAndEditView(item: item, isEditing: isEdit);
      } else {
        _subScreen = '';
        _subScreen = null;
        _body = ToolsAndSuppliesList(provider: this);
      }
      notifyListeners();
    });
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
    } else {
      _data = state.data;
      _isLoading = false;
      onSetColumns();
      _updatePagination();
    }
    notifyListeners();
  }

  void onSetColumns() {
    _columns = [
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Công cụ dụng cụ',
        getValue: (item) => item.name,
        width: 170,
      ),
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Đơn vị nhập',
        getValue: (item) => item.importUnit,
        width: 170,
      ),
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Mã công cụ dụng cụ',
        getValue: (item) => item.code,
        width: 170,
      ),
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Ngày nhập',
        getValue: (item) => item.importDate,
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Đơn vị tính',
        getValue: (item) => item.unit,
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Số lượng',
        getValue: (item) => item.quantity.toString(),
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Giá trị',
        getValue: (item) => item.value.toString(),
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Số ký hiệu',
        getValue: (item) => item.referenceNumber,
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Ký hiệu',
        getValue: (item) => item.symbol,
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Công suất',
        getValue: (item) => item.capacity,
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Nước sản xuất',
        getValue: (item) => item.countryOfOrigin,
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<ToolsAndSuppliesDto>(
        title: 'Năm sản xuất',
        getValue: (item) => item.yearOfManufacture,
        width: 120,
      ),
    ];
  }
}
