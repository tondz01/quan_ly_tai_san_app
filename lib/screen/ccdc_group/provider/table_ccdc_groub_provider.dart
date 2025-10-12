import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableCcdcGroupProvider với tối ưu performance
final tableCcdcGroupProvider = StateNotifierProvider.autoDispose<
  TableCcdcGroupProvider,
  GenericTableState<CcdcGroup>
>((ref) => TableCcdcGroupProvider());

class TableCcdcGroupProvider extends TableNotifier<CcdcGroup> {
  List<CcdcGroup> _data = [];

  /// Set data từ widget level
  void setData(List<CcdcGroup> data) {
    _data = data;
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<CcdcGroup>> generateData() async {
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
