import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableDepartmentProvider với tối ưu performance
final tableDepartmentProvider = StateNotifierProvider.autoDispose<
  TableDepartmentProvider,
  GenericTableState<PhongBan>
>((ref) => TableDepartmentProvider());

class TableDepartmentProvider extends TableNotifier<PhongBan> {
  List<PhongBan> _data = [];

  /// Set data từ widget level
  void setData(List<PhongBan> data) {
    _data = data;
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<PhongBan>> generateData() async {
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
