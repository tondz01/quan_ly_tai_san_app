import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho TableCcdcGroupProvider với tối ưu performance
final tableAssetTransferProvider = StateNotifierProvider.autoDispose<
  TableAssetTransferProvider,
  GenericTableState<DieuDongTaiSanDto>
>((ref) => TableAssetTransferProvider());

class TableAssetTransferProvider extends TableNotifier<DieuDongTaiSanDto> {
  List<DieuDongTaiSanDto> _data = [];

  /// Set data từ widget level
  void setData(List<DieuDongTaiSanDto> data) {
    _data = data;
    // Force refresh by calling generateData directly
    generateData().then((result) {
      state = state.copyWith(
        allData: result,
        filteredData: result,
      );
    });
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<DieuDongTaiSanDto>> generateData() async {
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
