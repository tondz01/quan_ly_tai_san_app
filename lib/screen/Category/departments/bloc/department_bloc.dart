import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/bloc/department_state.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/models/staff.dart';
import '../models/department.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  DepartmentBloc() : super(DepartmentInitial()) {
    on<LoadDepartments>((event, emit) {
      emit(DepartmentLoaded(List.from(event.departments)));
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
