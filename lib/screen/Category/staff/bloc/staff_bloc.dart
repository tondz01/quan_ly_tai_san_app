import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';
import 'staff_event.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  List<StaffDTO> _allStaffs = [];
  StaffBloc() : super(StaffInitial()) {
    on<LoadStaffs>((event, emit) {
      _allStaffs = List.from(event.staffs);
      emit(StaffLoaded(_allStaffs));
    });
    on<SearchStaff>((event, emit) {
      final keyword = event.keyword.toLowerCase();
      final filtered = _allStaffs.where((s) =>
        s.name.toLowerCase().contains(keyword) ||
        s.staffId.toLowerCase().contains(keyword)
      ).toList();
      emit(StaffLoaded(filtered));
    });
    on<AddStaff>((event, emit) {
      if (state is StaffLoaded) {
        final staffs = List<StaffDTO>.from((state as StaffLoaded).staffs);
        staffs.add(event.staff);
        emit(StaffLoaded(staffs));
      } else {
        emit(StaffLoaded([event.staff]));
      }
    });
    on<UpdateStaff>((event, emit) {
      if (state is StaffLoaded) {
        final staffs = List<StaffDTO>.from((state as StaffLoaded).staffs);
        final index = staffs.indexWhere((element) => element.staffId == event.staff.staffId);
        if (index != -1) {
          staffs[index] = event.staff;
        }
        emit(StaffLoaded(staffs));
      }
    });
    on<DeleteStaff>((event, emit) {
      if (state is StaffLoaded) {
        final staffs = List<StaffDTO>.from((state as StaffLoaded).staffs);
        staffs.removeWhere((element) => element.staffId == event.staff.staffId);
        emit(StaffLoaded(staffs));
      }
    });
  }
} 