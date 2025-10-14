import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableRoleProvider với tối ưu performance
final tableRoleProvider = StateNotifierProvider.autoDispose<
  TableRoleProvider,
  GenericTableState<ChucVu>
>((ref) => TableRoleProvider());

class TableRoleProvider extends TableNotifier<ChucVu> {
  List<ChucVu> _data = [];

  /// Set data từ widget level
  void setData(List<ChucVu> data) {
    _data = data;
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<ChucVu>> generateData() async {
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
