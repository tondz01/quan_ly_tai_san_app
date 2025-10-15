import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';

final tableToolAndMaterialTransferProvider = StateNotifierProvider.autoDispose<
  TableToolAndMaterialTransferProvider,
  GenericTableState<ToolAndMaterialTransferDto>
>((ref) => TableToolAndMaterialTransferProvider());

class TableToolAndMaterialTransferProvider
    extends TableNotifier<ToolAndMaterialTransferDto> {
  List<ToolAndMaterialTransferDto> _data = [];

  void setData(List<ToolAndMaterialTransferDto> data) {
    _data = data;
    refreshData();
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
