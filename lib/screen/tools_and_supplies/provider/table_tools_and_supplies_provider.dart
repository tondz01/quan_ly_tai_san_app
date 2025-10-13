import 'dart:developer';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableToolsAndSuppliesProvider = StateNotifierProvider.autoDispose<
  TableToolsAndSuppliesProvider,
  GenericTableState<ToolsAndSuppliesDto>
>((ref) => TableToolsAndSuppliesProvider());

class TableToolsAndSuppliesProvider extends TableNotifier<ToolsAndSuppliesDto> {
  List<ToolsAndSuppliesDto> _data = [];

  void setData(List<ToolsAndSuppliesDto> data) {
    _data = data;
    refreshData();
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<ToolsAndSuppliesDto>> generateData() async {
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
