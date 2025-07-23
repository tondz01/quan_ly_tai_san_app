import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/bloc/tools_and_supplies_event.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/bloc/tools_and_supplies_state.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/model/tools_and_supplies_dto.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class ToolsAndSuppliesProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  get data => _data;
  get columns => _columns;

  String? _error;
  String? get error => _error;

  bool _isLoading = false;

  List<ToolsAndSuppliesDto>? _data;

  List<SgTableColumn<ToolsAndSuppliesDto>> _columns = [];

  void onInit(BuildContext context) {
    _isLoading = true;
    log('message onInit');
    getListToolsAndSupplies(context);
  }

  void onDispose() {
    _isLoading = false;
    _data = null;
    _error = null;
  }

  final List<DropdownMenuItem<int>> items = [
    const DropdownMenuItem(value: 5, child: Text('5')),
    const DropdownMenuItem(value: 10, child: Text('10')),
    const DropdownMenuItem(value: 20, child: Text('20')),
    const DropdownMenuItem(value: 50, child: Text('50')),
  ];

  void getListToolsAndSupplies(BuildContext context) {
    _isLoading = true;
    context.read<ToolsAndSuppliesBloc>().add(
      GetListToolsAndSuppliesEvent(context),
    );
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
