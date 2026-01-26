// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';

// FIXED: Provider nhận repository từ ref
final tableToolAndMaterialTransferProvider = StateNotifierProvider.autoDispose<
  TableToolAndMaterialTransferProvider,
  GenericTableState<ToolAndMaterialTransferDto>
>((ref) {
  // Inject repository vào đây
  final repository = ToolAndMaterialTransferRepository();
  return TableToolAndMaterialTransferProvider(repository);
});

/// Helper class để lấy các giá trị total
/// Sử dụng: ref.read(tableAssetTransferProvider.notifier).getTotals()
extension TableToolAndMaterialTransferTotals
    on TableToolAndMaterialTransferProvider {
  /// Lấy tất cả các totals dưới dạng Map
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

class TableToolAndMaterialTransferProvider
    extends TableNotifier<ToolAndMaterialTransferDto> {
  final ToolAndMaterialTransferRepository repository;

  // Tổng theo API
  int totalItems = 0;
  int totalAll = 0;
  int totalDraft = 0;
  int totalApprove = 0;
  int totalCancel = 0;
  int totalComplete = 0;

  // Trạng thái filter/search hiện tại
  String _currentSearchTerm = '';
  int _currentType = 1; // lưu type hiện tại
  int _currentTrangThai = -1; // lưu trạng thái hiện tại
  static const int ALL = -1;

  // Lưu dữ liệu gốc của page hiện tại (chưa filter offline)
  List<ToolAndMaterialTransferDto> _rawPageData = [];

  // Lưu valueGetter để filter offline
  dynamic Function(ToolAndMaterialTransferDto item, int columnIndex)?
  _localValueGetter;

  // === CHỐNG GỌI API LIÊN TỤC ===
  bool _isApiLoading = false; // Flag đang gọi API
  DateTime? _lastApiCallTime; // Thời gian gọi API lần cuối
  static const _apiDebounceMs = 300; // Debounce 300ms

  TableToolAndMaterialTransferProvider(this.repository);

  // FIXED: Signature đúng với named parameters
  @override
  void initialize({
    required Map<String, double> columnWidths,
    required dynamic Function(ToolAndMaterialTransferDto item, int columnIndex)
    valueGetter,
    int itemsPerPage = 20,
  }) {
    // Lưu lại valueGetter để dùng cho filter offline
    _localValueGetter = valueGetter;

    super.initialize(
      columnWidths: columnWidths,
      valueGetter: valueGetter,
      itemsPerPage: itemsPerPage,
    );

    // Bật API pagination
    enableApiPagination(true);
    loadDataFromApi(0, _currentType, _currentTrangThai);
  }

  // Tìm kiếm với API
  set searchTerm(String value) {
    _currentSearchTerm = value;

    if (state.paginationState.useApiPagination) {
      // API mode: luôn gọi lại API từ trang 0
      loadDataFromApi(0, _currentType, _currentTrangThai);
    } else {
      // Local mode (nếu sau này bỏ API pagination)
      search(value);
    }
  }

  // Load dữ liệu từ API cho 1 page (KHÔNG liên quan tới filter offline)
  Future<void> loadDataFromApi(
    int page,
    int type,
    int trangThai, [
    bool isLoading = true,
  ]) async {
    // === CHỐNG GỌI API LIÊN TỤC ===
    // Nếu đang gọi API thì bỏ qua
    if (_isApiLoading) {
      log(
        'loadDataFromApi ToolAndMaterialTransfer: SKIPPED - API đang loading',
      );
      return;
    }

    // Debounce: bỏ qua nếu gọi quá nhanh (< 300ms)
    final now = DateTime.now();
    if (_lastApiCallTime != null) {
      final diff = now.difference(_lastApiCallTime!).inMilliseconds;
      if (diff < _apiDebounceMs) {
        log(
          'loadDataFromApi ToolAndMaterialTransfer: SKIPPED - debounce ($diff ms < $_apiDebounceMs ms)',
        );
        return;
      }
    }

    _isApiLoading = true;
    _lastApiCallTime = now;

    _currentType = type; // cập nhật type
    _currentTrangThai = trangThai; // cập nhật trạng thái

    // Set loading cho API call
    if (isLoading) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    } else {
      state = state.copyWith(errorMessage: null);
    }

    try {
      // Gọi API
      final response = await repository.getDataWithPagination(
        page,
        state.paginationState.itemsPerPage,
        _currentType,
        _currentSearchTerm,
        _currentTrangThai,
      );

      final data =
          (response['data'] as List<dynamic>)
              .cast<ToolAndMaterialTransferDto>();

      // Lưu dữ liệu gốc của page này để filter offline
      _rawPageData = List<ToolAndMaterialTransferDto>.from(data);

      // Nếu API trả về rỗng -> cập nhật meta nhưng clear dữ liệu cũ trên UI
      if (data.isEmpty) {
        log('TableToolAndMaterialTransferProvider: API returned EMPTY data');
        setApiData(
          data,
          totalPages: response['totalPages'] as int?,
          currentPage: response['currentPage'] as int?,
          totalItems: response['totalItems'] as int?,
        );

        _rawPageData = <ToolAndMaterialTransferDto>[];
        Future.microtask(() {
          state = state.copyWith(
            currentPageData: <ToolAndMaterialTransferDto>[],
            isLoading: false,
            errorMessage: null,
          );
          log(
            'Cleared currentPageData after empty response (ToolAndMaterialTransfer)',
          );
        });
      } else {
        // Cập nhật data và pagination info
        setApiData(
          data,
          totalPages: response['totalPages'] as int?,
          currentPage: response['currentPage'] as int?,
          totalItems: response['totalItems'] as int?,
        );
      }
      if (trangThai == ALL) {
        totalItems = response['totalItems'] as int? ?? 0;
        totalAll = response['totalAll'] as int? ?? 0;
        totalDraft = response['totalDraft'] as int? ?? 0;
        totalApprove = response['totalApprove'] as int? ?? 0;
        totalCancel = response['totalCancel'] as int? ?? 0;
        totalComplete = response['totalComplete'] as int? ?? 0;
      }

      // Nếu đang có filter offline active → áp lại trên dữ liệu mới
      if (state.filterState.hasActiveFilters) {
        _reapplyOfflineFilters();
      } else {
        // Nếu không có filter thì tắt loading luôn
        state = state.copyWith(isLoading: false);
      }
    } catch (error) {
      log('Lỗi khi tải dữ liệu ToolAndMaterialTransfer từ API: $error');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Lỗi tải dữ liệu: $error',
        currentPageData: [],
      );
    } finally {
      _isApiLoading = false; // Reset flag sau khi hoàn thành
    }
  }

  Future<void> fillterByStatus(int status) async {
    _currentTrangThai = status;
    await loadDataFromApi(0, _currentType, _currentTrangThai);
  }

  // Tự động gọi API khi chuyển trang
  @override
  void goToPage(int page) {
    super.goToPage(page);

    if (state.paginationState.useApiPagination) {
      loadDataFromApi(page, _currentType, _currentTrangThai);
    }
  }

  // Refresh dữ liệu trang hiện tại (giữ filter offline nếu có)
  Future<void> refreshData(
    int type,
    int trangThai, [
    bool isLoading = true,
  ]) async {
    _currentType = type;
    _currentTrangThai = trangThai;
    await loadDataFromApi(
      state.paginationState.currentDisplayPage,
      _currentType,
      _currentTrangThai,
      isLoading,
    );
  }

  // ================== FILTER OFFLINE TRÊN PAGE HIỆN TẠI ==================

  // Ghi đè applyColumnFilter: nếu đang dùng API pagination → filter offline
  @override
  void applyColumnFilter(int columnIndex, ColumnFilter filter) {
    // Cập nhật map filters
    final newFilters = Map<int, ColumnFilter>.from(
      state.filterState.columnFilters,
    );
    newFilters[columnIndex] = filter;
    final hasActiveFilters = newFilters.isNotEmpty;

    state = state.copyWith(
      filterState: state.filterState.copyWith(
        columnFilters: newFilters,
        hasActiveFilters: hasActiveFilters,
      ),
    );

    if (state.paginationState.useApiPagination) {
      // API mode: filter OFFLINE trên dữ liệu của page hiện tại (_rawPageData),
      // KHÔNG gọi API, KHÔNG đổi page.
      _applyOfflineFilters(newFilters);
    } else {
      // Local mode: dùng logic mặc định của TableNotifier
      super.applyColumnFilter(columnIndex, filter);
    }
  }

  @override
  void clearColumnFilter(int columnIndex) {
    final newFilters = Map<int, ColumnFilter>.from(
      state.filterState.columnFilters,
    );
    newFilters.remove(columnIndex);
    final hasActiveFilters = newFilters.isNotEmpty;

    state = state.copyWith(
      filterState: state.filterState.copyWith(
        columnFilters: newFilters,
        hasActiveFilters: hasActiveFilters,
      ),
    );

    if (state.paginationState.useApiPagination) {
      _applyOfflineFilters(newFilters);
    } else {
      super.clearColumnFilter(columnIndex);
    }
  }

  @override
  void clearAllFilters() {
    state = state.copyWith(filterState: const TableFilterState());

    if (state.paginationState.useApiPagination) {
      // Clear hết: trả về dữ liệu gốc của page hiện tại
      state = state.copyWith(
        currentPageData: List<ToolAndMaterialTransferDto>.from(_rawPageData),
        isLoading: false,
      );
    } else {
      super.clearAllFilters();
    }
  }

  // Áp lại filter offline khi vừa gọi API xong (nếu đang có filter active)
  void _reapplyOfflineFilters() {
    final filters = state.filterState.columnFilters;
    if (filters.isEmpty) {
      state = state.copyWith(
        currentPageData: List<ToolAndMaterialTransferDto>.from(_rawPageData),
        isLoading: false,
      );
      return;
    }
    _applyOfflineFilters(filters);
  }

  // Thực hiện filter offline trên _rawPageData với danh sách filters
  void _applyOfflineFilters(Map<int, ColumnFilter> filters) {
    if (_localValueGetter == null) {
      state = state.copyWith(
        currentPageData: List<ToolAndMaterialTransferDto>.from(_rawPageData),
        isLoading: false,
      );
      return;
    }

    List<ToolAndMaterialTransferDto> filtered =
        List<ToolAndMaterialTransferDto>.from(_rawPageData);

    for (final filter in filters.values) {
      filtered = _filterDataByColumn(filtered, filter);
    }

    state = state.copyWith(
      currentPageData: filtered,
      // isLoading = false vì đây là filter offline
      isLoading: false,
    );
  }

  List<ToolAndMaterialTransferDto> _filterDataByColumn(
    List<ToolAndMaterialTransferDto> data,
    ColumnFilter filter,
  ) {
    return data.where((item) {
      final value = _localValueGetter!(item, filter.columnIndex);
      return _evaluateFilterCondition(value, filter);
    }).toList();
  }

  bool _evaluateFilterCondition(dynamic value, ColumnFilter filter) {
    // Filter select (chọn danh sách giá trị)
    if (filter.filterType == FilterType.select) {
      return filter.selectedValues.contains(value);
    }

    // Filter số [min, max]
    if (filter.filterType == FilterType.number) {
      double? start = filter.minNumberValue;
      double? end = filter.maxNumberValue;

      double? cur;
      if (value is num) {
        cur = value.toDouble();
      } else if (value is String) {
        cur = double.tryParse(value.replaceAll(RegExp(r'[^0-9.-]'), ''));
      }

      if (cur == null) return false;

      if (start != null && end != null) {
        return cur >= start && cur <= end;
      } else if (start != null) {
        return cur >= start;
      } else if (end != null) {
        return cur <= end;
      }
      return true;
    }

    // Filter theo khoảng ngày
    if (filter.filterType == FilterType.date) {
      DateTime? start = filter.startDateValue;
      DateTime? end = filter.endDateValue;

      if (value is! DateTime) return false;
      final current = value;

      if (start != null && end != null) {
        return !current.isBefore(start) && !current.isAfter(end);
      }
      if (start != null) return !current.isBefore(start);
      if (end != null) return !current.isAfter(end);
      return true;
    }

    // Không khớp loại filter nào
    return false;
  }

  @override
  Future<List<ToolAndMaterialTransferDto>> generateData() async {
    // Không dùng trong API pagination mode
    return [];
  }
}
