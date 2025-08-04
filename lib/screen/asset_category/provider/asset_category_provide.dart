// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';

class AssetCategoryProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  String? get error => _error;
  get data => _data;
  get filteredData => _filteredData;
  get dataPage => _dataPage;

  bool _isLoading = false;
  String? _error;

  late int totalEntries;
  late int totalPages;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;
  TextEditingController? controllerDropdownPage;

  List<AssetCategoryDto>? _data;
  List<AssetCategoryDto>? _filteredData;
  List<AssetCategoryDto>? _dataPage;

  final List<DropdownMenuItem<int>> items = [
    const DropdownMenuItem(value: 5, child: Text('5')),
    const DropdownMenuItem(value: 10, child: Text('10')),
    const DropdownMenuItem(value: 20, child: Text('20')),
    const DropdownMenuItem(value: 50, child: Text('50')),
  ];

  onInit(BuildContext context) {
    getListAssetCategory(context);
  }

  void getListAssetCategory(BuildContext context) {
    _isLoading = true;
    Future.microtask(() {
      context.read<AssetCategoryBloc>().add(GetListAssetCategoryEvent(context));
    });
  }

  getListAssetTransferSuccess(
    BuildContext context,
    GetListAssetCategorySuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _data = [];
      _filteredData = [];
    } else {
      _data = state.data;
      _filteredData = List.from(_data!);
      _isLoading = false;
      _updatePagination();
    }
    notifyListeners();
  }

  void _updatePagination() {
    // Sử dụng _filteredData thay vì _data
    totalEntries = _filteredData!.length;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    _dataPage =
        _filteredData!.isNotEmpty
            ? _filteredData!.sublist(
              startIndex < totalEntries ? startIndex : 0,
              endIndex < totalEntries ? endIndex : totalEntries,
            )
            : [];
  }
}
