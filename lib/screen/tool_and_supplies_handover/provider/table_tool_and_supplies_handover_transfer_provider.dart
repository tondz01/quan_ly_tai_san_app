import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';

// FIXED: Provider nhận repository từ ref
final tableToolAndSuppliesHandoverTransferProvider =
    StateNotifierProvider.autoDispose<
      TableToolAndSuppliesHandoverTransferProvider,
      GenericTableState<ToolAndMaterialTransferDto>
    >((ref) {
      // Inject repository vào đây
      final repository = ToolAndMaterialTransferRepository();
      return TableToolAndSuppliesHandoverTransferProvider(repository);
    });

/// Helper class để lấy các giá trị total
/// Sử dụng: ref.read(TableToolAndSuppliesHandoverTransferProvider.notifier).getTotals()
extension TableToolAndSuppliesHandoverTransferTotals
    on TableToolAndSuppliesHandoverTransferProvider {
  /// Lấy tất cả các totals dưới dạng Map
  Map<String, int> getTotals() {
    return {
      'totalAll': totalAll,
      'totalCP': totalCP,
      'totalDC': totalDC,
      'totalTH': totalTH,
    };
  }
}

class TableToolAndSuppliesHandoverTransferProvider
    extends TableNotifier<ToolAndMaterialTransferDto> {
  final ToolAndMaterialTransferRepository repository;

  // Tổng theo API
  int totalItems = 0;
  int totalAll = 0;
  int totalCP = 0;
  int totalDC = 0;
  int totalTH = 0;

  // Trạng thái filter/search hiện tại
  String _currentSearchTerm = '';
  int _currentType = -1; // lưu type hiện tại

  // Lưu dữ liệu gốc của page hiện tại (chưa filter offline)
  List<ToolAndMaterialTransferDto> _rawPageData = [];

  // Lưu valueGetter để filter offline
  dynamic Function(ToolAndMaterialTransferDto item, int columnIndex)?
  _localValueGetter;

  TableToolAndSuppliesHandoverTransferProvider(this.repository);

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
    loadDataFromApi(0, true);
  }

  // Tìm kiếm với API
  set searchTerm(String value) {
    _currentSearchTerm = value;

    if (state.paginationState.useApiPagination) {
      // API mode: luôn gọi lại API từ trang 0
      loadDataFromApi(0);
    } else {
      // Local mode (nếu sau này bỏ API pagination)
      search(value);
    }
  }

  // Load dữ liệu từ API cho 1 page (KHÔNG liên quan tới filter offline)
  Future<void> loadDataFromApi(int page, [bool isLoading = true]) async {
    // Set loading cho API call
    if (isLoading) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    } else {
      state = state.copyWith(errorMessage: null);
    }

    try {
      final userInfo = AccountHelper.instance.getUserInfo();
      final nhanVien = AccountHelper.instance.getNhanVienById(
        userInfo?.tenDangNhap ?? '',
      );
      final idDonViGiao = nhanVien?.phongBanId ?? nhanVien?.boPhan ?? '';
      // Gọi API
      final response = await repository.getDataPageByBanGiao(
        page,
        state.paginationState.itemsPerPage,
        _currentType,
        _currentSearchTerm,
        idDonViGiao,
      );

      final data =
          (response['data'] as List<dynamic>)
              .cast<ToolAndMaterialTransferDto>();

      // Lưu dữ liệu gốc của page này để filter offline
      _rawPageData = List<ToolAndMaterialTransferDto>.from(data);

      // Nếu API trả về rỗng, vẫn cập nhật pagination meta nhưng đảm bảo
      // xóa dữ liệu cũ trên UI để tránh hiển thị stale rows.
      if (data.isEmpty) {
        log('ToolAndSuppliesHandoverTransfer: API returned EMPTY data');

        setApiData(
          data,
          totalPages: response['totalPages'] as int?,
          currentPage: response['currentPage'] as int?,
          totalItems: response['totalItems'] as int?,
        );

        // Clear raw page data explicitly
        _rawPageData = <ToolAndMaterialTransferDto>[];

        Future.microtask(() {
          state = state.copyWith(
            currentPageData: <ToolAndMaterialTransferDto>[],
            isLoading: false,
            errorMessage: null,
          );
          log('Cleared currentPageData after empty response');
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

      totalItems = response['totalItems'] as int? ?? 0;
      totalAll = response['totalAll'] as int? ?? 0;
      totalCP = response['totalCP'] as int? ?? 0;
      totalDC = response['totalDC'] as int? ?? 0;
      totalTH = response['totalTH'] as int? ?? 0;

      // Nếu đang có filter offline active → áp lại trên dữ liệu mới
      if (state.filterState.hasActiveFilters) {
        _reapplyOfflineFilters();
      } else {
        // Nếu không có filter thì tắt loading luôn
        state = state.copyWith(isLoading: false);
      }
    } catch (error) {
      log('Error loading ToolAndMaterialTransfer data: $error');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Lỗi tải dữ liệu: $error',
        currentPageData: [],
      );
    }
  }

  Future<void> fillterByStatus(int status) async {
    await loadDataFromApi(0, true);
  }

  // Tự động gọi API khi chuyển trang
  @override
  void goToPage(int page) {
    super.goToPage(page);

    if (state.paginationState.useApiPagination) {
      loadDataFromApi(page, true);
    }
  }

  // Refresh dữ liệu
  Future<void> refreshData(int type, [bool isRefresh = true]) async {
    _currentType = type;
    await loadDataFromApi(
      state.paginationState.currentDisplayPage,
      isRefresh,
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
