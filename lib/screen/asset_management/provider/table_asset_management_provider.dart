import 'dart:developer';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableAssetManagementProvider = StateNotifierProvider.autoDispose<
  TableAssetManagementProvider,
  GenericTableState<AssetManagementDto>
>((ref) {
  final repository = AssetManagementRepository();
  return TableAssetManagementProvider(repository);
});

class TableAssetManagementProvider extends TableNotifier<AssetManagementDto> {
  final AssetManagementRepository repository;
  int totalItems = 0;
  int _typeTab = 0;
  String _currentSearchTerm = '';
  String? _currentIdNhomTaiSan = '';
  Map<String, dynamic> _groupCounts = {};
  TableAssetManagementProvider(this.repository);
  // FIXED: Signature đúng với named parameters
  @override
  void initialize({
    required Map<String, double> columnWidths,
    required dynamic Function(AssetManagementDto item, int columnIndex)
    valueGetter,
    int itemsPerPage = 20,
  }) {
    super.initialize(
      columnWidths: columnWidths,
      valueGetter: valueGetter,
      itemsPerPage: itemsPerPage,
    );

    // Bật API pagination
    enableApiPagination(true);
    loadDataFromApi(0, _currentIdNhomTaiSan);
  }

  // Tìm kiếm với API
  set searchTerm(String value) {
    _currentSearchTerm = value;
    loadDataFromApi(0, _currentIdNhomTaiSan); // Reset về trang đầu khi search
  }

  // Load dữ liệu từ API
  Future<void> loadDataFromApi(
    int page,
    String? idNhomTaiSan, [
    bool isRefresh = true,
  ]) async {
    state = state.copyWith(isLoading: isRefresh, errorMessage: null);
    // setApiLoading();
    try {
      Map<String, dynamic> response = {};
      // Gọi API của bạn
      if (_typeTab == 0) {
        response = await repository.getDataWithPagination(
          page,
          state.paginationState.itemsPerPage,
          _currentSearchTerm,
          idNhomTaiSan,
          _typeTab,
        );
      }

      // Cập nhật data và pagination info
      setApiData(
        response['data'],
        totalPages: response['totalPages'],
        currentPage: response['currentPage'],
        totalItems: response['totalItems'],
      );
      _groupCounts = response['groupCounts'];
      totalItems = response['totalItems'];
    } catch (error) {
      log('Error loading data: $error');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Lỗi tải dữ liệu: $error',
      );
    }
  }

  getGroupCounts(String status) {
    return _groupCounts[status];
  }

  searchByGroup(String idNhomTaiSan) {
    _currentIdNhomTaiSan = idNhomTaiSan;
    loadDataFromApi(0, _currentIdNhomTaiSan);
  }

  // Tự động gọi API khi chuyển trang
  @override
  void goToPage(int page) {
    super.goToPage(page);
    loadDataFromApi(page, _currentIdNhomTaiSan);
  }

  // Refresh dữ liệu
  Future<void> refreshData([bool isRefresh = true]) async {
    await loadDataFromApi(
      state.paginationState.currentDisplayPage,
      _currentIdNhomTaiSan,
      isRefresh,
    );
  }

  Future<void> refreshTab(int typeTab, [bool isRefresh = true]) async {
    _typeTab = typeTab;
    await loadDataFromApi(
      state.paginationState.currentDisplayPage,
      _currentIdNhomTaiSan,
      isRefresh,
    );
  }

  @override
  Future<List<AssetManagementDto>> generateData() async {
    // Không dùng trong API pagination mode
    return [];
  }
}
