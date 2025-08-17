import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/providers/departments_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/staf_provider.dart/nhan_vien_provider.dart';
import 'staff_event.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  List<NhanVien> _allStaffs = [];
  List<PhongBan> _allDepartments = [];
  List<ChucVu> _allChucvus = [];
  final NhanVienProvider _provider = NhanVienProvider();
  final provider = DepartmentsProvider();

  StaffBloc() : super(StaffInitial()) {
    on<LoadStaffs>((event, emit) async {
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
      await _provider.addNhanVien(event.staff, event.staff.chuKyData);
      add(LoadStaffs());
    });
    on<UpdateStaff>((event, emit) async {
         await _provider.updateNhanVien(event.staff, event.staff.chuKyData);

      add(LoadStaffs());

    });
    on<DeleteStaff>((event, emit) {
      if (state is StaffLoaded) {
        final staffs = List<NhanVien>.from((state as StaffLoaded).staffs);
        staffs.removeWhere((element) => element.id == event.staff.id);
        emit(StaffLoaded(staffs));
      }
    });
  }
  List<PhongBan> get department => _allDepartments;
  List<NhanVien> get staffs => _allStaffs;
  List<ChucVu> get chucvus => _allChucvus;
}
