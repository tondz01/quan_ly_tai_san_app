import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableTypeCcdcProvider với tối ưu performance
final tableTypeCcdcProvider = StateNotifierProvider.autoDispose<
  TableTypeCcdcProvider,
  GenericTableState<TypeCcdc>
>((ref) => TableTypeCcdcProvider());

class TableTypeCcdcProvider extends TableNotifier<TypeCcdc> {
  List<TypeCcdc> _data = [];

  /// Set data từ widget level
  void setData(List<TypeCcdc> data) {
    _data = data;
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<TypeCcdc>> generateData() async {
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
