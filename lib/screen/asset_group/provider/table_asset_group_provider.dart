import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableAssetGroupProvider với tối ưu performance
final tableAssetGroupProvider = StateNotifierProvider.autoDispose<
  TableAssetGroupProvider,
  GenericTableState<AssetGroupDto>
>((ref) => TableAssetGroupProvider());

class TableAssetGroupProvider extends TableNotifier<AssetGroupDto> {
  List<AssetGroupDto> _data = [];

  /// Set data từ widget level
  void setData(List<AssetGroupDto> data) {
    _data = data;
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<AssetGroupDto>> generateData() async {
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
