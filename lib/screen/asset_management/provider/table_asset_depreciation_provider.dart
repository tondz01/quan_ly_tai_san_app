import 'dart:developer';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_depreciation_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableAssetDepreciationProvider = StateNotifierProvider.autoDispose<
  TableAssetDepreciationProvider,
  GenericTableState<AssetDepreciationDto>
>((ref) => TableAssetDepreciationProvider());

class TableAssetDepreciationProvider extends TableNotifier<AssetDepreciationDto> {
  List<AssetDepreciationDto> _data = [];

  void setData(List<AssetDepreciationDto> data) {
    _data = data;
    refreshData();
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<AssetDepreciationDto>> generateData() async {
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
