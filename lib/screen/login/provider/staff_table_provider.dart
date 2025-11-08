import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/repository/auth_repository.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableCcdcGroupProvider với tối ưu performance
final staffTableProvider = StateNotifierProvider.autoDispose<
  StaffTableProvider,
  GenericTableState<NhanVien>
>((ref) {
  final repository = AuthRepository();
  return StaffTableProvider(repository);
});

class StaffTableProvider extends TableNotifier<NhanVien> {
  final AuthRepository repository;
  int totalItems = 0;
  String _currentSearchTerm = '';
  StaffTableProvider(this.repository);
  // FIXED: Signature đúng với named parameters
  @override
  void initialize({
    required Map<String, double> columnWidths,
    required dynamic Function(NhanVien item, int columnIndex) valueGetter,
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

  // Tìm kiếm với API
  set searchTerm(String value) {
    _currentSearchTerm = value;
    loadDataFromApi(0); // Reset về trang đầu khi search
  }

  // Load dữ liệu từ API
  Future<void> loadDataFromApi(int page, {bool isRefresh = true}) async {
    try {
      final response = await repository.getDataStaffWithPagination(
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
    } catch (error) {
      log('Error loading data: $error');
      // setApiError('Lỗi tải dữ liệu: $error');
    }
  }

  // Tự động gọi API khi chuyển trang
  @override
  void goToPage(int page) {
    super.goToPage(page);
    loadDataFromApi(page);
  }

  // Refresh dữ liệu
  Future<void> refreshData([bool isRefresh = true]) async {
    await loadDataFromApi(
      state.paginationState.currentDisplayPage,
      isRefresh: isRefresh,
    );
  }

  @override
  Future<List<NhanVien>> generateData() async {
    // Không dùng trong API pagination mode
    return [];
  }
}