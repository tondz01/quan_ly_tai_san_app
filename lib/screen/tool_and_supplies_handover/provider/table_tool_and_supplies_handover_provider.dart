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
  int totalItems = 0;
  String _currentSearchTerm = '';
  int _currentTrangThai = -1;
  int totalAll = 0;
  int totalDraft = 0;
  int totalApprove = 0;
  int totalCancel = 0;
  int totalComplete = 0;

  TableToolAndSuppliesHandoverProvider(this.repository);

  @override
  void initialize({
    required Map<String, double> columnWidths,
    required dynamic Function(ToolAndSuppliesHandoverDto item, int columnIndex)
        valueGetter,
    int itemsPerPage = 20,
  }) {
    super.initialize(
      columnWidths: columnWidths,
      valueGetter: valueGetter,
      itemsPerPage: itemsPerPage,
    );
    enableApiPagination(true);
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
    log(
      'loadDataFromApi ToolAndSuppliesHandover: page=$page -- trangThai=$trangThai -- isRefresh=$isRefresh',
    );
    _currentTrangThai = trangThai;

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
      log('Error loading ToolAndSupplies Handover data: $error');
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
  Future<List<ToolAndSuppliesHandoverDto>> generateData() async {
    return [];
  }
}
