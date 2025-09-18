import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/providers/departments_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/staf_provider.dart/nhan_vien_provider.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'staff_event.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  List<NhanVien> _allStaffs = [];
  List<PhongBan> _allDepartments = [];
  List<ChucVu> _allChucvus = [];
  final NhanVienProvider _provider = NhanVienProvider();
  final provider = DepartmentsProvider();

  StaffBloc() : super(StaffInitialState()) {
    on<LoadStaffs>((event, emit) async {
      emit(StaffLoadingState());
      _allStaffs = await _provider.fetchNhanViens();
      _allChucvus = await _provider.fetchChucVus();
      _allDepartments = await provider.fetchDepartments();

      emit(StaffLoaded(_allStaffs));
    });
    on<SearchStaff>((event, emit) {
      final searchLower = event.keyword.toLowerCase();
      final filtered =
          _allStaffs.where((item) {
            bool nameMatch = AppUtility.fuzzySearch(
              item.hoTen?.toLowerCase() ?? "",
              searchLower,
            );

            bool staffIdMatch =
                item.id?.toLowerCase().contains(searchLower) ?? false;

            bool staffOwnerMatch = AppUtility.fuzzySearch(
              item.nguoiQuanLy?.toLowerCase() ?? "",
              searchLower,
            );

            bool departmentMatch = AppUtility.fuzzySearch(
              item.boPhan?.toLowerCase() ?? "",
              searchLower,
            );

            bool positionMatch = AppUtility.fuzzySearch(
              item.chucVu?.toLowerCase() ?? "",
              searchLower,
            );

            return nameMatch ||
                staffIdMatch ||
                staffOwnerMatch ||
                departmentMatch ||
                positionMatch;
          }).toList();
      emit(StaffLoaded(filtered));
    });
    on<AddStaff>((event, emit) async {
      await _provider.addNhanVien(event.staff, event.staff.avatar);
      add(LoadStaffs());
    });
    on<UpdateStaff>((event, emit) async {
      await _provider.updateNhanVien(event.staff);
      add(LoadStaffs());
    });
    on<DeleteStaff>((event, emit) async {
      emit(StaffLoadingState());
      try {
        final result = await _provider.deleteNhanVien(event.staff.id ?? '');
        if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
          emit(DeleteStaffBatchSuccess());
          add(LoadStaffs());
        } else {
          emit(DeleteStaffBatchFailure(result['message'] ?? 'Xóa thất bại'));
        }
      } catch (e) {
        emit(DeleteStaffBatchFailure(e.toString()));
      }
    });
    on<DeleteStaffBatch>((event, emit) async {
      emit(StaffLoadingState());
      try {
        final result = await _provider.deleteNhanVienBatch(event.data);
        SGLog.warning('StaffBloc', 'DeleteStaffBatch | ${jsonEncode(result)}');
        if ((result['status_code'] == Numeral.STATUS_CODE_SUCCESS)) {
          emit(DeleteStaffBatchSuccess());
          add(LoadStaffs());
        } else {
          String message = 'Xóa danh sách nhân viên thất bại: ${result['message']}';
          emit(DeleteStaffBatchFailure(message));
        }
      } catch (e) {
        emit(DeleteStaffBatchFailure(e.toString()));
      }
    });
  }
  List<PhongBan> get department => _allDepartments;
  List<NhanVien> get staffs => _allStaffs;
  List<ChucVu> get chucvus => _allChucvus;
}
