import 'dart:developer';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/staf_provider/nhan_vien_provider.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableStaffProvider = StateNotifierProvider.autoDispose<
  TableStaffProvider,
  GenericTableState<NhanVien>
>((ref) {
  final repository = NhanVienProvider();
  return TableStaffProvider(repository);
});

class TableStaffProvider extends TableNotifier<NhanVien> {
  final NhanVienProvider repository;
  int totalItems = 0;
  String _currentSearchTerm = '';

  TableStaffProvider([NhanVienProvider? repository])
    : repository = repository ?? NhanVienProvider();

  // Tìm kiếm với API
  set searchTerm(String value) {
    _currentSearchTerm = value;
    loadDataFromApi(0); // Reset về trang đầu khi search
  }

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
      log('Error loading data Staff: $error');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Lỗi tải dữ liệu: $error',
      );
    }
  }

  Future<void> refreshData([bool isRefresh = true]) async {
    log('Refreshing data');
    await loadDataFromApi(state.paginationState.currentDisplayPage, isRefresh);
  }

  @override
  void goToPage(int page) {
    super.goToPage(page);
    loadDataFromApi(page);
  }
}
