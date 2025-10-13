import 'dart:developer';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:table_base/widgets/table/providers/table_notifier.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableStaffProvider = StateNotifierProvider.autoDispose<
  TableStaffProvider,
  GenericTableState<NhanVien>
>((ref) => TableStaffProvider());

class TableStaffProvider extends TableNotifier<NhanVien> {
  List<NhanVien> _data = [];

  void setData(List<NhanVien> data) {
    _data = data;
    refreshData();
  }

  set searchTerm(String value) {
    search(value);
  }

  @override
  Future<List<NhanVien>> generateData() async {
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
