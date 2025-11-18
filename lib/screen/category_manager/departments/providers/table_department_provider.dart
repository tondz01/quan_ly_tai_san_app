import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/providers/departments_provider.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';

/// Provider cho TableDepartmentProvider với tối ưu performance
final tableDepartmentProvider = StateNotifierProvider.autoDispose<
    TableDepartmentProvider,
    GenericTableState<PhongBan>>((ref) {
  final repository = DepartmentsProvider();
  return TableDepartmentProvider(repository);
});

class TableDepartmentProvider extends TableNotifier<PhongBan> {
  final DepartmentsProvider repository;
  int totalItems = 0;
  String _currentSearchTerm = '';

  TableDepartmentProvider(this.repository);

  // Tìm kiếm với API
  set searchTerm(String value) {
    _currentSearchTerm = value;
    loadDataFromApi(0); // Reset về trang đầu khi search
  }

  @override
  void initialize({
    required Map<String, double> columnWidths,
    required dynamic Function(PhongBan item, int columnIndex) valueGetter,
    int itemsPerPage = 20,
  }) {
    super.initialize(
      columnWidths: columnWidths,
      valueGetter: valueGetter,
      itemsPerPage: itemsPerPage,
    );
    enableApiPagination(true);
    loadDataFromApi(0);
  }

  Future<void> loadDataFromApi(int page, [bool isRefresh = true]) async {
    state = state.copyWith(isLoading: isRefresh, errorMessage: null);
    try {
      final response = await repository.getDataWithPagination(
        page,
        state.paginationState.itemsPerPage,
        _currentSearchTerm,
      );

      setApiData(
        response['data'],
        totalPages: response['totalPages'],
        currentPage: response['currentPage'],
        totalItems: response['totalItems'],
      );
      totalItems = response['totalItems'];
    } catch (error) {
      log('Error loading data Departments: $error');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Lỗi tải dữ liệu: $error',
      );
    }
  }

  Future<void> refreshData([bool isRefresh = true]) async {
    await loadDataFromApi(state.paginationState.currentDisplayPage, isRefresh);
  }

  @override
  void goToPage(int page) {
    super.goToPage(page);
    loadDataFromApi(page);
  }
}
