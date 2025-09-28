import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/bloc/department_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/constants/department_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/nhom_don_vi.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/providers/departments_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/staf_provider/nhan_vien_provider.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  List<PhongBan> _allDepartments = [];
  List<NhomDonVi> _allDepartmentGroups = [];
  List<NhanVien> _allStaff = [];
  final provider = DepartmentsProvider();
  final staffProvider = NhanVienProvider();
  DepartmentBloc() : super(DepartmentInitial()) {
    on<LoadDepartments>((event, emit) async {
      emit(DepartmentLoading());
      try {
        _allDepartments = await provider.fetchDepartments();
        _allDepartmentGroups = await provider.fetchDepartmentGroups();
        _allStaff = await staffProvider.fetchNhanViens();
        emit(DepartmentLoaded(_allDepartments, _allDepartmentGroups));
      } catch (e) {
        SGLog.error('DepartmentBloc', 'LoadDepartments error: $e');
        emit(DepartmentError(DepartmentConstants.errorLoadDepartments));
      }
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
      try {
        final result = await provider.addDepartment(event.department);
        if (checkStatusCodeDone(result)) {
          emit(AddDepartmentSuccess(DepartmentConstants.successAddDepartment));
          add(LoadDepartments());
        } else {
          emit(DepartmentError(result['message'] ?? DepartmentConstants.errorAddDepartment));
        }
      } catch (e) {
        SGLog.error('DepartmentBloc', 'AddDepartment error: $e');
        emit(DepartmentError(DepartmentConstants.errorAddDepartment));
      }
    });
    on<UpdateDepartment>((event, emit) async {
      try {
        final result = await provider.updateDepartment(event.department);
        if (checkStatusCodeDone(result)) {
          emit(UpdateDepartmentSuccess(DepartmentConstants.successUpdateDepartment));
          add(LoadDepartments());
        } else {
          emit(DepartmentError(result['message'] ?? DepartmentConstants.errorUpdateDepartment));
        }
      } catch (e) {
        SGLog.error('DepartmentBloc', 'UpdateDepartment error: $e');
        emit(DepartmentError(DepartmentConstants.errorUpdateDepartment));
      }
    });
    on<DeleteDepartment>((event, emit) async {
      try {
        final result = await provider.deleteDepartment(event.department.id ?? '');
        if (checkStatusCodeDone(result)) {
          emit(DeleteDepartmentSuccess(DepartmentConstants.successDeleteDepartment));
          add(LoadDepartments());
        } else {
          emit(DepartmentError(result['message'] ?? DepartmentConstants.errorDeleteDepartment));
        }
      } catch (e) {
        SGLog.error('DepartmentBloc', 'DeleteDepartment error: $e');
        emit(DepartmentError(DepartmentConstants.errorDeleteDepartment));
      }
    });
    on<DeleteDepartmentBatch>((event, emit) async {
      try {
        final result = await provider.deleteDepartmentBatch(event.data);
        if (checkStatusCodeDone(result)) {
          emit(DeleteDepartmentBatchSuccess());
          add(LoadDepartments());
        } else {
          emit(DeleteDepartmentBatchFailure(result['message'] ?? DepartmentConstants.errorDeleteDepartment));
        }
      } catch (e) {
        SGLog.error('DepartmentBloc', 'DeleteDepartmentBatch error: $e');
        emit(DeleteDepartmentBatchFailure(DepartmentConstants.errorDeleteDepartment));
      }
    });
  }
  List<NhomDonVi> get departmentGroups => _allDepartmentGroups;
  List<PhongBan> get departments => _allDepartments;
  List<NhanVien?> get staffs => _allStaff;
}
