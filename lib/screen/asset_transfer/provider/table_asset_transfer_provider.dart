import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableCcdcGroupProvider với tối ưu performance
final tableAssetTransferProvider = StateNotifierProvider.autoDispose<
  TableAssetTransferProvider,
  GenericTableState<DieuDongTaiSanDto>
>((ref) {
  final repository = AssetTransferRepository();
  return TableAssetTransferProvider(repository);
});

class TableAssetTransferProvider extends TableNotifier<DieuDongTaiSanDto> {
  final AssetTransferRepository repository;
  int totalItems = 0;
  String _currentSearchTerm = '';
  int _currentType = 1; // lưu type hiện tại
  TableAssetTransferProvider(this.repository);

  // FIXED: Signature đúng với named parameters
  @override
  void initialize({
    required Map<String, double> columnWidths,
    required dynamic Function(DieuDongTaiSanDto item, int columnIndex)
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
    loadDataFromApi(0, _currentType);
  }

  // Tìm kiếm với API
  set searchTerm(String value) {
    _currentSearchTerm = value;
    loadDataFromApi(0, _currentType); // Reset về trang đầu khi search
  }

  // Load dữ liệu từ API
  Future<void> loadDataFromApi(int page, int type, [bool isRefresh = true]) async {
    _currentType = type; // cập nhật type
    state = state.copyWith(isLoading: isRefresh, errorMessage: null);
    setApiLoading();
    try {
      // Gọi API của bạn
      final response = await repository.getDataWithPagination(
        page,
        state.paginationState.itemsPerPage,
        _currentType,
        _currentSearchTerm,
      );
      // Cập nhật data và pagination info
      setApiData(
        response['data'],
        totalPages: response['totalPages'],
        currentPage: response['currentPage'],
        totalItems: response['totalItems'],
      );
    } catch (error) {
      log('Error loading data: $error');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Lỗi tải dữ liệu: $error',
      );
    }
  }

  // Tự động gọi API khi chuyển trang
  @override
  void goToPage(int page) {
    super.goToPage(page);
    loadDataFromApi(page, _currentType);
  }

  // Refresh dữ liệu
  Future<void> refreshData(int type) async {
    _currentType = type;
    log('loadDataFromApi refreshData: type=$_currentType -- typeInsert=$type');

    await loadDataFromApi(
      state.paginationState.currentDisplayPage,
      _currentType,
    );
  }

  @override
  Future<List<DieuDongTaiSanDto>> generateData() async {
    // Không dùng trong API pagination mode
    return [];
  }
}
