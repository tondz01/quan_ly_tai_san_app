import 'dart:developer';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableUnitProvider = StateNotifierProvider.autoDispose<
  TableUnitProvider,
  GenericTableState<UnitDto>
>((ref) => TableUnitProvider());

class TableUnitProvider extends TableNotifier<UnitDto> {
  List<UnitDto> _data = [];

  void setData(List<UnitDto> data) {
    _data = data;
    refreshData();
  }

  set searchTerm(String value) {
    log('searchTerm: $value');
    search(value);
  }

  @override
  Future<List<UnitDto>> generateData() async {
    try {
      log('generateData called with ${_data.length} items');
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
