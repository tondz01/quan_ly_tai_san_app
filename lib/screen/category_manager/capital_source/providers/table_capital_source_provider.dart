import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableCapitalSourceProvider với tối ưu performance
final tableCapitalSourceProvider = StateNotifierProvider.autoDispose<
  TableCapitalSourceProvider,
  GenericTableState<NguonKinhPhi>
>((ref) => TableCapitalSourceProvider());

class TableCapitalSourceProvider extends TableNotifier<NguonKinhPhi> {
  List<NguonKinhPhi> _data = [];

  /// Set data từ widget level
  void setData(List<NguonKinhPhi> data) {
    _data = data;
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<NguonKinhPhi>> generateData() async {
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
