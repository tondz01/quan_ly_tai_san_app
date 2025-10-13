import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableTypeAssetProvider với tối ưu performance
final tableTypeAssetProvider = StateNotifierProvider.autoDispose<
  TableTypeAssetProvider,
  GenericTableState<TypeAsset>
>((ref) => TableTypeAssetProvider());

class TableTypeAssetProvider extends TableNotifier<TypeAsset> {
  List<TypeAsset> _data = [];

  /// Set data từ widget level
  void setData(List<TypeAsset> data) {
    _data = data;
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<TypeAsset>> generateData() async {
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
