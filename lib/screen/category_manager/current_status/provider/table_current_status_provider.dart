import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/model/current_status.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableCurrentStatusProvider với tối ưu performance
final tableCurrentStatusProvider = StateNotifierProvider.autoDispose<
  TableCurrentStatusProvider,
  GenericTableState<CurrentStatus>
>((ref) => TableCurrentStatusProvider());

class TableCurrentStatusProvider extends TableNotifier<CurrentStatus> {
  List<CurrentStatus> _data = [];

  /// Set data từ widget level
  void setData(List<CurrentStatus> data) {
    _data = data;
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<CurrentStatus>> generateData() async {
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
