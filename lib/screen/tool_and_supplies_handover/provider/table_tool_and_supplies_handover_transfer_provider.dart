import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableToolAndSuppliesHandoverTransferProvider = StateNotifierProvider.autoDispose<
    TableToolAndSuppliesHandoverTransferProvider,
    GenericTableState<ToolAndMaterialTransferDto>>(
    (ref) => TableToolAndSuppliesHandoverTransferProvider());

class TableToolAndSuppliesHandoverTransferProvider extends TableNotifier<ToolAndMaterialTransferDto> {
  List<ToolAndMaterialTransferDto> _data = [];

  void setData(List<ToolAndMaterialTransferDto> data) {
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
  Future<List<ToolAndMaterialTransferDto>> generateData() async {
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

