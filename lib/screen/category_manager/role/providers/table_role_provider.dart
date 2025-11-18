import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/repository/role_repository.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableRoleProvider với tối ưu performance
final tableRoleProvider = StateNotifierProvider.autoDispose<
  TableRoleProvider,
  GenericTableState<ChucVu>
>((ref) {
  final repository = RoleRepository();
  return TableRoleProvider(repository);
});

class TableRoleProvider extends TableNotifier<ChucVu> {
  final RoleRepository repository;
  int totalItems = 0;
  String _currentSearchTerm = '';
  TableRoleProvider(this.repository);

  // Tìm kiếm với API
  set searchTerm(String value) {
    _currentSearchTerm = value;
    loadDataFromApi(0); // Reset về trang đầu khi search
  }

  @override
  void initialize({
    required Map<String, double> columnWidths,
    required dynamic Function(ChucVu item, int columnIndex) valueGetter,
    int itemsPerPage = 20,
  }) {
    super.initialize(
      columnWidths: columnWidths,
      valueGetter: valueGetter,
      itemsPerPage: itemsPerPage,
    );
    // Bật API pagination
    enableApiPagination(true);
    loadDataFromApi(0);
  }

  // Load dữ liệu từ API
  Future<void> loadDataFromApi(int page, [bool isRefresh = true]) async {
    state = state.copyWith(isLoading: isRefresh, errorMessage: null);
    // setApiLoading();
    try {
      Map<String, dynamic> response = {};
      // Gọi API của bạn
      response = await repository.getDataWithPagination(
        page,
        state.paginationState.itemsPerPage,
        _currentSearchTerm,
      );

      // Cập nhật data và pagination info
      setApiData(
        response['data'],
        totalPages: response['totalPages'],
        currentPage: response['currentPage'],
        totalItems: response['totalItems'],
      );
      totalItems = response['totalItems'];
    } catch (error) {
      log('Error loading data AssetManagement: $error');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Lỗi tải dữ liệu: $error',
      );
    }
  }

  // Refresh dữ liệu
  Future<void> refreshData([bool isRefresh = true]) async {
    await loadDataFromApi(state.paginationState.currentDisplayPage, isRefresh);
  }

  @override
  void goToPage(int page) {
    super.goToPage(page);
    loadDataFromApi(page);
  }
}
