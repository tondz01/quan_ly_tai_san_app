import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/asset_category/models/asset_category_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableAssetCategoryProvider với tối ưu performance
final tableAssetCategoryProvider = StateNotifierProvider.autoDispose<
  TableAssetCategoryProvider,
  GenericTableState<AssetCategoryDto>
>((ref) => TableAssetCategoryProvider());

class TableAssetCategoryProvider extends TableNotifier<AssetCategoryDto> {
  List<AssetCategoryDto> _data = [];

  /// Set data từ widget level
  void setData(List<AssetCategoryDto> data) {
    _data = data;
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<AssetCategoryDto>> generateData() async {
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
