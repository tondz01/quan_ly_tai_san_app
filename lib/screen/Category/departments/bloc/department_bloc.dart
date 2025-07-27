import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  List<Department> _allDepartments = [];
  DepartmentBloc() : super(DepartmentInitial()) {
    on<LoadDepartments>((event, emit) {
      _allDepartments = List.from(event.departments);
      emit(DepartmentLoaded(_allDepartments));
    });
    on<SearchDepartment>((event, emit) {
      final keyword = event.keyword.toLowerCase();
      final filtered = _allDepartments.where((d) =>
        d.departmentName.toLowerCase().contains(keyword) ||
        d.departmentId.toLowerCase().contains(keyword)
      ).toList();
      emit(DepartmentLoaded(filtered));
    });
    on<AddDepartment>((event, emit) {
      if (state is DepartmentLoaded) {
        final departments = List<Department>.from(
          (state as DepartmentLoaded).departments,
        );
        departments.add(event.department);
        emit(DepartmentLoaded(departments));
      } else {
        emit(DepartmentLoaded([event.department]));
      }
    });
    on<UpdateDepartment>((event, emit) {
      if (state is DepartmentLoaded) {
        final departments = List<Department>.from(
          (state as DepartmentLoaded).departments,
        );
        final index = departments.indexWhere(
          (element) => element.departmentId == event.department.departmentId,
        );
        if (index != -1) {
          departments[index] = event.department;
        }
        emit(DepartmentLoaded(departments));
      }
    });
    on<DeleteDepartment>((event, emit) {
      if (state is DepartmentLoaded) {
        final departments = List<Department>.from(
          (state as DepartmentLoaded).departments,
        );
        departments.removeWhere(
          (element) => element.departmentId == event.department.departmentId,
        );
        emit(DepartmentLoaded(departments));
      }
    });
  }
  List<StaffDTO> staffs = sampleStaffDTOs();
}
