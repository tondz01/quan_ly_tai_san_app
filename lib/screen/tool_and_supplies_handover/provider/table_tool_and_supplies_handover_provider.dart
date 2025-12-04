import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';

final tableToolAndSuppliesHandoverProvider = StateNotifierProvider.autoDispose<
  TableToolAndSuppliesHandoverProvider,
  GenericTableState<ToolAndSuppliesHandoverDto>
>((ref) {
  final repository = ToolAndSuppliesHandoverRepository();
  return TableToolAndSuppliesHandoverProvider(repository);
});

extension TableToolAndSuppliesHandoverTotals
    on TableToolAndSuppliesHandoverProvider {
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

class TableToolAndSuppliesHandoverProvider
    extends TableNotifier<ToolAndSuppliesHandoverDto> {
  final ToolAndSuppliesHandoverRepository repository;

  // Tổng theo API
  int totalItems = 0;
  int totalAll = 0;
  int totalDraft = 0;
  int totalApprove = 0;
  int totalCancel = 0;
  int totalComplete = 0;

  // Trạng thái filter/search hiện tại
  String _currentSearchTerm = '';
  int _currentTrangThai = -1;

  // Lưu dữ liệu gốc của page hiện tại (chưa filter offline)
  List<ToolAndSuppliesHandoverDto> _rawPageData = [];

  // Lưu valueGetter để filter offline
  dynamic Function(ToolAndSuppliesHandoverDto item, int columnIndex)?
  _localValueGetter;

  TableToolAndSuppliesHandoverProvider(this.repository);

  @override
  void initialize({
    required Map<String, double> columnWidths,
    required dynamic Function(ToolAndSuppliesHandoverDto item, int columnIndex)
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

    // Bật chế độ phân trang API
    enableApiPagination(true);

    // Load trang đầu tiên
    loadDataFromApi(0, _currentTrangThai);
  }

  // Tìm kiếm
  set searchTerm(String value) {
    _currentSearchTerm = value;

    if (state.paginationState.useApiPagination) {
      // API mode: gọi lại API từ trang 0
      loadDataFromApi(0, _currentTrangThai);
    } else {
      // Local mode
      search(value);
    }
  }

  // CALL API lấy dữ liệu cho 1 page (KHÔNG liên quan tới filter offline)
  Future<void> loadDataFromApi(
    int page,
    int trangThai, [
    bool isRefresh = true,
  ]) async {
    log(
      'loadDataFromApi ToolAndSuppliesHandover: page=$page -- trangThai=$trangThai -- isRefresh=$isRefresh',
    );
    _currentTrangThai = trangThai;

    // Set loading cho API call
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await repository.getDataWithPagination(
        page,
        state.paginationState.itemsPerPage,
        _currentSearchTerm,
        _currentTrangThai,
      );

      final data =
          (response['data'] as List<dynamic>)
              .cast<ToolAndSuppliesHandoverDto>();

      // Lưu dữ liệu gốc của page này để filter offline
      _rawPageData = List<ToolAndSuppliesHandoverDto>.from(data);

      // Set data + thông tin phân trang từ API
      setApiData(
        data,
        totalPages: (response['totalPages'] is int) 
            ? response['totalPages'] as int? 
            : int.tryParse(response['totalPages']?.toString() ?? '0'),
        currentPage: (response['currentPage'] is int) 
            ? response['currentPage'] as int? 
            : int.tryParse(response['currentPage']?.toString() ?? '0'),
        totalItems: (response['totalItems'] is int) 
            ? response['totalItems'] as int? 
            : int.tryParse(response['totalItems']?.toString() ?? '0'),
      );

      totalItems = response['totalItems'] as int? ?? 0;
      totalAll = response['totalAll'] as int? ?? 0;
      totalDraft = response['totalDraft'] as int? ?? 0;
      totalApprove = response['totalApprove'] as int? ?? 0;
      totalCancel = response['totalCancel'] as int? ?? 0;
      totalComplete = response['totalComplete'] as int? ?? 0;

      // Nếu đang có filter offline active → áp lại trên dữ liệu mới
      if (state.filterState.hasActiveFilters) {
        _reapplyOfflineFilters();
      }
    } catch (error) {
      log('Error loading ToolAndSupplies Handover data: $error');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Lỗi tải dữ liệu: $error',
        currentPageData: [],
      );
    }
  }

  // Phân trang: chỉ dùng API cho chuyển trang, KHÔNG dùng cho filter offline
  @override
  void goToPage(int page) {
    super.goToPage(page);

    if (state.paginationState.useApiPagination) {
      loadDataFromApi(page, _currentTrangThai);
    }
  }

  // Refresh lại dữ liệu trang hiện tại (giữ filter offline nếu có)
  Future<void> refreshData([bool isRefresh = true]) async {
    await loadDataFromApi(
      state.paginationState.currentDisplayPage,
      _currentTrangThai,
      isRefresh,
    );
  }

  // Lọc theo trạng thái (gọi API)
  Future<void> filterByStatus(int status) async {
    _currentTrangThai = status;
    await loadDataFromApi(0, _currentTrangThai);
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
        currentPageData: List<ToolAndSuppliesHandoverDto>.from(_rawPageData),
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
        currentPageData: List<ToolAndSuppliesHandoverDto>.from(_rawPageData),
      );
      return;
    }
    _applyOfflineFilters(filters);
  }

  // Thực hiện filter offline trên _rawPageData với danh sách filters
  void _applyOfflineFilters(Map<int, ColumnFilter> filters) {
    if (_localValueGetter == null) {
      state = state.copyWith(
        currentPageData: List<ToolAndSuppliesHandoverDto>.from(_rawPageData),
      );
      return;
    }

    List<ToolAndSuppliesHandoverDto> filtered =
        List<ToolAndSuppliesHandoverDto>.from(_rawPageData);

    for (final filter in filters.values) {
      filtered = _filterDataByColumn(filtered, filter);
    }

    state = state.copyWith(
      currentPageData: filtered,
      // isLoading = false vì đây là filter offline
      isLoading: false,
    );
  }

  List<ToolAndSuppliesHandoverDto> _filterDataByColumn(
    List<ToolAndSuppliesHandoverDto> data,
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

  // Local mode: nếu sau này muốn bỏ API pagination
  void setLocalData(List<ToolAndSuppliesHandoverDto> data) {
    enableApiPagination(false);
    loadData(data);
  }

  @override
  Future<List<ToolAndSuppliesHandoverDto>> generateData() async {
    // Không dùng trong API mode
    return [];
  }
}
