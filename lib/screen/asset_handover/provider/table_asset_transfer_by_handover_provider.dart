import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableCcdcGroupProvider với tối ưu performance
final tableAssetTransferByHandoverProvider = StateNotifierProvider.autoDispose<
  TableAssetTransferByHandoverProvider,
  GenericTableState<DieuDongTaiSanDto>
>((ref) {
  final repository = AssetTransferRepository();
  return TableAssetTransferByHandoverProvider(repository);
});

/// Helper class để lấy các giá trị total
/// Sử dụng: ref.read(TableAssetTransferByHandoverProvider.notifier).getTotals()
extension TableAssetTransferTotals on TableAssetTransferByHandoverProvider {
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

class TableAssetTransferByHandoverProvider
    extends TableNotifier<DieuDongTaiSanDto> {
  final AssetTransferRepository repository;

  // Tổng theo API
  int totalItems = 0;
  int totalAll = 0;
  int totalCP = 0;
  int totalDC = 0;
  int totalTH = 0;

  // Trạng thái filter/search hiện tại
  String _currentSearchTerm = '';
  int _currentType = 3; // lưu type hiện tại

  // Lưu dữ liệu gốc của page hiện tại (chưa filter offline)
  List<DieuDongTaiSanDto> _rawPageData = [];

  // Lưu valueGetter để filter offline
  dynamic Function(DieuDongTaiSanDto item, int columnIndex)? _localValueGetter;

  // Flag kiểm tra provider đã dispose chưa
  bool _isDisposed = false;

  // === CHỐNG GỌI API LIÊN TỤC ===
  bool _isApiLoading = false; // Flag đang gọi API
  DateTime? _lastApiCallTime; // Thời gian gọi API lần cuối
  static const _apiDebounceMs = 300; // Debounce 300ms

  TableAssetTransferByHandoverProvider(this.repository);

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Safe state update - chỉ update nếu chưa dispose và delay nếu đang build
  /// Safe state update - chỉ update nếu chưa dispose và delay nếu đang build
  ///
  /// Accepts either a `GenericTableState` snapshot OR an updater function
  /// `GenericTableState Function(GenericTableState)` which will be applied
  /// to the current `state` inside the microtask. Using an updater avoids
  /// the bug where a previously-captured snapshot overwrites newer state.
  void _safeUpdateState(dynamic newStateOrUpdater) {
    if (_isDisposed) return;

    // Delay update để tránh lỗi "modify provider while widget tree is building"
    Future.microtask(() {
      if (_isDisposed) return;

      if (newStateOrUpdater is Function) {
        try {
          state = newStateOrUpdater(state);
        } catch (e) {
          // If updater fails, don't crash provider - log and skip
          log('Error applying state updater in _safeUpdateState: $e');
        }
      } else if (newStateOrUpdater is GenericTableState<DieuDongTaiSanDto>) {
        state = newStateOrUpdater;
      } else {
        log('Unsupported argument passed to _safeUpdateState');
      }
    });
  }

  // FIXED: Signature đúng với named parameters
  @override
  void initialize({
    required Map<String, double> columnWidths,
    required dynamic Function(DieuDongTaiSanDto item, int columnIndex)
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
    loadDataFromApi(0, _currentType);
  }

  // Tìm kiếm với API
  set searchTerm(String value) {
    _currentSearchTerm = value;

    if (state.paginationState.useApiPagination) {
      // API mode: luôn gọi lại API từ trang 0
      loadDataFromApi(0, _currentType);
    } else {
      // Local mode (nếu sau này bỏ API pagination)
      search(value);
    }
  }

  // Load dữ liệu từ API cho 1 page (KHÔNG liên quan tới filter offline)
  Future<void> loadDataFromApi(
    int page,
    int type, [
    bool isRefresh = true,
  ]) async {
    // Kiểm tra đã dispose chưa trước khi bắt đầu
    if (_isDisposed) return;

    // === CHỐNG GỌI API LIÊN TỤC ===
    // Nếu đang gọi API thì bỏ qua
    if (_isApiLoading) {
      log('loadDataFromApi AssetTransfer: SKIPPED - API đang loading');
      return;
    }

    // Debounce: bỏ qua nếu gọi quá nhanh (< 300ms)
    final now = DateTime.now();
    if (_lastApiCallTime != null) {
      final diff = now.difference(_lastApiCallTime!).inMilliseconds;
      if (diff < _apiDebounceMs) {
        log(
          'loadDataFromApi AssetTransfer: SKIPPED - debounce ($diff ms < $_apiDebounceMs ms)',
        );
        return;
      }
    }

    _isApiLoading = true;
    _lastApiCallTime = now;

    log(
      'loadDataFromApi AssetTransfer: page=$page -- type=$type -- isRefresh=$isRefresh',
    );

    _currentType = type; // cập nhật type
    UserInfoDTO userInfo =
        AccountHelper.instance.getUserInfo() ?? UserInfoDTO.empty();
    NhanVien? nhanVien = AccountHelper.instance.getNhanVienById( 
      userInfo.tenDangNhap,
    );
    String? idDepartment = '';
    if (userInfo.tenDangNhap != 'admin') {
      idDepartment = nhanVien?.phongBanId ?? nhanVien?.boPhan ?? '';
      log('idDepartment: $idDepartment');
    }

    // Set loading cho API call
    if (isRefresh) {
      _safeUpdateState((s) => s.copyWith(isLoading: true, errorMessage: null));
    } else {
      _safeUpdateState((s) => s.copyWith(errorMessage: null));
    }

    try {
      final response = await repository.getDataPageByBanGiao(
        page,
        state.paginationState.itemsPerPage,
        _currentType,
        _currentSearchTerm,
        idDepartment
      );

      // Kiểm tra lại sau khi await - provider có thể đã dispose
      if (_isDisposed) return;

      final data =
          (response['data'] as List<dynamic>).cast<DieuDongTaiSanDto>();

      // Lưu dữ liệu gốc của page này để filter offline
      _rawPageData = List<DieuDongTaiSanDto>.from(data);

      // Nếu API trả về null/empty -> đảm bảo xóa dữ liệu cũ
      if (data.isEmpty) {
        log('loadDataFromApi AssetTransfer: API returned empty data - clearing currentPageData');

        // Cập nhật pagination info nhưng clear current page data
        data.clear();
        setApiData(
          data,
          totalPages: response['totalPages'] as int?,
          currentPage: response['currentPage'] as int?,
          totalItems: response['totalItems'] as int?,
        );

        // Force clear currentPageData synchronously so UI won't show stale rows
        state = state.copyWith(
          currentPageData: <DieuDongTaiSanDto>[],
          isLoading: false,
          errorMessage: null,
        );
        log("loadDataFromApi AssetTransfer empty : ${data.isEmpty}");
      } else {
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
        _safeUpdateState((s) => s.copyWith(isLoading: false));
      }
    } catch (error) {
      if (_isDisposed) return;

      _safeUpdateState(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Lỗi tải dữ liệu: $error',
          currentPageData: [],
        ),
      );
    }
    finally {
      _isApiLoading = false; // Reset flag sau khi hoàn thành
    }
  } // Tự động gọi API khi chuyển trang

  @override
  void goToPage(int page) {
    super.goToPage(page);

    if (state.paginationState.useApiPagination) {
      loadDataFromApi(page, _currentType);
    }
  }

  // Refresh dữ liệu
  Future<void> refreshData(int type, [bool isRefresh = true]) async {
    _currentType = type;
    await loadDataFromApi(
      state.paginationState.currentDisplayPage,
      _currentType,
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
    if (_isDisposed) return;

    _safeUpdateState((s) => s.copyWith(filterState: const TableFilterState()));

    if (state.paginationState.useApiPagination) {
      // Clear hết: trả về dữ liệu gốc của page hiện tại
      _safeUpdateState((s) => s.copyWith(
            currentPageData: List<DieuDongTaiSanDto>.from(_rawPageData),
            isLoading: false,
          ));
    } else {
      super.clearAllFilters();
    }
  }

  // Áp lại filter offline khi vừa gọi API xong (nếu đang có filter active)
  void _reapplyOfflineFilters() {
    if (_isDisposed) return;

    final filters = state.filterState.columnFilters;
    if (filters.isEmpty) {
      _safeUpdateState((s) => s.copyWith(
            currentPageData: List<DieuDongTaiSanDto>.from(_rawPageData),
            isLoading: false,
          ));
      return;
    }
    _applyOfflineFilters(filters);
  }

  // Thực hiện filter offline trên _rawPageData với danh sách filters
  void _applyOfflineFilters(Map<int, ColumnFilter> filters) {
    if (_isDisposed) return;

    if (_localValueGetter == null) {
      _safeUpdateState((s) => s.copyWith(
            currentPageData: List<DieuDongTaiSanDto>.from(_rawPageData),
            isLoading: false,
          ));
      return;
    }

    List<DieuDongTaiSanDto> filtered = List<DieuDongTaiSanDto>.from(
      _rawPageData,
    );

    for (final filter in filters.values) {
      filtered = _filterDataByColumn(filtered, filter);
    }

    _safeUpdateState((s) => s.copyWith(
          currentPageData: filtered,
          // isLoading = false vì đây là filter offline
          isLoading: false,
        ));
  }

  List<DieuDongTaiSanDto> _filterDataByColumn(
    List<DieuDongTaiSanDto> data,
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
  Future<List<DieuDongTaiSanDto>> generateData() async {
    // Không dùng trong API pagination mode
    return [];
  }
}
