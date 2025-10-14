import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableProjectProvider với tối ưu performance
final tableProjectProvider = StateNotifierProvider.autoDispose<
  TableProjectProvider,
  GenericTableState<DuAn>
>((ref) => TableProjectProvider());

class TableProjectProvider extends TableNotifier<DuAn> {
  List<DuAn> _data = [];

  /// Set data từ widget level
  void setData(List<DuAn> data) {
    _data = data;
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<DuAn>> generateData() async {
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
