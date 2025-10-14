import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableAssetTransferByHandoverProvider = StateNotifierProvider.autoDispose<
    TableAssetTransferByHandoverProvider,
    GenericTableState<DieuDongTaiSanDto>>(
    (ref) => TableAssetTransferByHandoverProvider());

class TableAssetTransferByHandoverProvider extends TableNotifier<DieuDongTaiSanDto> {
  List<DieuDongTaiSanDto> _data = [];

  void setData(List<DieuDongTaiSanDto> data) {
    _data = data;
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
