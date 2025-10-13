import 'dart:developer';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableAssetManagementProvider = StateNotifierProvider.autoDispose<
  TableAssetManagementProvider,
  GenericTableState<AssetManagementDto>
>((ref) => TableAssetManagementProvider());

class TableAssetManagementProvider extends TableNotifier<AssetManagementDto> {
  List<AssetManagementDto> _data = [];

  void setData(List<AssetManagementDto> data) {
    _data = data;
    refreshData();
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<AssetManagementDto>> generateData() async {
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
