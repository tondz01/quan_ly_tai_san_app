import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableAssetHandoverProvider
final tableAssetHandoverProvider = StateNotifierProvider.autoDispose<
  TableAssetHandoverProvider,
  GenericTableState<AssetHandoverDto>
>((ref) => TableAssetHandoverProvider());

class TableAssetHandoverProvider extends TableNotifier<AssetHandoverDto> {
  List<AssetHandoverDto> _data = [];

  /// Set data từ widget level
  void setData(List<AssetHandoverDto> data) {
    _data = data;
    // Force refresh by calling generateData directly
    generateData().then((result) {
      state = state.copyWith(
        allData: result,
        filteredData: result,
      );
    });
    loadData();
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<AssetHandoverDto>> generateData() async {
    try {
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
