import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';

/// Provider cho TableAssetHandoverProvider với phân trang API
final tableAssetHandoverProvider = StateNotifierProvider.autoDispose<
  TableAssetHandoverProvider,
  GenericTableState<AssetHandoverDto>
>((ref) {
  final repository = AssetHandoverRepository();
  return TableAssetHandoverProvider(repository);
});

extension TableAssetHandoverTotals on TableAssetHandoverProvider {
  Map<String, int> getTotals() {
    return {
      'totalAll': totalAll,
      'totalDraft': totalDraft,
      'totalApprove': totalApprove,
      'totalCancel': totalCancel,
      'totalComplete': totalComplete,
    };
  }
}

class TableAssetHandoverProvider extends TableNotifier<AssetHandoverDto> {
  final AssetHandoverRepository repository;

  TableAssetHandoverProvider(this.repository);

  int totalItems = 0;
  String _currentSearchTerm = '';
  int _currentTrangThai = -1;
  int totalAll = 0;
  int totalDraft = 0;
  int totalApprove = 0;
  int totalCancel = 0;
  int totalComplete = 0;
  bool _isInitialized = false;
  bool _isLoading = false;

  @override
  void initialize({
    required Map<String, double> columnWidths,
    required dynamic Function(AssetHandoverDto item, int columnIndex)
        valueGetter,
    int itemsPerPage = 20,
  }) {
    // Tránh gọi initialize nhiều lần
    if (_isInitialized) {
      log('TableAssetHandoverProvider: Already initialized, skipping');
      return;
    }
    
    super.initialize(
      columnWidths: columnWidths,
      valueGetter: valueGetter,
      itemsPerPage: itemsPerPage,
    );

    // Bật chế độ phân trang API và load trang đầu tiên
    enableApiPagination(true);
    _isInitialized = true;
    loadDataFromApi(0, _currentTrangThai);
  }

  set searchTerm(String value) {
    _currentSearchTerm = value;
    loadDataFromApi(0, _currentTrangThai);
  }

  Future<void> loadDataFromApi(
    int page,
    int trangThai, [
    bool isRefresh = true,
  ]) async {
    // Tránh gọi API đồng thời nhiều lần
    if (_isLoading) {
      log('loadDataFromApi AssetHandover: Already loading, skipping duplicate call');
      return;
    }
    
    log(
      'loadDataFromApi AssetHandover: page=$page -- trangThai=$trangThai -- isRefresh=$isRefresh',
    );
    _currentTrangThai = trangThai;
    _isLoading = true;

    try {
      final response = await repository.getDataWithPagination(
        page,
        state.paginationState.itemsPerPage,
        _currentSearchTerm,
        _currentTrangThai,
      );

      setApiData(
        response['data'],
        totalPages: response['totalPages'],
        currentPage: response['currentPage'],
        totalItems: response['totalItems'],
      );

      totalItems = response['totalItems'];
      totalAll = response['totalAll'];
      totalDraft = response['totalDraft'];
      totalApprove = response['totalApprove'];
      totalCancel = response['totalCancel'];
      totalComplete = response['totalComplete'];
    } catch (error) {
      log('Error loading AssetHandover data: $error');
    } finally {
      _isLoading = false;
    }
  }

  @override
  void goToPage(int page) {
    super.goToPage(page);
    loadDataFromApi(page, _currentTrangThai);
  }

  Future<void> refreshData([bool isRefresh = true]) async {
    await loadDataFromApi(
      state.paginationState.currentDisplayPage,
      _currentTrangThai,
      isRefresh,
    );
  }

  Future<void> filterByStatus(int status) async {
    _currentTrangThai = status;
    await loadDataFromApi(0, _currentTrangThai);
  }

  @override
  Future<List<AssetHandoverDto>> generateData() async {
    // Không dùng trong chế độ phân trang API
    return [];
  }
}
