import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/repository/departments_repository.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/staf_provider/nhan_vien_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'staff_event.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  List<NhanVien> _allStaffs = [];
  List<PhongBan> _allDepartments = [];
  List<ChucVu> _allChucvus = [];
  final NhanVienProvider _provider = NhanVienProvider();
  final provider = DepartmentRepository();

  StaffBloc() : super(StaffInitialState()) {
    on<LoadStaffs>((event, emit) async {
      emit(StaffLoadingState());
      // try {
      //   // _allStaffs = await _provider.fetchNhanViens();
      // } catch (e) {
      //   SGLog.error('StaffBloc', 'Fetch staffs failed: $e');
      //   emit(StaffError('Không thể tải danh sách nhân viên'));
      //   return;
      // }
      _allChucvus = await _provider.fetchChucVus();
      final idCongTy = AccountHelper.instance.getUserInfo()?.idCongTy ?? '';
      Map<String, dynamic> result = await provider.getListDepartment(idCongTy);

      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        _allDepartments = result['data'];
      } else {
        _allDepartments = <PhongBan>[];
      }
      log('allDepartments: ${_allDepartments.length}');

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
      final result = await _provider.addNhanVien(
        event.staff,
        event.staff.avatar,
      );
      if (checkStatusCodeDone(result)) {
        emit(AddStaffSuccessState('Thêm thành công'));
      } else {
        emit(StaffError(result['message'] ?? 'Thêm thất bại'));
      }
    });

    on<UpdateStaff>((event, emit) async {
      final result = await _provider.updateNhanVien(event.staff);
      log('UpdateStaff result: ${jsonEncode(result)}');
      if (checkStatusCodeDone(result)) {
        emit(UpdateStaffSuccessState('Cập nhật thành công'));
      } else {
        emit(StaffError(result['message'] ?? 'Cập nhật thất bại'));
      }
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
        SGLog.error('StaffBloc', 'DeleteStaff error: $e');
        emit(DeleteStaffBatchFailure('Lỗi hệ thống: ${e.toString()}'));
      }
    });
    on<DeleteStaffBatch>((event, emit) async {
      emit(StaffLoadingState());
      try {
        final result = await _provider.deleteNhanVienBatch(event.data);
        SGLog.info('StaffBloc', 'DeleteStaffBatch | ${jsonEncode(result)}');
        if ((result['status_code'] == Numeral.STATUS_CODE_SUCCESS)) {
          emit(DeleteStaffBatchSuccess());
          add(LoadStaffs());
        } else {
          String message =
              'Xóa danh sách nhân viên thất bại: ${result['message']}';
          emit(DeleteStaffBatchFailure(message));
        }
      } catch (e) {
        SGLog.error('StaffBloc', 'DeleteStaffBatch error: $e');
        emit(DeleteStaffBatchFailure('Lỗi hệ thống: ${e.toString()}'));
      }
    });
  }
  List<PhongBan> get department => _allDepartments;
  List<NhanVien> get staffs => _allStaffs;
  List<ChucVu> get chucvus => _allChucvus;
}
