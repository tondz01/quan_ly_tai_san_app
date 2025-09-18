import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/bloc/department_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/nhom_don_vi.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/providers/departments_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/staf_provider.dart/nhan_vien_provider.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  List<PhongBan> _allDepartments = [];
  List<NhomDonVi> _allDepartmentGroups = [];
  List<NhanVien> _allStaff = [];
  final provider = DepartmentsProvider();
  final staffProvider = NhanVienProvider();
  DepartmentBloc() : super(DepartmentInitial()) {
    on<LoadDepartments>((event, emit) async {
      _allDepartments = await provider.fetchDepartments();
      _allDepartmentGroups = await provider.fetchDepartmentGroups();
      _allStaff = await staffProvider.fetchNhanViens();
      emit(DepartmentLoaded(_allDepartments, _allDepartmentGroups));
    });
    on<SearchDepartment>((event, emit) {
      final searchLower = event.keyword.toLowerCase();
      final filtered =
          _allDepartments.where((item) {
            bool nameMatch = AppUtility.fuzzySearch(
              item.tenPhongBan?.toLowerCase() ?? '',
              searchLower,
            );

            bool staffIdMatch =
                item.id?.toLowerCase().contains(searchLower) ?? false;
           

            bool parentRoom = AppUtility.fuzzySearch(
              item.phongCapTren?.toLowerCase() ?? '',
              searchLower,
            );

            return nameMatch || staffIdMatch || parentRoom;
          }).toList();
      if (state is DepartmentLoaded) {
        final currentState = state as DepartmentLoaded;
        emit(currentState.copyWith(departments: filtered));
      }
    });
    on<AddDepartment>((event, emit) async {
      if (state is DepartmentLoaded) {
        await provider.addDepartment(event.department);
        add(LoadDepartments());
      } else {}
    });
    on<UpdateDepartment>((event, emit) async {
      if (state is DepartmentLoaded) {
        await provider.updateDepartment(event.department);
        add(LoadDepartments());
      }
    });
    on<DeleteDepartment>((event, emit) async {
      if (state is DepartmentLoaded) {
        await provider.deleteDepartment(event.department.id ?? '');
        add(LoadDepartments());
      }
    });
    on<DeleteDepartmentBatch>((event, emit) async {
      if (state is DepartmentLoaded) {
        await provider.deleteDepartmentBatch(event.data);
        add(LoadDepartments());
      }
    });
  }
  List<NhomDonVi> get departmentGroups => _allDepartmentGroups;
  List<PhongBan> get departments => _allDepartments;
  List<NhanVien?> get staffs => _allStaff;
}
