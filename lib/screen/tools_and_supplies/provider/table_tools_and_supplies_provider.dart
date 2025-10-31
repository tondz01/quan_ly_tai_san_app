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
    // Check if data actually changed
    if (_data.length != data.length || 
        _data.isEmpty != data.isEmpty ||
        (_data.isNotEmpty && data.isNotEmpty && _data.first.id != data.first.id)) {
      log('TableToolsAndSuppliesProvider.setData - Updating data from ${_data.length} to ${data.length} items');
      _data = List.from(data); // Create new list instance
      
      // Force refresh by calling generateData and updating state directly
      generateData().then((result) {
        state = state.copyWith(
          allData: result,
          filteredData: result,
        );
        log('TableToolsAndSuppliesProvider.setData - State updated with ${result.length} items');
      });
      
      // Also call loadData to ensure table rebuilds
      loadData();
    } else {
      log('TableToolsAndSuppliesProvider.setData - Data unchanged, skipping update');
    }
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<ToolsAndSuppliesDto>> generateData() async {
    try {
      log('TableToolsAndSuppliesProvider.generateData - Returning ${_data.length} items');
      return List.from(_data); // Return a copy to ensure changes are detected
    } catch (e) {
      log('Error in generateData: $e');
      return [];
    }
  }

  Future<void> refreshData() async {
    log('TableToolsAndSuppliesProvider.refreshData - Refreshing data');
    // Force data reload by calling loadData or similar method from parent
    // The parent TableNotifier should handle state updates when generateData is called
    await loadData();
    log('TableToolsAndSuppliesProvider.refreshData - Data reloaded');
  }
}
