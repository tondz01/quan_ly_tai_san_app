import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableReasonIncreaseProvider với tối ưu performance
final tableReasonIncreaseProvider = StateNotifierProvider.autoDispose<
  TableReasonIncreaseProvider,
  GenericTableState<ReasonIncrease>
>((ref) => TableReasonIncreaseProvider());

class TableReasonIncreaseProvider extends TableNotifier<ReasonIncrease> {
  List<ReasonIncrease> _data = [];

  /// Set data từ widget level
  void setData(List<ReasonIncrease> data) {
    _data = data;
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<ReasonIncrease>> generateData() async {
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
