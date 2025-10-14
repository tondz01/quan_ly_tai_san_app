import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';

final tableToolAndSuppliesHandoverProvider = StateNotifierProvider.autoDispose<
  TableToolAndSuppliesHandoverProvider,
  GenericTableState<ToolAndSuppliesHandoverDto>
>((ref) => TableToolAndSuppliesHandoverProvider());

class TableToolAndSuppliesHandoverProvider extends TableNotifier<ToolAndSuppliesHandoverDto> {
  List<ToolAndSuppliesHandoverDto> _data = [];

  void setData(List<ToolAndSuppliesHandoverDto> data) {
    _data = data;
    generateData().then((result) {
      state = state.copyWith(
        allData: result,
        filteredData: result,
      );
    });
    loadData();
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<ToolAndSuppliesHandoverDto>> generateData() async {
    try {
      return _data;
    } catch (e) {
      log('Error in generateData: $e');
      return [];
    }
  }

  Future<void> refreshData() async {
    await generateData();
  }
}
