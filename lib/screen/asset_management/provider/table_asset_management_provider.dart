import 'dart:async';
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
  int typeTab = 0;
  String _currentSearchTerm = '';
  String? _currentIdNhomTaiSan = '';
  Map<String, dynamic> _groupCounts = {};

  // Request ID để tránh race condition khi switch tab liên tục
  int _currentRequestId = 0;

  // Debounce timer cho search - chờ 500ms sau khi ngừng nhập
  Timer? _searchDebounceTimer;

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

    log("API URL initialize Tab: $typeTab");
    // Bật API pagination
    enableApiPagination(true);
    loadDataFromApi(0, _currentIdNhomTaiSan);
  }

  // Tìm kiếm với API - debounce 500ms
  set searchTerm(String value) {
    _currentSearchTerm = value;

    // Hủy timer cũ nếu có
    _searchDebounceTimer?.cancel();

    // Tạo timer mới - chỉ gọi API sau 500ms ngừng nhập
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      loadDataFromApi(0, _currentIdNhomTaiSan); // Reset về trang đầu khi search
    });
  }

  // Load dữ liệu từ API
  Future<void> loadDataFromApi(
    int page,
    String? idNhomTaiSan, [
    bool isRefresh = true,
  ]) async {
    // Tăng request ID để cancel các request cũ
    _currentRequestId++;
    final thisRequestId = _currentRequestId;
    final requestTypeTab = typeTab; // Lưu typeTab tại thời điểm request

    state = state.copyWith(isLoading: isRefresh, errorMessage: null);
    try {
      Map<String, dynamic> response = {};
      response = await repository.getDataWithPagination(
        page,
        state.paginationState.itemsPerPage,
        _currentSearchTerm,
        idNhomTaiSan,
        requestTypeTab,
      );

      // Chỉ cập nhật nếu đây là request mới nhất VÀ typeTab vẫn đúng
      if (thisRequestId != _currentRequestId || typeTab != requestTypeTab) {
        log('Skipping stale response: requestId=$thisRequestId, current=$_currentRequestId, tab=$requestTypeTab, currentTab=$typeTab');
        return;
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
      // Chỉ hiển thị lỗi nếu đây là request mới nhất
      if (thisRequestId == _currentRequestId) {
        log('Error loading data AssetManagement: $error');
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Lỗi tải dữ liệu: $error',
        );
      }
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
    // Hủy pending search khi switch tab
    _searchDebounceTimer?.cancel();

    this.typeTab = typeTab;
    log('API URL Tab: $typeTab');
    // Clear search term và reset về page 0 khi switch tab
    _currentSearchTerm = '';
    await loadDataFromApi(
      0, // Reset về page đầu tiên
      _currentIdNhomTaiSan,
      isRefresh,
    );
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  @override
  Future<List<AssetManagementDto>> generateData() async {
    // Không dùng trong API pagination mode
    return [];
  }
}
